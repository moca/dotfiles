#!/usr/bin/env bash

# Function to display usage
function display_usage() {
    echo "Usage: $0 <instance_id> <start|stop>"
    exit 1
}

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    display_usage
fi

# Assign arguments to variables
instance_id="$1"
action="$2"

# Check if action is either "start" or "stop"
if [ "$action" != "start" ] && [ "$action" != "stop" ]; then
    display_usage
fi

# Perform the specified action
if [ "$action" == "start" ]; then
    aws ec2 start-instances --instance-ids "$instance_id"
    echo "Starting EC2 instance $instance_id..."
elif [ "$action" == "stop" ]; then
    aws ec2 stop-instances --instance-ids "$instance_id"
    echo "Stopping EC2 instance $instance_id..."
fi
