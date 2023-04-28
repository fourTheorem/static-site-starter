# {{ cookiecutter.project_name }}

{{ cookiecutter.project_description }}

The project includes an [AWS SAM](https://aws.amazon.com/serverless/sam/) template that configures an S3 bucket with a CloudFront distribution to serve static content. The project also includes a script to deploy, update, and delete the application stack. 

The template uses [cookiecutter](https://cookiecutter.readthedocs.io/en/stable/) to allow users to easily create a new project using this template.


## Project structure 
The project is laid out with the all files in the {{cookiecutter.project_name}} directory, which will be renamed to your project's name when you create a new project using the `sam init` command.

```
project-root/
│
├─ frontend/
│   ├─ dist/
│   ├─ package.json
│   └─ ... (other frontend files and directories)
├─ template.yaml
├─ ... (other AWS SAM files and directories)
├─ deploy.sh
├─ .gitignore
└─ README.md
```

## Project architecture diagram 

![Static site starter architecture diagram](./%7B%7Bcookiecutter.project_name%7D%7D/architecture-diagrams/architecture.png)


The template provisions a CloudFront distribution to serve static content from an S3 bucket (the origin). 

Optionally users can configure the template to use a custom domain name. If a Route53 Hosted Zone ID is provided as a SAM parameter the template will edit that existing hosted zone, otherwise a new hosted zone will be created. An ACM certificate is created for the custom domain name which edits the hosted zone to add an Alias record for the CloudFront distribution.

CloudWatch Internet Monitor is used to monitor the health of the domain name. If the domain name does not respond to a request 3 times, the CloudWatch Internet Monitor will trigger an alarm. 

A HTML file is included in the `frontend` directory to show how a site can be deployed to the S3 bucket. This file can be uploaded to the site's S3 bucket using the `deploy.sh` script.

## Requirements 

- [AWS CLI](https://aws.amazon.com/cli/) installed and configured with your AWS account credentials.
- [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html) installed.

Using AWS Certificate Manager with a CloudFront distributions requires that the [stack be deployed in the `us-east-1` region](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cnames-and-https-requirements.html). Since CloudFront is a global service, the distribution will be available in all regions and performant for users in all regions, for this reason the SAM template **must** be deployed in the `us-east-1` region


## Setting up a project from the template

1. Initialise the project using the AWS SAM CLI

```bash
sam init --location https://github.com/fourTheorem/static-site-starter.git
# You will now be prompted to set cookiecutter template values
# Please provide values for the following parameters:
# project_name [your project name]:
# project_description [Project description]:

```

## Deploying the application

To build and deploy the application after setting up a project from the template, simply run the provided deploy.sh script:

```bash
cd <your project name>
chmod +x deploy.sh
./deploy.sh
# You will be prompted to select an action, choose option 1 to Validate, build, and deploy the SAM template
```

## Deploy site to S3 bucket 

To upload your static files to the S3 site bucket, run the deploy.sh script again:

```bash
./deploy.sh
# You will be prompted to select an action, choose option 3 to Upload static files to the S3 site bucket
```

The starter comes with a simple Hello World `index.html` page in the frontend directory, but it can serve any static website or single page application (like React). For examples on setting up a frontend using a framework such as React or Vue, you can view the [Vite Docs](https://vitejs.dev/guide/).

The `deploy.sh` assumes that your frontend build files are in the `/frontend` directory. If your frontend build files are in a different directory, you can edit the `deploy.sh` script to point to the correct directory.

## Remove application
To remove the application, use the deploy.sh script once more:

```bash
./deploy.sh
# You will be prompted to select an action, choose option 3 to Clean up - Delete S3 bucket contents and delete the stack
# Then enter your stack name when prompted
```

# Costs
When using this template, you will be billed depending on the number of requests to the S3 bucket and CloudFront distribution, and the number of times the CloudWatch Internet Monitor checks the CloudFront distribution. For small websites that won't receive heavy traffic most of these services will fall under the free tier.

It is worth noting that CloudWatch Internet Monitor is the most expensive service by far for hosting a small site. 

Here is a sample cost estimate for a website with 1GB of static assets that receives 1000 views per month:
https://calculator.aws/#/estimate?id=dcf37a539e4761fa0af292a5858f17c1967275bf


## Deploying an application without a custom domain name 
This is the simplest way to deploy an application.
![minimal architecture diagram](/%7B%7Bcookiecutter.project_name%7D%7D/architecture-diagrams/minimal.png)

1. Run `./deploy.sh` and select option 1 to validate, build, and deploy the SAM template
2. When prompted set the CloudFormation parameters 'DomainName', 'ACMCertificateArn', and 'ExistingHostedZoneID' to empty strings (just hit enter)
3. Access the website at the CloudFront distribution url outputted from the CloudFormation stack

## Deploying an application using a domain name that is not managed by Route53
![external dns architecture diagram](/%7B%7Bcookiecutter.project_name%7D%7D/architecture-diagrams/external-dns.png)

1. Run `./deploy.sh` and select option 1 to validate, build, and deploy the SAM template
2. When prompted set the parameter 'DomainName' to the subdomain of your app (eg. 'example.com')
3. Set the parameters 'ACMCertificateArn' and 'ExistingHostedZoneID' to empty strings
4. Login to the DNS registrar to access the domain name's hosted zone
5. Create a new CNAME record for the domain name that points to the CloudFront distribution url (this is an output of the CloudFormation stack)
6. Validate the domain name:
  - Go to the ACM console after the stack has been deployed
  - Locate a newly created certificate for the domain name
  - Click the 'Actions' button and select 'Validate certificate'
  - Follow the instructions to validate the domain name manually

These changes will take a few minutes to propagate, then you should be able to access the website at `example.com` when you deploy your site to the S3 frontend bucket.

## Deploying your application as a subdomain where the apex domain nameserver managed by a 3rd party registrar

![subdomain architecture diagram](./%7B%7Bcookiecutter.project_name%7D%7D/architecture-diagrams/subdomain-external-dns.png)


1. Set the CloudFormation parameter 'DomainName' to the subdomain of your app (eg. 'subdomain.example.com')
2. Deploy the template
3. In the CloudFormation console click on the 'Events' tab and wait for the certificate resource to be created. The status of this resource will have a message in the following structure: "Content of DNS Record is: {Name: _abc.subdomain.example.com,Type: CNAME,Value: _abc.abc.acm-validations.aws.}". This is the DNS record that needs to be added to the apex domain name's hosted zone in the following form:

```
Name: _111abcdef.subdomain.example.com
Type: CNAME
Value: _abc.111abcdef.acm-validations.aws.
```

3. Log into the DNS registrar for the apex domain name
4. Create a CNAME record for the subdomain that points to the CloudFront distribution url (this is an output of the CloudFormation stack)

The new record's values should look like this:
```
Name: subdomain.example.com
Type: CNAME
Value: d111111abcdef.cloudfront.net
```
These changes will take a few minutes to propagate, then you should be able to access the website at `subdomain.example.com` when you deploy your site to the S3 frontend bucket.
