# Disaster Recovery & Business Continuity Cheat Sheet

RTO/RPO models, failover strategies, and Route 53 health check patterns.

## Key Definitions

| Term | Definition | Example |
| :--- | :--- | :--- |
| **RTO** (Recovery Time Objective) | Max acceptable downtime | "Must be back online in 1 hour" |
| **RPO** (Recovery Point Objective) | Max acceptable data loss | "Can afford to lose 15 minutes of data" |
| **RTA** (Recovery Time Actual) | Actual time to recover | "We recovered in 45 minutes" |
| **MTTR** (Mean Time To Repair) | Average repair time | "Typical fix takes 2 hours" |

---

## DR Strategy Spectrum

### 1. Backup & Restore (Cheapest, Slowest)
```
RTO: Hours to days
RPO: Hours to days
Cost: Lowest (~$50/month for S3 backups)
Effort: Manual restore required

Architecture:
Prod → Daily Snapshots → S3 → (Restore on failure)
```

### 2. Pilot Light (Active standby, minimal cost)
```
RTO: Minutes to hours
RPO: Minutes
Cost: 50% of production (~$500/month for small instance)
Effort: Automated failover script

Architecture:
Prod → Continuous replication → Standby (t2.micro) → Scale up on failure
```

### 3. Warm Standby (Scaled down secondary)
```
RTO: Minutes
RPO: Real-time
Cost: 50-75% of production (~$1,000/month for mid-sized)
Effort: DNS failover (Route 53)

Architecture:
Prod (Primary) ←→ Standby (50% capacity) ← Always in sync
         ↓ Failover
    Route 53 updates DNS
```

### 4. Hot Standby / Multi-Region Active-Active (Expensive, fastest)
```
RTO: Seconds
RPO: Near zero
Cost: 100% of production × 2 regions (~$5,000+/month)
Effort: Global load balancing (Route 53 latency-based)

Architecture:
Region 1 (Primary) ←→ Region 2 (Secondary)
          ↓           ↓
    Route 53 (health checks)
    Users routed to healthy region
```

---

## RTO/RPO vs. Cost Matrix

| Strategy | RTO | RPO | Cost | Complexity |
| :--- | :--- | :--- | :--- | :--- |
| Backup & Restore | 24 hours | 24 hours | $$ | Low |
| Pilot Light | 4 hours | 1 hour | $$$ | Medium |
| Warm Standby | 1 hour | 15 min | $$$$ | High |
| Multi-Region Active | 1 minute | Real-time | $$$$$ | Very High |

---

## Common Failover Patterns

### Pattern 1: Route 53 Health Check → Auto-failover
```
Route 53 Policy: Failover

Primary endpoint → Health check (HTTP /health)
   ├─ Healthy? → Route traffic here
   └─ Unhealthy? → Route to secondary

Automatic, no manual intervention needed
```

### Pattern 2: Weighted Routing (Gradual migration)
```
Route 53 Policy: Weighted

Primary endpoint: 70%
Secondary endpoint: 30%

Use case: Gradually shift traffic before permanent failover
```

### Pattern 3: Latency-based Routing (Multi-region)
```
Route 53 Policy: Latency

Users in us-east-1 → Route to us-east-1 endpoint
Users in eu-west-1 → Route to eu-west-1 endpoint
Users in ap-south-1 → Route to ap-south-1 endpoint

Lowest latency for all users
```

---

## Database Failover Strategies

### RDS Multi-AZ
- **RTO:** ~2 minutes (automatic failover)
- **RPO:** ~1 second (synchronous replication)
- **Cost:** 2x the single-AZ cost
- **Maintenance:** No downtime for patching

### Aurora Multi-Region (Global Database)
- **RTO:** <1 minute (managed failover)
- **RPO:** <1 second (asynchronous)
- **Cost:** Secondary region reads are cheaper
- **Best for:** Disaster recovery + read scaling

### DynamoDB Global Tables
- **RTO:** Immediate (already replicated)
- **RPO:** <1 second (stream-based replication)
- **Cost:** 1.25x base cost (per replica)
- **Best for:** Serverless multi-region

---

## Backup Strategies Comparison

| Strategy | RPO | Retention | Cost | Use Case |
| :--- | :--- | :--- | :--- | :--- |
| **Automated RDS Snapshots** | 1 min | 35 days | Low | Standard databases |
| **Manual Snapshots** | Manual | Unlimited | Medium | Compliance, audits |
| **S3 Cross-Region Replication** | 1 sec | Configurable | Medium | Critical data |
| **AWS Backup (centralized)** | Flexible | 35-3650 days | High | Multi-service, policy-driven |

---

## Failover Checklist

- [ ] Document RTO/RPO targets
- [ ] Set up Route 53 health checks
- [ ] Configure automatic DNS failover
- [ ] Test failover annually (DR drill)
- [ ] Monitor replication lag (CloudWatch)
- [ ] Have runbook for manual failover
- [ ] Verify backup integrity monthly
- [ ] Keep disaster recovery plans versioned in Git

---

## Common Mistakes

| Mistake | Impact | Fix |
| :--- | :--- | :--- |
| RPO too aggressive | Constant replication, high cost | Set realistic data loss tolerance |
| No health checks configured | Manual intervention = long RTO | Automate Route 53 failover |
| Only snapshot backups | Long recovery time | Add continuous replication |
| Failover not tested | Fails when needed | Test quarterly |
| Secondary region not scaled | Outage continues | Pre-scale for full capacity |
