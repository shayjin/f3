# Use the official AWS Lambda Python 3.11 base image
FROM public.ecr.aws/lambda/python:3.11

# Copy requirements and install dependencies
COPY .env ${LAMBDA_TASK_ROOT}
COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

# Copy application code into the container
COPY ./Backend ${LAMBDA_TASK_ROOT}/app

# Specify the Lambda function handler (app.main.handler) 
CMD ["app.lambda_handler.handler"]  