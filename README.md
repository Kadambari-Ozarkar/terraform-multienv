# 🚀 Multi-Environment AWS Infrastructure using Terraform Workspaces

### 🟢 Dev • 🟡 Staging • 🔴 Production

![Terraform](https://img.shields.io/badge/Terraform-Infrastructure%20as%20Code-7B42BC?logo=terraform\&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud%20Infrastructure-FF9900?logo=amazonaws\&logoColor=white)
![EC2](https://img.shields.io/badge/AWS-EC2-FF9900?logo=amazonec2\&logoColor=white)
![S3](https://img.shields.io/badge/AWS-S3-569A31?logo=amazons3\&logoColor=white)
![VPC](https://img.shields.io/badge/AWS-VPC-FF9900?logo=amazonaws\&logoColor=white)

---

## 📌 Project Overview

This project demonstrates the design and implementation of a **multi-environment AWS infrastructure using Terraform Infrastructure as Code (IaC)**.

The scenario represents a growing SaaS startup where Development, Staging, and Production workloads were initially hosted in a single AWS environment.

This created a major risk:

> ⚠️ Changes made for development or testing could accidentally affect production users.

To solve this problem, this project implements **isolated Dev, Staging, and Production environments** using a **single reusable Terraform codebase**.

---

## 🎯 Objectives

The project aims to:

* 🟢 Create separate **Development, Staging, and Production** environments
* 🔵 Use Terraform as Infrastructure as Code
* 🧩 Build reusable Terraform modules
* 🔄 Use Terraform Workspaces for environment separation
* ⚙️ Use `.tfvars` files for environment-specific configuration
* ☁️ Store Terraform state remotely using Amazon S3
* 🔐 Apply stronger security controls to Production
* 🛡️ Prevent accidental deletion of critical Production resources
* 🏷️ Properly tag AWS resources
* 🧪 Demonstrate isolation between environments

---

# 🏗️ Architecture

```text
                         ┌─────────────────────┐
                         │      Terraform      │
                         │   Single Codebase   │
                         └──────────┬──────────┘
                                    │
                    ┌───────────────┼───────────────┐
                    │               │               │
                 🟢 DEV         🟡 STAGING       🔴 PROD
                    │               │               │
                ┌───▼───┐       ┌───▼───┐       ┌───▼───┐
                │  VPC  │       │  VPC  │       │  VPC  │
                └───┬───┘       └───┬───┘       └───┬───┘
                    │               │               │
                 ┌──▼──┐         ┌──▼──┐         ┌──▼──┐
                 │ EC2 │         │ EC2 │         │ EC2 │
                 └──┬──┘         └──┬──┘         └──┬──┘
                    │               │               │
                 ┌──▼──┐         ┌──▼──┐         ┌──▼──┐
                 │  SG  │         │  SG  │         │  SG  │
                 └──┬──┘         └──┬──┘         └──┬──┘
                    │               │               │
                 ┌──▼──┐         ┌──▼──┐         ┌──▼──┐
                 │ S3  │         │ S3  │         │ S3  │
                 └─────┘         └─────┘         └─────┘
```

### Environment Strategy

| Environment       | Purpose                  | Instance Size | Security                  |
| ----------------- | ------------------------ | ------------- | ------------------------- |
| 🟢 **Dev**        | Development              | Small         | Basic                     |
| 🟡 **Staging**    | Testing / Pre-production | Medium        | Enhanced                  |
| 🔴 **Production** | Live application         | Large         | Strict + Additional Rules |

---

# ☁️ AWS Resources

## 🌐 VPC

A separate VPC is created for each environment.

```text
🟢 Dev        → 10.10.0.0/16
🟡 Staging    → 10.20.0.0/16
🔴 Production → 10.30.0.0/16
```

This provides network-level isolation between environments.

---

## 💻 EC2

Each environment receives an EC2 instance.

Example configuration:

```text
🟢 Dev        → t3.micro
🟡 Staging    → t3.small
🔴 Production → t3.medium
```

The instance type is controlled through Terraform variables.

---

## 🪣 S3

Each environment receives a dedicated S3 bucket for application storage.

Example:

```text
terraform-multi-env-dev
terraform-multi-env-staging
terraform-multi-env-prod
```

This prevents application data from different environments from being mixed.

---

## 🔐 Security Groups

Security Groups control network access to EC2 instances.

```text
🟢 Dev
   ├── HTTP
   └── SSH

🟡 Staging
   ├── HTTP
   └── SSH

🔴 Production
   ├── HTTP / HTTPS
   ├── Restricted administrative access
   └── Additional security rules
```

Production access should be restricted to trusted sources wherever possible.

---

# 📁 Terraform Project Structure

```text
terraform-multi-environment/
│
├── 📁 environments/
│   ├── dev.tfvars
│   ├── staging.tfvars
│   └── prod.tfvars
│
├── 📁 modules/
│   │
│   ├── 📁 vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── 📁 ec2/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── 📁 s3/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── backend.tf
├── terraform.tf
└── README.md
```

---

# 🧩 Terraform Modules

Terraform modules are used to maximize code reuse.

### 🌐 VPC Module

Responsible for:

* VPC creation
* Subnets
* Network configuration

```text
modules/vpc/
├── main.tf
├── variables.tf
└── outputs.tf
```

### 💻 EC2 Module

Responsible for:

* EC2 instance
* Security Group
* Instance configuration

```text
modules/ec2/
├── main.tf
├── variables.tf
└── outputs.tf
```

### 🪣 S3 Module

Responsible for:

* S3 bucket
* Bucket configuration
* Environment-specific naming

```text
modules/s3/
├── main.tf
├── variables.tf
└── outputs.tf
```

The same modules are reused across Dev, Staging, and Production.

---

# 🔄 Terraform Workspace Strategy

Terraform Workspaces are used to maintain separate state for each environment.

```text
🟢 dev
🟡 staging
🔴 prod
```

### Create Workspaces

```bash
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod
```

### List Workspaces

```bash
terraform workspace list
```

### Select Development

```bash
terraform workspace select dev
```

### Select Staging

```bash
terraform workspace select staging
```

### Select Production

```bash
terraform workspace select prod
```

### Check Current Workspace

```bash
terraform workspace show
```

---

# ⚙️ Environment Configuration

Environment-specific configuration is maintained using `.tfvars` files.

## 🟢 Development

`environments/dev.tfvars`

```hcl
environment   = "dev"
instance_type = "t3.micro"
vpc_cidr      = "10.10.0.0/16"
```

## 🟡 Staging

`environments/staging.tfvars`

```hcl
environment   = "staging"
instance_type = "t3.small"
vpc_cidr      = "10.20.0.0/16"
```

## 🔴 Production

`environments/prod.tfvars`

```hcl
environment   = "prod"
instance_type = "t3.medium"
vpc_cidr      = "10.30.0.0/16"
```

---

# 🔒 Environment Isolation

Environment isolation is implemented using multiple layers.

### 1. Workspace Isolation

Each workspace maintains separate Terraform state.

```text
🟢 Dev State
🟡 Staging State
🔴 Production State
```

### 2. Network Isolation

Each environment has its own VPC.

```text
Dev        → 10.10.0.0/16
Staging    → 10.20.0.0/16
Production → 10.30.0.0/16
```

### 3. Storage Isolation

Each environment receives its own S3 bucket.

### 4. Configuration Isolation

Each environment uses its own `.tfvars` configuration.

### 5. Resource Tagging

Every resource is tagged according to its environment.

```hcl
tags = {
  Environment = var.environment
  Project     = "terraform-multi-environment"
  ManagedBy   = "Terraform"
}
```

---

# 🗄️ Remote Terraform Backend

Terraform state is stored remotely in Amazon S3.

Example:

```hcl
terraform {
  backend "s3" {
    bucket = "terraform-multi-env-s3"
    key    = "multi-env/terraform.tfstate"
    region = "eu-north-1"
  }
}
```

### Benefits

* ☁️ Centralized state management
* 🔐 Better state protection
* 👥 Team collaboration
* 💾 State persistence
* 🔄 Environment-aware state management

> The backend bucket should be created and secured before Terraform initialization. For production use, configure state locking using the supported Terraform/AWS mechanism.

---

# 🚀 Terraform Deployment

## Step 1 — Initialize Terraform

```bash
terraform init
```

## Step 2 — Format Code

```bash
terraform fmt -recursive
```

## Step 3 — Validate Configuration

```bash
terraform validate
```

---

# 🟢 Deploy Development

Select the Dev workspace:

```bash
terraform workspace select dev
```

Create the execution plan:

```bash
terraform plan -var-file="environments/dev.tfvars"
```

Apply the infrastructure:

```bash
terraform apply -var-file="environments/dev.tfvars"
```

Verify:

```bash
terraform workspace show
```

Expected:

```text
dev
```

---

# 🟡 Deploy Staging

Select the Staging workspace:

```bash
terraform workspace select staging
```

Create the execution plan:

```bash
terraform plan -var-file="environments/staging.tfvars"
```

Apply:

```bash
terraform apply -var-file="environments/staging.tfvars"
```

Verify:

```bash
terraform workspace show
```

Expected:

```text
staging
```

---

# 🔴 Deploy Production

Select the Production workspace:

```bash
terraform workspace select prod
```

Create the execution plan:

```bash
terraform plan -var-file="environments/prod.tfvars"
```

> ⚠️ **Always review the Production plan carefully before applying changes.**

Apply:

```bash
terraform apply -var-file="environments/prod.tfvars"
```

Verify:

```bash
terraform workspace show
```

Expected:

```text
prod
```

---

# 🛡️ Production Protection

Critical Production resources should be protected against accidental deletion.

Terraform lifecycle rules can be used:

```hcl
lifecycle {
  prevent_destroy = true
}
```

Example:

```hcl
resource "aws_s3_bucket" "application_storage" {

  bucket = var.bucket_name

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
```

This prevents Terraform from accidentally destroying protected Production resources.

---

# 🏷️ Resource Tagging

All AWS resources should contain meaningful tags.

```hcl
tags = {
  Project     = "Multi-Environment-Infrastructure"
  Environment = var.environment
  ManagedBy   = "Terraform"
  Owner       = "Cloud-Engineering"
}
```

### Benefits

* 🔎 Easy resource identification
* 💰 Cost tracking
* 🛠️ Troubleshooting
* 👤 Ownership tracking
* 🌍 Environment identification

---

# 🧪 Environment Validation

After deployment, verify each environment.

## Workspace Validation

```bash
terraform workspace list
```

Expected:

```text
* dev
  staging
  prod
```

Switch to each workspace and verify independently.

## AWS Infrastructure Validation

Verify that:

```text
Dev VPC        ≠ Staging VPC
Staging VPC    ≠ Production VPC

Dev EC2        ≠ Staging EC2
Staging EC2    ≠ Production EC2

Dev S3         ≠ Staging S3
Staging S3     ≠ Production S3
```

## Configuration Validation

Verify that:

```text
🟢 Dev        → Small Instance
🟡 Staging    → Medium Instance
🔴 Production → Large Instance
```

---

# 📸 Screenshots & Evidence

The following screenshots should be included as project evidence.

### 1️⃣ Terraform Repository Structure

Show:

```text
environments/
modules/
main.tf
variables.tf
outputs.tf
backend.tf
README.md
```

### 2️⃣ Terraform Workspaces

Show:

```bash
terraform workspace list
```

with:

```text
dev
staging
prod
```

### 3️⃣ Development Environment

Show the Dev:

* VPC
* EC2
* Security Group
* S3 bucket

### 4️⃣ Staging Environment

Show the Staging:

* VPC
* EC2
* Security Group
* S3 bucket

### 5️⃣ Production Environment

Show the Production:

* VPC
* EC2
* Security Group
* S3 bucket
* Additional security configuration

### 6️⃣ Terraform Deployment

Show successful:

```bash
terraform apply
```

### 7️⃣ Remote Backend

Show the S3 bucket used for Terraform state.

### 8️⃣ Environment Isolation

Show separate resources and environment tags in AWS.

---

# 🔄 Complete Deployment Workflow

```text
              👨‍💻 Developer
                   │
                   ▼
          ┌──────────────────┐
          │ Terraform Code   │
          └────────┬─────────┘
                   │
                   ▼
            terraform init
                   │
                   ▼
          terraform validate
                   │
                   ▼
          Select Workspace
                   │
        ┌──────────┼──────────┐
        ▼          ▼          ▼
      🟢 Dev     🟡 Stage    🔴 Prod
        │          │          │
        └──────────┼──────────┘
                   ▼
             terraform plan
                   │
                   ▼
              Review Plan
                   │
                   ▼
            terraform apply
                   │
                   ▼
               ☁️ AWS
```

---

# 🔐 Security Best Practices

This project follows the following practices:

* 🔑 Never hardcode AWS credentials
* 👤 Follow the principle of least privilege
* 🚫 Never commit secrets to GitHub
* 🔐 Restrict Production administrative access
* 🌐 Avoid unnecessary open ports
* 🛡️ Protect critical Production resources
* 🏷️ Tag AWS resources consistently
* ☁️ Store Terraform state remotely
* 🔎 Review `terraform plan` before applying
* 🧩 Use reusable Terraform modules
* 🌍 Maintain environment separation
* 📦 Control Terraform and provider versions

---

# 🛠️ Technologies Used

| Technology                  | Purpose                               |
| --------------------------- | ------------------------------------- |
| 🟣 **Terraform**            | Infrastructure as Code                |
| 🟠 **AWS VPC**              | Network isolation                     |
| 🟠 **AWS EC2**              | Compute infrastructure                |
| 🟢 **AWS S3**               | Application storage & Terraform state |
| 🔐 **Security Groups**      | Network access control                |
| 🧩 **Terraform Modules**    | Code reuse                            |
| 🔄 **Terraform Workspaces** | Environment separation                |
| ⚙️ **Terraform Variables**  | Environment-specific configuration    |
| 📦 **Git/GitHub**           | Source-code management                |

---

# 🏆 Conclusion

This project demonstrates how Terraform can be used to build a **reusable, secure, scalable, and environment-aware AWS infrastructure**.

Instead of maintaining separate Terraform projects for Development, Staging, and Production, a **single modular Terraform codebase** is used.

Terraform Workspaces provide separate environment state, while `.tfvars` files provide environment-specific configuration.

### Final Result

```text
🧩 Reusable Terraform Modules
              +
🔄 Workspace-Based Separation
              +
⚙️ Environment-Specific Configuration
              +
☁️ Remote State Management
              +
🔐 Security Controls
              +
🛡️ Production Protection
              =
🚀 Professional Multi-Environment AWS Infrastructure
```

This architecture provides a strong foundation for managing cloud infrastructure using **Terraform, AWS, and modern DevOps practices**.
