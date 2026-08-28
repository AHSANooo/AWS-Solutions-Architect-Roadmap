# Mock Exam Error Log

Track missed questions, analyze wrong choices, and document root causes for continuous improvement.

## Log Entry Template

```
| Date | Exam Source | Question # | Topic | Wrong Choice | Correct Answer | Root Cause | Remediation |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| YYYY-MM-DD | Source Name | Q# | Domain | Your answer | Correct answer | Why you chose wrong | How to avoid next time |
```

---

## Sample Entries

| Date | Exam Source | Question | Topic | Wrong Choice | Correct Answer | Root Cause | Remediation |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 2026-08-28 | Tutorial Dojo | Q12 | VPC Endpoints | Gateway Endpoint | Interface Endpoint | Confused service types; Gateway only works for S3/DynamoDB | Review `/cheat-sheets/networking-cheat-sheet.md` |
| 2026-08-28 | Practice Test | Q45 | DynamoDB | Strong Consistency | Eventually Consistent | Read the question carefully for "default behavior" language | Always note: DynamoDB = Eventually Consistent by default |

---

## Summary Stats

- **Total Entries:** 2
- **Domain 1 (Secure):** 0
- **Domain 2 (Resilient):** 1
- **Domain 3 (High-Performing):** 1
- **Domain 4 (Cost-Optimized):** 0

---

## Quick Links to Remediation

- EC2 Instance Types → `/cheat-sheets/compute-matrix.md`
- Database Selection → `/cheat-sheets/database-decision-tree.md`
- Network Architecture → `/cheat-sheets/networking-cheat-sheet.md`
- RTO/RPO Concepts → `/cheat-sheets/disaster-recovery.md`
