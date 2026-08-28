#!/bin/bash
# Cleanup script for Week 1 lab

set -e

echo "Starting teardown of Week 1 lab resources..."

# Terminate EC2 instances
echo "Terminating EC2 instances..."
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=LabInstance-*" \
  --query 'Reservations[].Instances[].InstanceId' \
  --output text | xargs -I {} aws ec2 terminate-instances --instance-ids {}

# Delete EBS volumes
echo "Deleting EBS volumes..."
sleep 30  # Wait for instances to terminate
aws ec2 describe-volumes \
  --filters "Name=status,Values=available" \
  --query 'Volumes[?Tags[?Key==`Name` && Value==`SAALabVolume`]].VolumeId' \
  --output text | xargs -I {} aws ec2 delete-volume --volume-id {}

# Delete EFS
echo "Deleting EFS file system..."
EFS_ID=$(aws efs describe-file-systems \
  --query 'FileSystems[?Tags[? Key==`Name` && Value==`SAALabEFS`]].FileSystemId' \
  --output text)

if [ ! -z "$EFS_ID" ]; then
  # Delete mount targets first
  aws efs describe-mount-targets --file-system-id $EFS_ID \
    --query 'MountTargets[].MountTargetId' \
    --output text | xargs -I {} aws efs delete-mount-target --mount-target-id {}
  
  sleep 30
  aws efs delete-file-system --file-system-id $EFS_ID
fi

# Delete IAM role and instance profile
echo "Deleting IAM resources..."
aws iam detach-role-policy \
  --role-name SAALabEC2Role \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess 2>/dev/null || true

aws iam remove-role-from-instance-profile \
  --instance-profile-name SAALabProfile \
  --role-name SAALabEC2Role 2>/dev/null || true

aws iam delete-instance-profile \
  --instance-profile-name SAALabProfile 2>/dev/null || true

aws iam delete-role --role-name SAALabEC2Role 2>/dev/null || true

echo "Teardown completed successfully!"
