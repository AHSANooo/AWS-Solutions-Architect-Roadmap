# CI/CD Pipeline Setup

## Current Workflow: `.github/workflows/lint.yml`

This workflow runs on every push and pull request to validate code quality across the repository.

### Jobs

1. **lint-markdown** — Checks Markdown syntax and formatting
2. **syntax-check** — Validates YAML and JSON files
3. **terraform-check** — Validates Terraform configuration
4. **cloudformation-check** — Validates CloudFormation templates

### Error Handling

All validation jobs use `continue-on-error: true` to prevent pipeline failures if tools aren't available in the runner. This is intentional for maximum compatibility.

### Local Validation

Run validation locally before pushing:

```bash
# Check Markdown (requires markdownlint-cli)
npm install -g markdownlint-cli
markdownlint .

# Check Terraform
cd iac/terraform
terraform init -backend=false
terraform validate

# Check JSON syntax
python3 -c "import json; json.load(open('file.json'))"

# Check YAML syntax
python3 -c "import yaml; yaml.safe_load(open('file.yaml'))"
```text

### Dependencies for Full Validation

To enable all checks locally:

```bash
# Markdown linter
npm install -g markdownlint-cli

# Terraform (from hashicorp.com)
# CloudFormation linter
pip install cfn-lint

# YAML linter
pip install yamllint
```text

### Troubleshooting

If the workflow fails:
- Check that action versions are current in Actions Marketplace
- Verify Terraform/CloudFormation syntax locally first
- Some tools may not be available in free GitHub Actions runners

### Updating the Workflow

To use stricter validation:

1. Add `shell: bash` to steps
2. Remove `continue-on-error: true` for critical jobs
3. Test in a feature branch before merging to main

---

**Current Status:** Basic validation enabled, lenient error handling
**Recommended Setup:** Install validation tools locally (npm, pip, Terraform CLI)
