# AWS Compute Services Comparison Matrix

Quick reference for choosing between EC2, Lambda, ECS, and Fargate based on workload characteristics.

## Service Comparison

| Characteristic | EC2 | Lambda | ECS (EC2) | ECS (Fargate) |
| :--- | :--- | :--- | :--- | :--- |
| **Launch Time** | Minutes | <100ms | Minutes | ~1 minute |
| **Execution Duration** | Unlimited | 15 minutes max | Unlimited | Unlimited |
| **Memory Range** | 512 MB - 768 GB | 128 MB - 10 GB | Variable | 512 MB - 30 GB |
| **Concurrency** | Infinite | 1000 (soft limit, can request increase) | Infinite | Infinite |
| **Scaling** | Manual/ASG | Auto (event-driven) | ASG required | ECS Service scaling |
| **Cost Model** | Pay per hour | Pay per request + memory-seconds | Pay per hour | Pay per vCPU-hour + memory-hour |
| **Management** | Full control | Fully managed | Container management required | Fully managed |
| **Use Case** | Long-running, high compute | Event-driven, short-lived | Persistent microservices | Microservices (serverless) |

---

## Decision Tree

```text
Start: What workload do I have?

├─ Long-running application (24/7)?
│  └─ YES → EC2 or ECS (EC2)
│  └─ NO  → Continue below
│
├─ Event-driven, sub-15 min execution?
│  └─ YES → Lambda
│  └─ NO  → Continue below
│
├─ Containerized microservice?
│  └─ YES (want to manage container host) → ECS (EC2)
│  └─ YES (want serverless containers) → ECS (Fargate)
│  └─ NO  → EC2
```text

---

## Cost Scenarios

### Scenario 1: Batch Job (1 hour, 2 GB memory)
- **Lambda:** $0.000002 × 2,000 MB × 3,600 sec = ~$0.01 (very cheap)
- **ECS (Fargate):** $0.04731 vCPU-hour + $0.00520 GB-hour = ~$0.05
- **EC2 (t3.medium):** ~$0.0416/hour = ~$0.04

**Winner:** Lambda if job <15 min

### Scenario 2: Always-On Web Server

- **Lambda:** Not suitable (15-min timeout)
- **ECS (Fargate):** $0.04731 (1 vCPU) × 730 hours = ~$34.55/month
- **EC2 (t3.medium):** ~$0.0416 × 730 = ~$30.37/month

**Winner:** EC2 for cost; Fargate for minimal ops

---

## Common Pitfalls

| Pitfall | Consequence | Fix |
| :--- | :--- | :--- |
| Using Lambda for >15 min job | Job terminates mid-execution | Use ECS or EC2 |
| Over-provisioning Lambda memory | Wasted cost | Monitor CloudWatch and right-size |
| Not using ASG with ECS (EC2) | Manual scaling = no elasticity | Always pair with ASG |
| Choosing EC2 for one-off task | Unnecessary cost; idle time | Use Lambda or Fargate |

---

## Key Limits to Remember

- **Lambda:** Max 15 minutes execution time, 10 GB memory
- **ECS (Fargate):** Min 256 MB memory, vCPU/memory combinations restricted
- **EC2:** Instance limits depend on AWS account (default 20 on-demand per region)
