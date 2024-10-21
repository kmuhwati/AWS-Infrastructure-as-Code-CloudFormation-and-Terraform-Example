#!/bin/bash

# Deploy Terraform infrastructure

# Set your AWS credentials (or use AWS CLI configuration)
# export AWS_ACCESS_KEY_ID="your-access-key"
# export AWS_SECRET_ACCESS_KEY="your-secret-key"
# export AWS_DEFAULT_REGION="us-west-2"

# Navigate to the Terraform directory
cd terraform

# Initialize Terraform
terraform init

# Plan the deployment
terraform plan -out=tfplan

# Apply the changes
terraform apply tfplan

echo "Deployment complete!"