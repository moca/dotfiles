#!/bin/bash

# Check if the region parameter is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <AWS Region>"
    exit 1
fi

# Extract the region from the command line parameter
region="$1"

# Use the AWS CLI to list EC2 instances in the specified region
aws ec2 describe-instances --region "$region" --query "Reservations[].Instances[] | [].[InstanceType, Tags[?Key=='Name'].Value | [0], InstanceId]" --output json
