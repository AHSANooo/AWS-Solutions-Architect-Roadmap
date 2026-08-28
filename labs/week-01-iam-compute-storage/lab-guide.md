# Week 1: IAM, EC2, EBS, EFS Lab Guide

Hands-on setup of a multi-AZ EC2 cluster with IAM roles, EBS volumes, and EFS file system.

## Learning Objectives

By the end of this lab, you will:

1. ✅ Create and configure IAM roles for EC2 instances

2. ✅ Launch EC2 instances across multiple AZs

3. ✅ Attach and configure EBS volumes

4. ✅ Set up an EFS file system for shared storage

5. ✅ Verify multi-AZ resilience

---

## Prerequisites

- AWS account with Free Tier access

- AWS CLI configured (`aws configure`)

- SSH key pair created

- Basic Linux command-line knowledge

---

## Lab Steps

### Step 1: Create IAM Role for EC2

```bash
# Create trust policy for EC2
cat > trust-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

# Create role
aws iam create-role \
  --role-name SAALabEC2Role \
  --assume-role-policy-document file://trust-policy.json

# Attach S3 policy
aws iam attach-role-policy \
  --role-name SAALabEC2Role \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

# Create instance profile
aws iam create-instance-profile --instance-profile-name SAALabProfile
aws iam add-role-to-instance-profile \
  --instance-profile-name SAALabProfile \
  --role-name SAALabEC2Role
```text

### Step 2: Launch EC2 Instances (Multi-AZ)

```bash
# In us-east-1a
aws ec2 run-instances \
  --image-id ami-0c55b159cbfafe1f0 \
  --instance-type t3.micro \
  --availability-zone us-east-1a \
  --iam-instance-profile Name=SAALabProfile \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=LabInstance-AZ1}]' \
  --user-data file://userdata.sh

# In us-east-1b
aws ec2 run-instances \
  --image-id ami-0c55b159cbfafe1f0 \
  --instance-type t3.micro \
  --availability-zone us-east-1b \
  --iam-instance-profile Name=SAALabProfile \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=LabInstance-AZ2}]' \
  --user-data file://userdata.sh
```text

### Step 3: Create and Attach EBS Volume

```bash
# Create 10 GB EBS volume in us-east-1a
VOLUME_ID=$(aws ec2 create-volume \
  --size 10 \
  --availability-zone us-east-1a \
  --volume-type gp3 \
  --query 'VolumeId' \
  --output text)

echo "Created volume: $VOLUME_ID"

# Attach to first instance
INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=LabInstance-AZ1" \
  --query 'Reservations[0].Instances[0].InstanceId' \
  --output text)

aws ec2 attach-volume \
  --volume-id $VOLUME_ID \
  --instance-id $INSTANCE_ID \
  --device /dev/sdf
```text

### Step 4: Mount EBS Volume on Instance

SSH into instance and run:

```bash
# Find the device
lsblk

# Format volume (if new)
sudo mkfs.ext4 /dev/nvme1n1

# Mount
sudo mkdir /data
sudo mount /dev/nvme1n1 /data
sudo chown ec2-user:ec2-user /data

# Verify
df -h
```text

### Step 5: Create and Mount EFS File System

```bash
# Create EFS in default VPC
EFS_ID=$(aws efs create-file-system \
  --performance-mode generalPurpose \
  --throughput-mode bursting \
  --tags Key=Name,Value=SAALabEFS \
  --query 'FileSystemId' \
  --output text)

echo "Created EFS: $EFS_ID"

# Create mount targets in each AZ
aws efs create-mount-target \
  --file-system-id $EFS_ID \
  --subnet-id subnet-xxxxx \  # Replace with your subnet
  --security-groups sg-xxxxx   # Replace with your SG

# Mount on instance
sudo apt update
sudo apt install nfs-common
sudo mkdir /efs
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 $EFS_ID.efs.us-east-1.amazonaws.com:/ /efs
```text

---

## Verification Checklist

- [ ] IAM role created and attached to EC2 instances

- [ ] Both EC2 instances running in different AZs

- [ ] EBS volume attached and mounted on instance

- [ ] EFS file system created with mount targets

- [ ] Can write to EBS volume and EFS from instances

- [ ] Can access EFS mount from both instances (shared storage)

---

## Teardown

```bash
./teardown.sh
```text

---

## Key Takeaways

1. **IAM Roles:** Always use roles instead of hardcoding credentials

2. **Multi-AZ:** Distribute resources for high availability

3. **EBS vs. EFS:** EBS for single instance, EFS for shared access

4. **Storage Optimization:** Right-size volumes; use gp3 for cost efficiency

---

## References

- [AWS IAM Roles Documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html)

- [EC2 User Data](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html)

- [EBS Volume Types](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-volume-types.html)

- [EFS Documentation](https://docs.aws.amazon.com/efs/latest/ug/)
