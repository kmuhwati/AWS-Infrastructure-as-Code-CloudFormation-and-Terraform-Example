# AWS Infrastructure as Code: CloudFormation and Terraform Example

Author: Kumbirai Muhwati

## Overview

This project demonstrates how to create a fully functional AWS environment using both CloudFormation and Terraform. It includes templates for setting up a basic web application infrastructure with the following components:

- VPC with public and private subnets
- EC2 instance for a web server
- RDS instance for a database
- Security groups
- Application Load Balancer

## Repository Structure

```
.
├── cloudformation/
│   ├── network.yaml
│   ├── ec2.yaml
│   ├── rds.yaml
│   └── alb.yaml
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── network.tf
│   ├── ec2.tf
│   ├── rds.tf
│   └── alb.tf
├── scripts/
│   ├── deploy_cloudformation.sh
│   └── deploy_terraform.sh
├── .gitignore
└── README.md
```

## Prerequisites

- AWS CLI installed and configured
- Terraform installed (for Terraform deployment)
- Basic understanding of AWS services and IaC concepts

## CloudFormation Deployment

1. Navigate to the `cloudformation` directory.
2. Review and modify the YAML templates as needed.
3. Run the deployment script:

```bash
../scripts/deploy_cloudformation.sh
```

## Terraform Deployment

1. Navigate to the `terraform` directory.
2. Initialize Terraform:

```bash
terraform init
```

3. Review and modify the `.tf` files as needed.
4. Plan the deployment:

```bash
terraform plan
```

5. Apply the changes:

```bash
terraform apply
```

## Cleaning Up

To avoid incurring unnecessary charges, remember to destroy the resources when you're done:

For CloudFormation:
```bash
aws cloudformation delete-stack --stack-name my-cf-stack
```

For Terraform:
```bash
terraform destroy
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.