#!/bin/bash

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
AWS_REGION=$(aws configure get region)
S3_BUCKET_NAME="frontend-starter-${AWS_ACCOUNT_ID}-${AWS_REGION}"

echo "AWS Account ID: ${AWS_ACCOUNT_ID}"
echo "AWS Region: ${AWS_REGION}"
echo "S3 Bucket Name: ${S3_BUCKET_NAME}"
 
# Delete contents of S3 bucket (if it exists)
aws s3 rm s3://${S3_BUCKET_NAME} --recursive

# Upload contents of /frontend/dist directory to S3 bucket
aws s3 sync ./frontend/dist s3://${S3_BUCKET_NAME}

# Invalidate CloudFront cache for updated files
# aws cloudfront create-invalidation --distribution-id ${CLOUDFRONT_DISTRIBUTION_ID} --paths '/*'