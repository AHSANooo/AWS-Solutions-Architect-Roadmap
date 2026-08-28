# CloudFormation Base Templates

AWS native Infrastructure as Code templates for SAA lab environments.

## Templates

- `vpc-template.yaml` — Multi-AZ VPC with public/private subnets
- `ec2-template.yaml` — EC2 launch template with IAM role
- `rds-template.yaml` — RDS Multi-AZ database
- `alb-template.yaml` — Application Load Balancer with target groups

## Quick Deploy

```bash
aws cloudformation create-stack \
  --stack-name saa-lab \
  --template-body file://vpc-template.yaml
```text

See individual templates for parameters.
