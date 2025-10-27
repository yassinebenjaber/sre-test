import os
import json
import boto3
import datetime

# Initialize AWS clients once (reuse connection)
sqs = boto3.client("sqs")
s3 = boto3.client("s3")

QUEUE_URL = os.environ["QUEUE_URL"]
LOG_BUCKET = os.environ["LOG_BUCKET"]

def lambda_handler(event, context):
    try:
        # Parse request body from API Gateway
        body = json.loads(event.get("body", "{}"))
        order_id = body.get("id", "unknown")

        # Send message to SQS
        response = sqs.send_message(
            QueueUrl=QUEUE_URL,
            MessageBody=json.dumps({
                "order_id": order_id,
                "timestamp": datetime.datetime.utcnow().isoformat()
            })
        )

        # Log to S3
        log_data = {
            "order_id": order_id,
            "request_id": context.aws_request_id,
            "timestamp": datetime.datetime.utcnow().isoformat(),
            "sqs_message_id": response.get("MessageId")
        }
        key = f"logs/{order_id}-{context.aws_request_id}.json"
        s3.put_object(
            Bucket=LOG_BUCKET,
            Key=key,
            Body=json.dumps(log_data).encode("utf-8"),
            ContentType="application/json"
        )

        print(f"Logged order {order_id} to S3 and sent to SQS.")

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": f"Order {order_id} received and logged.",
                "sqs_message_id": response.get("MessageId")
            })
        }

    except Exception as e:
        print(f"Error: {e}")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
