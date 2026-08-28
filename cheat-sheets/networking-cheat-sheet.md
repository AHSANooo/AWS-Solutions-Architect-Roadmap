# AWS Networking Cheat Sheet

Core concepts: CIDR, VPCs, Subnets, Routing, Security Groups, NACLs, and VPC Endpoints.

## CIDR Notation Quick Reference

| Notation | Range | # Hosts | Common Use |
| :--- | :--- | :--- | :--- |
| `/32` | Single IP | 1 | Specific host |
| `/24` | X.X.X.0 - X.X.X.255 | 256 | Subnet |
| `/16` | X.X.0.0 - X.X.255.255 | 65,536 | VPC |
| `/8` | X.0.0.0 - X.255.255.255 | 16,777,216 | RFC 1918 private range |

### RFC 1918 Private Ranges
- `10.0.0.0/8` (10.0.0.0 - 10.255.255.255) — AWS default
- `172.16.0.0/12` (172.16.0.0 - 172.31.255.255)
- `192.168.0.0/16` (192.168.0.0 - 192.168.255.255)

---

## Security Groups vs. NACLs

| Feature | Security Group | NACL |
| :--- | :--- | :--- |
| **Level** | Instance (stateful) | Subnet (stateless) |
| **Rules** | Allow only | Allow + Deny |
| **Statefulness** | Stateful (return traffic automatic) | Stateless (must allow both directions) |
| **Order** | All rules evaluated | Rules evaluated in order (first match wins) |
| **Performance** | Applied per ENI | Applied to entire subnet |
| **Use Case** | Application security | Network segmentation |

**Example:**
- Allow port 443 in Security Group → Return traffic auto-allowed
- Allow port 443 in NACL → Must also allow ephemeral return port (1024-65535)

---

## VPC Endpoints: Gateway vs. Interface

| Type | Use Case | Services | Cost | Routing |
| :--- | :--- | :--- | :--- | :--- |
| **Gateway** | Private S3/DynamoDB access | S3, DynamoDB | Free | Route table entry |
| **Interface** | Private access to other services | API Gateway, SNS, SQS, etc. | $0.01/hour | ENI + DNS name |

**Key Point:** 
- S3 and DynamoDB = Gateway Endpoint
- Everything else = Interface Endpoint

---

## VPC Architecture Best Practices

### Multi-AZ Subnet Pattern
```
VPC: 10.0.0.0/16

AZ-1:
  Public:  10.0.1.0/24 (IGW route)
  Private: 10.0.2.0/24 (NAT route)

AZ-2:
  Public:  10.0.3.0/24 (IGW route)
  Private: 10.0.4.0/24 (NAT route)
```

### Routing Decision
```
Destination → Route Table Decision

0.0.0.0/0 (Default Route)
├─ If IGW attached → Goes to Internet Gateway
├─ If NAT attached → Goes to NAT Gateway (for private subnets)
└─ If VPC Endpoint → Goes to endpoint service
```

---

## Common Networking Pitfalls

| Pitfall | Consequence | Fix |
| :--- | :--- | :--- |
| Private subnet with no NAT | Outbound internet blocked | Add NAT Gateway in public subnet |
| No NACL inbound rule for ephemeral ports | Return traffic blocked | Allow 1024-65535 in NACL |
| Security Group has no outbound rule | Outbound blocked (non-AWS) | Add explicit outbound allow |
| Wrong subnet for RDS | EC2 can't reach database | Launch RDS in private subnet with appropriate SG |
| Not using VPC Endpoint for S3 | Data transfer costs | Create Gateway Endpoint |

---

## NAT Gateway vs. NAT Instance

| Feature | NAT Gateway | NAT Instance |
| :--- | :--- | :--- |
| **Management** | AWS managed | You manage (EC2) |
| **Availability** | Highly available | Manual failover |
| **Throughput** | Up to 100 Gbps | Limited by instance type |
| **Failover** | Automatic | Manual (use Bastian Host) |
| **Cost** | Per GB processed + hourly | EC2 instance + data transfer |
| **Use Case** | Production private subnets | Bastion host / legacy |

---

## Route 53 + VPC Integration

### Health Checks
- **HTTP/HTTPS:** Check specific path for 200-399 status
- **TCP:** Simple port check
- **Calculated:** Combine multiple child health checks

### Routing Policies
- **Simple:** Single resource (A record)
- **Weighted:** Distribute by percentage
- **Latency-based:** Route to lowest latency
- **Failover:** Active-Passive with health checks
- **Geolocation:** Route by geographic location
- **Multi-value:** Multiple random resources

---

## Common IPs to Remember

| IP | Use |
| :--- | :--- |
| `169.254.169.254` | EC2 metadata service |
| `127.0.0.1` | Localhost |
| `0.0.0.0` | Any IP (default route) |
| `255.255.255.255` | Broadcast |
