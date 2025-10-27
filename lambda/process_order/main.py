import json
import boto3

def lambda_handler(event, context):
    for record in event['Records']:
        try:
            body = json.loads(record['body'])
            order_id = body.get('order_id')
            timestamp = body.get('timestamp')
            print(f"Processed order: {order_id} at {timestamp}")
        except Exception as e:
            print(f"Error processing record: {e}")
    return {"statusCode": 200}
