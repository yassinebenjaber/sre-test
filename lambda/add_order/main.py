import os
import json
import boto3
import datetime

# Initialize AWS clients once per container
sqs = boto3.client("sqs")
s3 = boto3.client("s3")

# Fetch environment variables (Terraform injects these)
QUEUE_URL = os.environ.get("QUEUE_URL")
LOG_BUCKET = os.environ.get("LOG_BUCKET")

def lambda_handler(event, context):
    try:
        if not QUEUE_URL or not LOG_BUCKET:
            raise ValueError("Missing QUEUE_URL or LOG_BUCKET environment variable")

        # Parse JSON body safely
        body = event.get("body")
        if not body:
            raise ValueError("Empty request body")

        data = json.loads(body)
        order_id = data.get("id")
        if not order_id:
            raise ValueError("Missing 'id' in request body")

        # Send message to SQS
        sqs_response = sqs.send_message(
            QueueUrl=QUEUE_URL,
            MessageBody=json.dumps({
                "order_id": order_id,
                "timestamp": datetime.datetime.utcnow().isoformat()
            })
        )

        # Create structured log entry
        log_entry = {
            "order_id": order_id,
            "sqs_message_id": sqs_response.get("MessageId"),
            "lambda_request_id": context.aws_request_id,
            "timestamp": datetime.datetime.utcnow().isoformat()
        }

        # Write log entry to S3
        log_key = f"logs/{order_id}-{context.aws_request_id}.json"
        s3.put_object(
            Bucket=LOG_BUCKET,
            Key=log_key,
            Body=json.dumps(log_entry),
            ContentType="application/json"
        )

        print(f"Order {order_id} logged to {LOG_BUCKET}/{log_key}")

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": f"Order {order_id} received and logged",
                "sqs_message_id": sqs_response.get("MessageId")
            })
        }

    except Exception as e:
        print(f"Error: {e}")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
