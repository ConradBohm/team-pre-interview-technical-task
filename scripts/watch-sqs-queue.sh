#!/bin/bash

function get-queue-message-count {
  local QUEUE_NAME=$1
  aws sqs get-queue-attributes \
    --attribute-names ApproximateNumberOfMessages \
    --queue-url "https://sqs.eu-west-1.amazonaws.com/536697261635/$QUEUE_NAME" \
    --query "Attributes.ApproximateNumberOfMessages" \
    --output text \
    --profile=default
}

function receive-message {
  local QUEUE_NAME=$1

  local MESSAGE=$(aws sqs receive-message \
    --queue-url "https://sqs.eu-west-1.amazonaws.com/536697261635/$QUEUE_NAME" \
    --wait-time-seconds 20 \
    --query "Messages[0]" \
    --profile=default
  )
  if [[ "$MESSAGE" != "null" ]]; then
    echo $MESSAGE | jq '.Body | fromjson'
    local RECEIPT_HANDLE=$(echo $MESSAGE | jq -r .ReceiptHandle)
    aws sqs delete-message \
      --queue-url "https://sqs.eu-west-1.amazonaws.com/536697261635/$QUEUE_NAME" \
      --receipt-handle "$RECEIPT_HANDLE" \
      --profile=default
  fi
}

if [[ -z $SQS_QUEUE_NAME ]]; then
  SQS_QUEUE_NAME=$(aws sqs list-queues --query "QueueUrls[*]" --output text --profile=default | xargs -n1 | fzf)
fi

SQS_QUEUE_NAME=$(echo $SQS_QUEUE_NAME | awk -F/ '{print $NF}')

if [[ -z $SQS_QUEUE_NAME ]]; then
  echo "No queue selected"
  exit 1
fi

echo >&2 + aws sqs receive-message \
  --queue-url "https://sqs.eu-west-1.amazonaws.com/536697261635/$SQS_QUEUE_NAME" \
  --wait-time-seconds 20 \
  --query "Messages[0]" \
  --profile=default

while true; do
  receive-message "${SQS_QUEUE_NAME}"
done
