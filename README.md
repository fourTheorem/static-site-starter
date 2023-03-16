# Frontend Starter 

Frontend starter template for setting up serverless projects using [AWS SAM](https://aws.amazon.com/serverless/sam/).

The project configures a simple S3 bucket with a CloudFront distribution to serve static content. The project also includes scripts to deploy, update, and delete the application stack. 

## Project architecture diagram 


## Requirements 

* SAM CLI - [Install the SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html)
* Node.js - [Install Node.js 18](https://nodejs.org/en/), including the NPM package management tool.
* Docker - [Install Docker community edition](https://hub.docker.com/search/?type=edition&offering=community)


## Deploying the application

To build and deploy your application for the first time, run the following in your shell:

```bash
sam build
sam deploy --guided
```


## Remove application

```bash
sam remove --stack-name <stackName>
```
