#!/bin/bash

LOG_GROUP_NAME=$1

if [[ -z $LOG_GROUP_NAME ]]; then
  LOG_GROUP_NAME=$(aws logs describe-log-groups --query "logGroups[*].logGroupName" --output text --profile=default | xargs -n1 | fzf)
fi

if [[ -z $LOG_GROUP_NAME ]]; then
  echo "No log group selected"
  exit 1
fi

set -x; awslogs get "$LOG_GROUP_NAME" --start 1h -G -S -w
