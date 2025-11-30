#!/bin/bash

# Create deployment directory
mkdir -p lambda-deploy
cd lambda-deploy

# Install dependencies locally
pip install -r ../requirements-lambda.txt -t .

# Copy backend code
cp -r ../Backend/* .

# Create zip file
zip -r ../lambda-deployment.zip . -x "*.pyc" "__pycache__/*"

cd ..

# Create/update Lambda function
aws lambda create-function \
  --function-name medical-assistant-api \
  --runtime python3.11 \
  --role arn:aws:iam::699757598826:role/lambda-execution-role \
  --handler lambda_handler.handler \
  --zip-file fileb://lambda-deployment.zip \
  --region us-west-2 \
  --timeout 30 \
  --memory-size 512

# Clean up
rm -rf lambda-deploy