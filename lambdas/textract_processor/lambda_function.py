import boto3
from opensearchpy import OpenSearch

def lambda_handler(event, context):
    s3_bucket = event['Records'][0]['s3']['bucket']['name']
    s3_key = event['Records'][0]['s3']['object']['key']

    textract = boto3.client('textract')
    response = textract.detect_document_text(
        Document={'S3Object': {'Bucket': s3_bucket, 'Name': s3_key}}
    )
    
    text = " ".join([block['Text'] for block in response['Blocks'] if block['BlockType'] == 'LINE'])

    client = OpenSearch(
        hosts=[{'host': 'your-opensearch-endpoint', 'port': 443}],
        http_auth=('username', 'password'),
        use_ssl=True
    )
    
    client.index(
        index="documents",
        body={"content": text}
    )
    return {"statusCode": 200}
