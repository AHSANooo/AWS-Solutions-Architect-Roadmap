# Terraform Base Templates

Reusable Terraform modules for VPC, security groups, RDS, and Auto Scaling Groups.

## Module Structure

```text
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── modules/
│   ├── vpc/
│   ├── security_groups/
│   ├── rds/
│   └── autoscaling/
└── environments/
    ├── dev/
    └── prod/
```text

## Quick Start

```bash
terraform init
terraform plan
terraform apply
```text

See individual module READMEs for configuration options.
