#!/bin/bash
AWS_REGION=us-east-1
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
S3_BUCKET_NAME="site-${AWS_ACCOUNT_ID}-${AWS_REGION}"

echo "AWS Account ID: ${AWS_ACCOUNT_ID}"
echo "AWS Region: ${AWS_REGION}"
echo "S3 Bucket Name: ${S3_BUCKET_NAME}"

function upload_static_files() {
    # Upload contents of /frontend directory to S3 bucket
    aws s3 sync ./frontend s3://${S3_BUCKET_NAME}

    # Invalidate CloudFront cache for updated files
    # aws cloudfront create-invalidation --distribution-id ${CLOUDFRONT_DISTRIBUTION_ID} --paths '/*'
}

function build_sam_template() {
    am validate --lint
    sam build
}

function deploy_sam_template() {
    sam deploy --guided
}

echo "Please select an option from the list below:"
echo "1. Build the SAM template (runs 'sam build' and 'sam validate --lint')"
echo "2. Build and deploy the SAM template (runs Option 1 and 'sam deploy --guided')"
echo "3. Upload static files to the S3 site bucket"
echo "4. Build, deploy the SAM template, and upload site files (runs Options 2 and 3)"

read -p "Enter the number corresponding to your choice (1-4): " option

case $option in
    1)
        build_sam_template
        ;;
    2)
        build_sam_template
        deploy_sam_template
        ;;
    3)
        upload_static_files
        ;;
    4)
        build_sam_template
        deploy_sam_template
        upload_static_files
        ;;
    *)
        echo "Invalid option. Please enter a number between 1 and 4."
        ;;
esac
