#!/bin/bash
export AWS_REGION=us-east-1
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
export S3_BUCKET_NAME="site-${AWS_ACCOUNT_ID}-${AWS_REGION}"

echo "AWS Account ID: ${AWS_ACCOUNT_ID}"
echo "AWS Region: ${AWS_REGION}"
echo "S3 Bucket Name: ${S3_BUCKET_NAME}"

function upload_static_files() {
    # Upload contents of /frontend directory to S3 bucket
    aws s3 sync ./frontend s3://${S3_BUCKET_NAME}
}

function build_and_deploy_sam_template() {
    sam validate --lint
    sam build
    sam deploy --guided
}

function clean_up() {
    # Delete S3 bucket contents
    aws s3 rm s3://${S3_BUCKET_NAME} --recursive

    # Delete the stack using sam delete
    sam delete --stack-name ${STACK_NAME} --region us-east-1
}

echo "Please select an option from the list below:"
echo "1. Init - Validate, build, and deploy the SAM template"
echo "2. Deploy - Deploy the website to S3"
echo "3. Clean up - Delete S3 bucket contents and delete the stack"

read -p "Enter the number corresponding to your choice (1-3): " option

case $option in
    1)
        build_and_deploy_sam_template
        ;;
    2)
        upload_static_files
        ;;
    3)
        read -p "Enter the stack name: " STACK_NAME
        clean_up
        ;;
    *)
        echo "Invalid option. Please enter a number between 1 and 3."
        ;;
esac
