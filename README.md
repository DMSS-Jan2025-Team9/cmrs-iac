# cmrs-iac
Centralized IaC configuration for both the frontend and backend


# References
1) Follow this guide to install the terraform cli to your PC
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

- https://developer.hashicorp.com/terraform/install


2) Guide for IAC - RDS: https://awstip.com/infrastructure-as-code-iac-terraform-aws-e87cd76d27e5

# First time configure AWS credential in your PC
run below commands:
aws configure
export AWS_ACCESS_KEY_ID=AKIAYQNJSSH7J5JIHHQZ
export AWS_SECRET_ACCESS_KEY=O/0zs87m1c8I/y65m7WQQ60uvg4MA5MAyuJZifNo
export AWS_DEFAULT_REGION=ap-southeast-1

# First time installation
1) clone the project folder:
git clone https://github.com/DMSS-Jan2025-Team9/cmrs-iac.git

2) Navigate to the project folder:
cd cmrs-iac

3) Update/Create new resource folder then navigate to the resource folder 
4) run terraform commands:
terraform init
terraform plan 
terraform apply

# Terraform remote state - store in AWS s3 bucket
reference: https://spacelift.io/blog/terraform-s3-backend & https://stackoverflow.com/questions/47913041/initial-setup-of-terraform-backend-using-terraform
1) cd remote-tf-state
2) run terraform commands:
terraform init
terraform plan 
terraform apply

Notes: all the terraform state can be found from AWS S3 bucket
https://ap-southeast-1.console.aws.amazon.com/s3/buckets/cmrs-terraform-state?region=ap-southeast-1&bucketType=general&tab=objects

# RDS creation (Already refactor to the terraform modules)
1) Navigate to rds folder
2) run terraform commands:
terraform init
terraform plan 
terraform apply

# S3 bucket creation - frontend s3 bucket and cloudfront
1) Navigate to s3 folder
2) run terraform commands:
terraform init
terraform plan  -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"


# network creation - VPC, subnets, security groups
1) navigate to envs/dev folder
2) run terraform commands:
terraform init
terraform plan  -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"


# Frontend CI/CD - using GitHub & AWS S3 + CloudFront
Setup:
1) Create s3 bucket and setup cloudfront using IAC script - S3 folder
2) Integrate Github action for CI/CD

https://blog.everestek.com/deploy-react-app-to-aws-s3-using-terraform/
https://medium.com/cloud-native-daily/mastering-ci-cd-deploying-a-react-js-app-to-aws-s3-with-github-actions-and-hosting-it-b1ce82360331

React -> Github action -> Amazon S3 -> CloudFront

1) AWS S3 bucket for frontend file: cmrs-frontend-hosting
URL: https://ap-southeast-1.console.aws.amazon.com/s3/buckets/cmrs-frontend-hosting?region=ap-southeast-1&bucketType=general&tab=objects
2) Frontend CloudFront URL: https://d1x5otaft5jht9.cloudfront.net/login


# Backend CI/CD using AWS and GitHub Action
Setup:
1) create ECR repository
2) create ECS Task definition, cluster, service
3) Integrate with Github action

Reference: https://kiranpawar.hashnode.dev/setting-up-a-cicd-pipeline-for-a-spring-boot-application-on-aws

https://github.com/in28minutes/deploy-spring-microservices-to-aws-ecs-fargate

https://docs.github.com/en/actions/use-cases-and-examples/deploying/deploying-to-amazon-elastic-container-service

# CODE REFACTORING - MODULARISED the code
1) envs/bootstrap - only need to run once
2) envs/dev - DEV environment
   run terraform commands:
    terraform init
    terraform plan  -var-file="terraform.tfvars"
    terraform apply -var-file="terraform.tfvars"

# Self signed certificate generation
openssl genpkey -algorithm RSA -out cmrs.com.sg.key -pkeyopt rsa_keygen_bits:2048
openssl req -new -key cmrs.com.sg.key -out cmrs.com.sg.csr -config alb_ssl.conf

openssl x509 -req -in cmrs.com.sg.csr -signkey cmrs.com.sg.key -out cmrs.com.sg.crt -days 365 -extensions req_ext -extfile alb_ssl.conf
openssl x509 -in cmrs.com.sg.crt -noout -text



# AWS Credential
DEFAULT_ACCOUNT=585008058878

Console sign-in URL: https://585008058878.signin.aws.amazon.com/console
User name: u-admin
Console password: MbYZ@2)9
export AWS_ACCESS_KEY_ID=AKIAYQNJSSH7DTALL5UJ
export AWS_SECRET_ACCESS_KEY=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

Console sign-in URL: https://585008058878.signin.aws.amazon.com/console
User name: u-iac
Console password: i@V5^s3F
export AWS_ACCESS_KEY_ID=AKIAYQNJSSH7PPJDCNA5
export AWS_SECRET_ACCESS_KEY=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

u-IAC - RUN AWS configure and input the access key and secret key
ACCESS KEY = AKIAYQNJSSH7J5JIHHQZ
Secret key = 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
default region = ap-southeast-1