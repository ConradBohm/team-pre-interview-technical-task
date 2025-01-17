resource "aws_cloudwatch_event_rule" "purchase" {
  name        = "silver-bullet-capture-basket-checkout"
  description = "Capture each event from Basket and Checkout topics"
  event_bus_name = "arn:aws:events:eu-west-1:536697261635:event-bus/silver-bullet-domain-events"

  event_pattern = jsonencode({
    source = ["aws.sns"]
  })
}

resource "aws_cloudwatch_event_target" "purchase" {
  rule           = aws_cloudwatch_event_rule.purchase.name
  target_id      = "silver-bullet-send-to-purchase"
  arn            = aws_sqs_queue.purchase.arn
  event_bus_name = "arn:aws:events:eu-west-1:536697261635:event-bus/silver-bullet-domain-events"
}

# =============================================================================================

resource "aws_cloudwatch_log_group" "silver" {
  name              = "silver-bullet-log-group"
  retention_in_days = 5
}

resource "aws_cloudwatch_log_stream" "silver" {
  name           = "silver-bullet-log-stream"
  log_group_name = aws_cloudwatch_log_group.silver.name
}