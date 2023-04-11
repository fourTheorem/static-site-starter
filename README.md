# Static Site Starter 

A static site starter template for setting up serverless projects using [AWS SAM](https://aws.amazon.com/serverless/sam/).

The project configures an S3 bucket with a CloudFront distribution to serve static content. The project also includes scripts to deploy, update, and delete the application stack. 


## Project structure 
The project is laid out with the all files in the root directory, but it is recommended that you add your frontend application source code and build directory to a `frontend` subdirectory.

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

![Static site starter architecture diagram](architecture-diagram.png)

A CloudFront distribution serves static content using the S3 bucket as the origin. The CloudFront distribution is configured to use the S3 bucket as the origin. These resources are always provisioned. 

Optionally users can can configure the template to use a custom domain name. If the user provides a Route53 Hosted Zone ID the template will edit an existing hosted zone. If the user does not provide a Route53 Hosted Zone ID the template will create a new one. An ACM certificate is created for the custom domain name which edits the hosted zone to add an Alias record for the CloudFront distribution.

CloudWatch Internet Monitor is used to monitor the health of the domain name. If the domain name does not respond to a request 3 times, the CloudWatch Internet Monitor will trigger an alarm. 

Although a frontend appliation is not included in the frontend starter 

## Requirements 

- [AWS CLI](https://aws.amazon.com/cli/) installed and configured with your AWS account credentials.
- [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html) installed.

## Setup process
1. Clone the repository
```bash 
git clone https://github.com/fourTheorem/frontend-starter.git
cd frontend-starter
```

2. Build your frontend application in the `frontend` directory and make sure the build files are in the `/frontend/dist`. 

If you want to build a React.js application, you can use the following commands:
```bash
cd frontend
./setup.sh
```

3. Build and deploy the SAM template
```bash
## package the template
`sam build`

## Deploy the template
## This will prompt you to add CloudFormation parameters
`sam deploy --guided`
```

4. Deploy your frontend to the S3 bucket
```bash
chmod +x deploy.sh
./deploy.sh
```


## Deploying the application

To build and deploy your application for the first time, run the following in your shell:

```bash
cd sam 
sam build
sam deploy --guided
```


## Remove application

```bash
cd sam 
sam remove --stack-name <stackName>
```

