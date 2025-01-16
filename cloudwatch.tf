resource "aws_cloudwatch_event_rule" "console" {
  name        = "silver-bullet-capture-basket-checkout"
  description = "Capture each event from Basket and Checkout topics"

  event_pattern = jsonencode({
    source = ["aws.sns"]
  })
}

resource "aws_cloudwatch_event_target" "sns" {
  rule           = aws_cloudwatch_event_rule.console.name
  target_id      = "SendToSNS"
  arn            = aws_sns_topic.aws_logins.arn
  sqs_target     = ws_sqs_queue.purchase.arn
  event_bus_name = "arn:aws:events:eu-west-1:536697261635:event-bus/silver-bullet-domain-events"
}