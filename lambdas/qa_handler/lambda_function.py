import boto3
import json
from opensearchpy import OpenSearch

def lambda_handler(event, context):
    question = event['queryStringParameters']['question']

    client = OpenSearch(
        hosts=[{'host': 'your-opensearch-endpoint', 'port': 443}],
        http_auth=('username', 'password'),
        use_ssl=True
    )

    query = {"query": {"match": {"content": question}}}
    response = client.search(index="documents", body=query)
    context_text = " ".join([hit['_source']['content'] for hit in response['hits']['hits']])

    sagemaker_runtime = boto3.client('sagemaker-runtime')
    sm_response = sagemaker_runtime.invoke_endpoint(
        EndpointName='qa-endpoint',
        ContentType='application/json',
        Body=json.dumps({"question": question, "context": context_text})
    )

    answer = json.loads(sm_response['Body'].read().decode())['answer']
    return {"statusCode": 200, "body": json.dumps({"answer": answer})}
