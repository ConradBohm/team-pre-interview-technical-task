#!/bin/bash

cd $(dirname $0)/..

if [[ -n $1 ]]; then
  IAM_USERNAME=$1
else
  echo -n "Enter your IAM username: "
  read IAM_USERNAME
fi

set -x
aws sns publish --topic-arn arn:aws:sns:eu-west-1:536697261635:$IAM_USERNAME-basket-events --message file://example-sns-events/basket-updated-event.json --profile=default
aws sns publish --topic-arn arn:aws:sns:eu-west-1:536697261635:$IAM_USERNAME-checkout-events --message file://example-sns-events/checkout-created-event.json --profile=default
