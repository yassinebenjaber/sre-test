import json

def lambda_handler(event, context):
    for record in event['Records']:
        order_id = record['body']
        print(f"Processed order: {order_id}")
    return {"statusCode": 200}
