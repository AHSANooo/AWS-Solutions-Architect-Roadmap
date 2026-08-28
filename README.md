# AWS Certified Solutions Architect – Associate (SAA-C03) Execution Path

Zero-cost, 8-week terminal-first preparation roadmap tracking hands-on architectures, trade-off analyses, and SAA-C03 domain mastery.

![Exam](https://img.shields.io/badge/Target-AWS%20SAA--C03-232F3E?logo=amazon-aws&logoColor=white)
![Progress](https://img.shields.io/badge/Status-In%20Progress%20(Week%201%2F8)-blue)
![Cost](https://img.shields.io/badge/Cost-$0.00%20(Free%20Tier%20%2B%20LocalStack)-brightgreen)
![OS](https://img.shields.io/badge/Environment-Linux%20Ubuntu-E95420?logo=ubuntu&logoColor=white)

---

## 🎯 Exam Blueprint & Progress Tracker

| Domain | Exam Weight | Target Readiness | Status |
| :--- | :--- | :--- | :--- |
| **Domain 1: Design Secure Architectures** | 30% | 85%+ | 🔲 Incomplete |
| **Domain 2: Design Resilient Architectures** | 26% | 85%+ | 🔲 Incomplete |
| **Domain 3: Design High-Performing Architectures** | 24% | 80%+ | 🔲 Incomplete |
| **Domain 4: Design Cost-Optimized Architectures** | 20% | 85%+ | 🔲 Incomplete |

---

## 📅 8-Week Execution Matrix

| Week | Core Focus | Hands-on Deliverable | Blog / LinkedIn Link | Status |
| :--- | :--- | :--- | :--- | :--- |
| **W1** | IAM, EC2, EBS, EFS | Multi-AZ Web Tier + EFS Mount | [W1 Post](#) | 🔲 Pending |
| **W2** | S3 Lifecycle, ALB/NLB, ASG | Zero-Downtime Auto Scaling Cluster | [W2 Post](#) | 🔲 Pending |
| **W3** | Custom VPC, Subnets, NAT, NACLs | Dual-AZ VPC with Public/Private Subnets | [W3 Post](#) | 🔲 Pending |
| **W4** | VPC Endpoints, RDS Multi-AZ, DynamoDB | Private S3 Gateway + Isolated RDS Failover | [W4 Post](#) | 🔲 Pending |
| **W5** | SQS, SNS, EventBridge, API Gateway | Decoupled Async Microservice Pipeline | [W5 Post](#) | 🔲 Pending |
| **W6** | Route 53, Disaster Recovery (RPO/RTO) | Active-Passive Pilot Light Failover | [W6 Post](#) | 🔲 Pending |
| **W7** | Well-Architected Framework & Whitepapers | Full-Domain Architecture Review | [W7 Post](#) | 🔲 Pending |
| **W8** | Mock Simulations & Weak Spot Remediation | Benchmarking ≥ 80% First Attempt | [W8 Post](#) | 🔲 Pending |

---

## 🛠️ Repository Conventions

- `/cheat-sheets`: Hard architectural limits, decision trees, and service comparison matrices.
- `/diagrams`: Standard AWS component diagrams (`.drawio` and exported `.png`).
- `/iac`: Idempotent infrastructure definitions deployed via AWS CLI/Terraform.
- `/mock-exams/error-log.md`: Detailed breakdown of missed mock exam questions and distractor traps.

---

## ⚙️ Local Development & Emulation

Run local AWS services offline without account charges:

```bash
cd localstack
docker compose up -d
awslocal s3 mb s3://test-bucket
```

---

## 📁 Repository Structure

```
aws-solutions-architect-roadmap/
├── .github/
│   └── workflows/
│       └── lint.yml                 # Markdown and IaC validation
├── cheat-sheets/
│   ├── compute-matrix.md            # EC2, Lambda, ECS, Fargate trade-offs
│   ├── database-decision-tree.md    # RDS vs Aurora vs DynamoDB vs ElastiCache
│   ├── networking-cheat-sheet.md    # CIDR, Routing, Endpoints, SG vs NACL
│   ├── disaster-recovery.md         # RTO/RPO models and Route 53 policies
│   └── storage-tiers.md             # S3 classes, EBS types, EFS vs FSx
├── diagrams/
│   ├── week-01-high-availability/  # .drawio, .png, and .excalidraw files
│   ├── week-03-custom-vpc/
│   ├── week-05-event-driven/
│   └── week-06-disaster-recovery/
├── iac/
│   ├── terraform/                   # Reusable base templates (VPC, ASG, RDS)
│   └── cloudformation/              # AWS native baseline templates
├── labs/
│   ├── week-01-iam-compute-storage/
│   │   ├── lab-guide.md
│   │   ├── userdata.sh
│   │   └── teardown.sh
│   ├── week-02-load-balancing-asg/
│   ├── week-03-custom-vpc-endpoints/
│   ├── week-04-databases-caching/
│   ├── week-05-serverless-integration/
│   └── week-06-route53-dr-failover/
├── mock-exams/
│   ├── error-log.md                 # Question, wrong choice, root cause, fix
│   └── score-tracker.md             # Date, source, domain score, retake delta
├── localstack/
│   ├── docker-compose.yml           # Local emulation stack
│   └── scripts/                     # Shell scripts to provision local mock infra
├── .gitignore
├── LICENSE
└── README.md
```

---

## 🚀 Getting Started

1. Clone the repository and navigate to your workspace:
   ```bash
   cd aws-solutions-architect-roadmap
   ```

2. Start LocalStack for offline testing:
   ```bash
   docker compose -f localstack/docker-compose.yml up -d
   ```

3. Review the week-specific lab guides in `/labs` to begin hands-on learning.

4. Check `/cheat-sheets` for quick reference materials on key AWS services.

---

## 📊 Tracking Progress

- Update the Exam Blueprint table above as you achieve readiness targets.
- Log failed mock exam attempts in `/mock-exams/error-log.md` with root cause analysis.
- Track mock exam scores in `/mock-exams/score-tracker.md`.

---

## 📝 License

This roadmap is open-source and available under the MIT License.

---

**Target Completion:** [Your Target Date]  
**Last Updated:** 2026-08-28
