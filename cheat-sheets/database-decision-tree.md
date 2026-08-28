# AWS Database Decision Tree

Select the right database for your workload: RDS, Aurora, DynamoDB, ElastiCache, or Redshift.

## Quick Selection Flowchart

```
START: What data type?

├─ Structured, relational (SQL)?
│  ├─ Need Multi-Master replication? → Aurora Global Database
│  ├─ High throughput, many replicas? → Aurora (MySQL/PostgreSQL)
│  ├─ Budget-constrained, single region? → RDS (MySQL/PostgreSQL)
│  └─ Oracle/SQL Server required? → RDS (Oracle/MSSQL)
│
├─ NoSQL, document/key-value?
│  └─ Massive scale, <10ms latency? → DynamoDB
│
├─ In-memory caching?
│  ├─ Need high availability? → ElastiCache (Redis Cluster)
│  └─ Simple session store? → ElastiCache (Redis/Memcached)
│
└─ Analytics, data warehouse?
   └─ Petabyte-scale queries? → Redshift
```

---

## Service Comparison Matrix

| Characteristic | RDS | Aurora | DynamoDB | ElastiCache | Redshift |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Data Model** | Relational SQL | Relational SQL | Key-value, Document | In-memory | Columnar OLAP |
| **Consistency** | ACID (default) | ACID | Eventually consistent* | N/A (cache) | ACID |
| **Max Throughput** | ~20k IOPS | ~100k IOPS | Unlimited (on-demand) | 100k+ req/sec | Petabytes |
| **Latency** | 1-5ms | 1-2ms | <10ms | <1ms | Seconds (batch) |
| **Multi-AZ Cost** | +100% | +0% (shared storage) | Replicated by default | +100% (cluster) | Managed replicas |
| **Auto-Scaling** | Manual (RDS Proxy) | Automatic (read replicas) | On-demand or provisioned | Fixed capacity | Manual resize |
| **Backup RPO** | 5 min (automated) | 5 min | 35-day point-in-time | N/A (ephemeral) | 24-hour snapshots |

*DynamoDB offers strongly consistent reads as an option (higher latency/cost)

---

## When to Choose Each

### RDS (MySQL/PostgreSQL/MariaDB)
✅ Relational data, ACID compliance, moderate scale  
❌ Not for petabyte analytics or microsecond latency  
💰 Cost-effective for predictable workloads  

### Aurora
✅ High availability, auto-scaling read replicas, MySQL/PostgreSQL compat  
❌ Overkill for small databases  
💰 Pay per read/write unit (interesting for bursty traffic)

### DynamoDB
✅ Massive scale, single-digit millisecond latency, serverless  
❌ No complex joins, eventual consistency by default, limited queries  
💰 On-demand pricing for unpredictable workloads  

### ElastiCache
✅ Session management, real-time leaderboards, rate limiting  
❌ Not a primary data store, in-memory (lose data on restart)  
💰 Reduces database load dramatically  

### Redshift
✅ Petabyte-scale analytics, complex queries, BI tools  
❌ Not for operational databases, slower for small datasets  
💰 Expensive; consolidate all analytics here  

---

## Common Gotchas

| Gotcha | Impact | Solution |
| :--- | :--- | :--- |
| Using DynamoDB for complex queries | Query performance degrades | Use RDS or Aurora for relational queries |
| No Multi-AZ on RDS prod | Single AZ failure = downtime | Always enable Multi-AZ in production |
| ElastiCache as source of truth | Data loss on cluster restart | Use as cache only; keep source in RDS/DynamoDB |
| Not monitoring RDS disk space | Sudden write failures | Enable automated scaling; use CloudWatch alarms |

---

## Cost Estimation Examples

### Scenario: 100 GB relational database, 1000 req/sec read-heavy
- **RDS (Multi-AZ, db.r6i.xlarge):** ~$3,000/month
- **Aurora (Provisioned, 4 read replicas):** ~$2,500/month
- **DynamoDB (On-demand):** ~$5,000+/month (at this throughput)

**Winner:** Aurora (best performance + cost balance)

### Scenario: Caching layer for session storage
- **ElastiCache (Redis, cache.t3.micro):** ~$15/month
- **DynamoDB (On-demand):** ~$50+/month

**Winner:** ElastiCache (clear winner for caching)
