# AWS Storage Tiers & Cost Optimization

S3 storage classes, EBS volume types, and EFS vs. FSx decision tree.

## S3 Storage Class Comparison

| Class | Durability | Availability | Access | Min Duration | Use Case | Cost |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **S3 Standard** | 99.999999999% | 99.99% | Milliseconds | N/A | Hot data, frequently accessed | $0.023/GB |
| **S3 Intelligent-Tiering** | 99.999999999% | 99.9% | Milliseconds | 0 days | Auto-tiering (recommended) | $0.0125/GB |
| **S3 Standard-IA** | 99.999999999% | 99.9% | Milliseconds | 30 days | Infrequent access | $0.0125/GB |
| **S3 One Zone-IA** | 99.99999999% | 99.5% | Milliseconds | 30 days | Non-critical backups | $0.01/GB |
| **S3 Glacier Instant** | 99.999999999% | 99.9% | Milliseconds | 90 days | Archive, rare access | $0.004/GB |
| **S3 Glacier Flexible** | 99.999999999% | 99.99% | Minutes-hours | 90 days | Long-term backup | $0.0036/GB |
| **S3 Glacier Deep Archive** | 99.999999999% | 99.99% | Hours-days | 180 days | Compliance archive | $0.00099/GB |

### Key Rules
- **Minimum storage duration:** Charged even if deleted earlier
- **Retrieval costs:** Vary by tier (Glacier Instant free, Deep Archive $50+ per TB)
- **Intelligent-Tiering:** Auto moves objects; no retrieval cost

---

## S3 Lifecycle Policy Example

```
Standard → (30 days) → Standard-IA → (90 days) → Glacier Flexible → (365 days) → Deep Archive
  (Hot)              (Warm)           (Cold)                    (Frozen)
```

**Annual cost for 1 TB of data:**
- Standard all year: $276
- With lifecycle: $80 (70% savings!)

---

## EBS Volume Type Comparison

| Type | Use Case | Max IOPS | Max Throughput | Cost | Durability |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **gp3** (General Purpose) | Web servers, databases | 16,000 | 1,000 MB/s | $0.10/GB | 99.8% - 99.9% |
| **gp2** (Previous gen) | Older EC2 instances | 16,000 | 250 MB/s | $0.10/GB | 99.8% - 99.9% |
| **io1/io2** (Provisioned) | High-IOPS databases | 64,000 | 1,000 MB/s | $0.125/GB + $0.065/IOPS | 99.99% |
| **st1** (Throughput) | Big data, streaming | 500 | 500 MB/s | $0.045/GB | 99.9% |
| **sc1** (Cold) | Infrequent access | 250 | 250 MB/s | $0.015/GB | 99.9% |

### Decision: gp3 vs. io1
- **gp3:** Use for 95% of workloads (cost-effective, independent IOPS/throughput)
- **io1:** Only if you need >16,000 IOPS (databases, data warehouses)

---

## EFS vs. FSx

| Feature | EFS | FSx (Windows) | FSx (Lustre) |
| :--- | :--- | :--- | :--- |
| **Throughput** | Bursting | Sustained | Ultra-high |
| **Latency** | Sub-millisecond | Single-digit ms | <1ms |
| **Use Case** | Linux, containers | Windows file sharing | HPC, big data |
| **Cost** | $0.30/GB/month | $0.012/GB/month | Higher (specialized) |
| **Scalability** | Unlimited | 64 TB max | Configurable |
| **Replication** | Built-in (AZ-resilient) | Multi-AZ option | Single AZ |

### Quick Decision
- **Need shared Linux storage?** → EFS
- **Need Windows file shares?** → FSx (Windows)
- **Need extreme performance (HPC)?** → FSx (Lustre)
- **Need local cache + cloud?** → FSx (with hybrid option)

---

## Cost Optimization Strategies

### Strategy 1: S3 Lifecycle Policies
```bash
Move to Standard-IA after 30 days
Move to Glacier after 90 days
Delete after 2 years
```
**Savings:** 70-90% for archival data

### Strategy 2: EBS Right-Sizing
```
Current: 1 TB gp2 volume @ 10% utilization
Optimized: 100 GB gp3 volume
Savings: $108/year
```

### Strategy 3: S3 Intelligent-Tiering
```
Enable auto-tiering on production buckets
AWS moves data automatically based on access patterns
No retrieval costs
Result: 40-50% savings without manual intervention
```

### Strategy 4: Consolidate to S3 One Zone-IA
```
For non-critical backups:
Standard: $23/TB
One Zone-IA: $10/TB
Savings: 57%
(Trade-off: Single AZ, 30-day minimum)
```

---

## Common Pitfalls

| Pitfall | Cost Impact | Fix |
| :--- | :--- | :--- |
| Using Standard for archived data | $276/year per TB | Set lifecycle → Glacier |
| Paying retrieval costs (Glacier) | $50+ per TB restored | Estimate retrieval frequency |
| Over-provisioning IOPS (io1) | $600+/year per 1000 IOPS | Use gp3; adjust IOPS independently |
| Multiple snapshots (redundant) | 2x backup cost | Use lifecycle policies for cleanup |
| Not enabling S3 Intelligent-Tiering | Paying for hot storage | Enable auto-tiering; saves 40-50% |

---

## Cost Estimation: 10 TB Dataset

| Strategy | Annual Cost | Pros | Cons |
| :--- | :--- | :--- | :--- |
| All Standard | $2,760 | Fast access | Expensive |
| Standard + 30-day Lifecycle | $550 | 80% savings | Retrieval lag |
| Intelligent-Tiering | $1,500 | Auto optimization | Slightly higher base |
| One Zone-IA | $100 | Cheapest | Single AZ, not for critical |

**Recommendation:** Intelligent-Tiering for simplicity; Lifecycle policies for predictable workloads.
