# AWS Production Auto-Healing Platform (Terraform)

## What this builds
- VPC with public/private subnets + NAT
- ALB in public subnets
- Auto Scaling Group in private subnets (auto-healing)
- CloudWatch alarms + SNS email alerts
- GitHub Actions CI for Terraform (fmt/validate/plan)

## Deploy (dev)
1. Create backend S3 + DynamoDB (one time).
2. Copy `env/dev/terraform.tfvars.example` -> `env/dev/terraform.tfvars`
3. Set `alarm_email` in `terraform.tfvars`
4. Run:
```bash
cd env/dev
terraform init
terraform plan
terraform apply
```

## Access
Terraform outputs ALB DNS name. Open it in browser.

---

## Remote backend prerequisites (create once)
Terraform backend needs an S3 bucket + DynamoDB table before terraform init can use remote state.

Create them manually in AWS console OR use CLI:

```bash
# 1) S3 bucket (must be globally unique)
aws s3api create-bucket \
  --bucket YOUR_UNIQUE_TF_STATE_BUCKET_NAME \
  --region us-east-1

# 2) Enable versioning (recommended)
aws s3api put-bucket-versioning \
  --bucket YOUR_UNIQUE_TF_STATE_BUCKET_NAME \
  --versioning-configuration Status=Enabled

# 3) DynamoDB table for state locking
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

## Deploy commands (exact steps)
From the repo root:

```bash
cd env/dev

# 1) Create tfvars
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars and set alarm_email

# 2) Initialize + deploy
terraform init
terraform plan
terraform apply
```

After apply finishes:
- Check output `alb_dns_name`.
- Open it in browser → you should see “Hello from Auto-Scaling EC2 behind ALB”.
- AWS will send an SNS confirmation email → confirm it, then alerts will work.

## Test auto-scaling (easy demo for interview)
To spike CPU on one instance:

Go to EC2 console → Auto Scaling Group → Instances

Select one instance → Connect (Session Manager) (works if SSM is enabled; if not, skip)

Run:

```bash
sudo dnf install -y stress-ng
stress-ng --cpu 2 --timeout 180s
```

CPU will rise → CloudWatch alarm → SNS email → scaling may trigger depending on configuration.

## Cost control (important)
NAT Gateway costs money. If you want cheaper:
- Put instances in public subnet (less “production”, but cheaper), OR
- Use VPC endpoints and remove NAT (advanced optimization), OR
- Destroy after demo: `terraform destroy`
