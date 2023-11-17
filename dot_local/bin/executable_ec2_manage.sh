#!/bin/bash

# Check if the instance ID parameter is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <Instance ID> <start|stop|terminate>"
    exit 1
fi

# Extract the instance ID and action from the command line parameters
instance_id="$1"
action="$2"

# Check if the action parameter is provided
if [ -z "$action" ]; then
    echo "Usage: $0 <Instance ID> <start|stop|terminate>"
    exit 1
fi

# Check if the action is one of "start," "stop," or "terminate"
if [ "$action" != "start" ] && [ "$action" != "stop" ] && [ "$action" != "terminate" ]; then
    echo "Invalid action. Please use 'start,' 'stop,' or 'terminate.'"
    exit 1
fi

# Perform the specified action on the EC2 instance
case "$action" in
    "start")
        aws ec2 start-instances --instance-ids "$instance_id"
        echo "Starting instance $instance_id"
        ;;
    "stop")
        aws ec2 stop-instances --instance-ids "$instance_id"
        echo "Stopping instance $instance_id"
        ;;
    "terminate")
        aws ec2 terminate-instances --instance-ids "$instance_id"
        echo "Terminating instance $instance_id"
        ;;
esac
