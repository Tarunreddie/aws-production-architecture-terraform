# aws-production-architecture-terraform
# AWS Production-Grade Architecture with Terraform

## Overview
This repo provisions a production-style AWS environment using Terraform:
- VPC with public/private subnets across 2 AZs
- Internet Gateway + NAT Gateway
- Application Load Balancer (public)
- Auto Scaling Group of EC2 instances (private)
- IAM role for EC2 (CloudWatch Agent policy)
- S3 bucket (private)
- Security groups with least-privilege access

## Architecture
Client → ALB (Public Subnets) → EC2 ASG (Private Subnets)  
Private subnets egress via NAT Gateway.

## How to Deploy
1. Configure AWS credentials
2. terraform init
3. terraform plan
4. terraform apply

## Output
After apply, Terraform prints the ALB DNS name. Open it in browser to see the nginx page.

## Skills Demonstrated
AWS networking, high availability, security groups, ALB/ASG, IaC (Terraform), IAM.

