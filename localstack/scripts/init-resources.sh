#!/bin/bash
# Initialize LocalStack resources on container startup

set -e

export AWS_REGION=us-east-1
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1

# Wait for LocalStack to be ready
echo "Waiting for LocalStack to be ready..."
for i in {1..30}; do
  if curl -s http://localhost:4566/_localstack/health | grep -q '"services"'; then
    echo "LocalStack is ready!"
    break
  fi
  echo "Attempt $i/30..."
  sleep 2
done

echo "Initializing AWS resources..."

# Create S3 bucket
echo "Creating S3 bucket..."
aws s3api create-bucket \
  --bucket saa-lab-bucket \
  --region us-east-1 \
  --endpoint-url http://localhost:4566 2>/dev/null || echo "Bucket already exists"

# Create DynamoDB table
echo "Creating DynamoDB table..."
aws dynamodb create-table \
  --table-name SAALabTable \
  --attribute-definitions AttributeName=id,AttributeType=S \
  --key-schema AttributeName=id,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --endpoint-url http://localhost:4566 \
  --region us-east-1 2>/dev/null || echo "Table already exists"

# Create IAM role
echo "Creating IAM role..."
aws iam create-role \
  --role-name SAALocalStackRole \
  --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }' \
  --endpoint-url http://localhost:4566 \
  --region us-east-1 2>/dev/null || echo "Role already exists"

echo "LocalStack initialization complete!"
