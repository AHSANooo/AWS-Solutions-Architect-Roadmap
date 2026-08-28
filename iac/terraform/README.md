# Terraform Base Templates

Reusable Terraform modules for VPC, security groups, RDS, and Auto Scaling Groups.

## Module Structure

```
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
```

## Quick Start

```bash
terraform init
terraform plan
terraform apply
```

See individual module READMEs for configuration options.
