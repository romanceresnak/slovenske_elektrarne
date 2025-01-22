import requests

api_url = "https://your-api-gateway-url/questions"
response = requests.get(api_url, params={"question": "What is this document about?"})
print(response.json())