#!/bin/bash

# Build Docker image
docker build -t medical-assistant-lambda .

# Tag for ECR
docker tag medical-assistant-lambda:latest 699757598826.dkr.ecr.us-west-2.amazonaws.com/medical-assistant-lambda:latest

# Push to ECR (run these commands first)
# aws ecr create-repository --repository-name medical-assistant-lambda --region us-west-2
# aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 699757598826.dkr.ecr.us-west-2.amazonaws.com

docker push 699757598826.dkr.ecr.us-west-2.amazonaws.com/medical-assistant-lambda:latest

# Create/update Lambda function
aws lambda create-function \
  --function-name medical-assistant-api \
  --package-type Image \
  --code ImageUri=699757598826.dkr.ecr.us-west-2.amazonaws.com/medical-assistant-lambda:latest \
  --role arn:aws:iam::699757598826:role/lambda-execution-role \
  --region us-west-2 \
  --timeout 30 \
  --memory-size 512