resource "aws_sqs_queue" "basket" {
  name                      = "silver-bullet-basket-queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
}

resource "aws_sns_topic_subscription" "basket_sqs_target" {
  topic_arn = "arn:aws:sns:eu-west-1:536697261635:silver-bullet-basket-events"
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.basket.arn
}

# =============================================================================================

resource "aws_sqs_queue" "checkout" {
  name                      = "silver-bullet-checkout-queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
}

resource "aws_sns_topic_subscription" "checkout_sqs_target" {
  topic_arn = "arn:aws:sns:eu-west-1:536697261635:silver-bullet-checkout-events"
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.checkout.arn
}

# =============================================================================================

resource "aws_sqs_queue" "purchase" {
  name                      = "silver-bullet-purchase-events"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
}
