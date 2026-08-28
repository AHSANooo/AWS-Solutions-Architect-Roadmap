#!/bin/bash
# User data script for EC2 instances in Week 1 lab

set -e
set -x

# Log output
exec > >(tee -a /var/log/user-data.log)
exec 2>&1

echo "Starting EC2 user data script..."

# Update system
apt-get update -y
apt-get upgrade -y

# Install required tools
apt-get install -y \
  aws-cli \
  nfs-common \
  htop \
  curl \
  wget

# Install Docker (optional, for future labs)
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
usermod -aG docker ec2-user

# Create data directory
mkdir -p /data
mkdir -p /efs

# Install CloudWatch agent (optional monitoring)
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
dpkg -i -E ./amazon-cloudwatch-agent.deb

# Log completion
echo "User data script completed successfully at $(date)"
