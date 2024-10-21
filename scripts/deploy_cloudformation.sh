#!/bin/bash

# Deploy CloudFormation stacks

# Set your AWS region
AWS_REGION="us-west-2"

# Deploy network stack
aws cloudformation create-stack \
  --stack-name my-network-stack \
  --template-body file://cloudformation/network.yaml \
  --region $AWS_REGION

# Wait for network stack to complete
aws cloudformation wait stack-create-complete \
  --stack-name my-network-stack \
  --region $AWS_REGION

# Get VPC and subnet IDs
VPC_ID=$(aws cloudformation describe-stacks \
  --stack-name my-network-stack \
  --query "Stacks[0].Outputs[?OutputKey=='VPC'].OutputValue" \
  --output text \
  --region $AWS_REGION)

PUBLIC_SUBNET_ID=$(aws cloudformation describe-stacks \
  --stack-name my-network-stack \
  --query "Stacks[0].Outputs[?OutputKey=='PublicSubnet1'].OutputValue" \
  --output text \
  --region $AWS_REGION)

PRIVATE_SUBNET_ID=$(aws cloudformation describe-stacks \
  --stack-name my-network-stack \
  --query "Stacks[0].Outputs[?OutputKey=='PrivateSubnet1'].OutputValue" \
  --output text \
  --region $AWS_REGION)

# Deploy EC2 stack
aws cloudformation create-stack \
  --stack-name my-ec2-stack \
  --template-body file://cloudformation/ec2.yaml \
  --parameters \
    ParameterKey=VPC,ParameterValue=$VPC_ID \
    ParameterKey=PublicSubnet,ParameterValue=$PUBLIC_SUBNET_ID \
    ParameterKey=KeyName,ParameterValue=your-key-pair-name \
  --region $AWS_REGION

# Wait for EC2 stack to complete
aws cloudformation wait stack-create-complete \
  --stack-name my-ec2-stack \
  --region $AWS_REGION

# Deploy RDS stack
aws cloudformation create-stack \
  --stack-name my-rds-stack \
  --template-body file://cloudformation/rds.yaml \
  --parameters \
    ParameterKey=VPC,ParameterValue=$VPC_ID \
    ParameterKey=PrivateSubnet1,ParameterValue=$PRIVATE_SUBNET_ID \
    ParameterKey=PrivateSubnet2,ParameterValue=$PRIVATE_SUBNET_ID \
    ParameterKey=DBUsername,ParameterValue=admin \
    ParameterKey=DBPassword,ParameterValue=your-db-password \
  --region $AWS_REGION

# Wait for RDS stack to complete
aws cloudformation wait stack-create-complete \
  --stack-name my-rds-stack \
  --region $AWS_REGION

# Deploy ALB stack
aws cloudformation create-stack \
  --stack-name my-alb-stack \
  --template-body file://cloudformation/alb.yaml \
  --parameters \
    ParameterKey=VPC,ParameterValue=$VPC_ID \
    ParameterKey=PublicSubnet1,ParameterValue=$PUBLIC_SUBNET_ID \
    ParameterKey=PublicSubnet2,ParameterValue=$PUBLIC_SUBNET_ID \
    ParameterKey=WebServerInstance,ParameterValue=$(aws cloudformation describe-stacks \
      --stack-name my-ec2-stack \
      --query "Stacks[0].Outputs[?OutputKey=='WebServerInstance'].OutputValue" \
      --output text \
      --region $AWS_REGION) \
  --region $AWS_REGION

# Wait for ALB stack to complete
aws cloudformation wait stack-create-complete \
  --stack-name my-alb-stack \
  --region $AWS_REGION

echo "Deployment complete!"