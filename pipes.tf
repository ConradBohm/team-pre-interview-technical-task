resource "aws_sqs_queue" "basket" {
  name                      = "silver-bullet-basket-queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.terraform_queue_deadletter.arn
    maxReceiveCount     = 4
  })
}

resource "aws_sns_topic_subscription" "basket_sqs_target" {
  topic_arn = "arn:aws:sns:eu-west-1:536697261635:silver-bullet-basket-events"
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.basket.arn
}

resource "aws_pipes_pipe" "basket" {
  name     = "silver-bullet-basket-pipe"
  role_arn = aws_iam_role.pipes.arn
  source   = aws_sqs_queue.basket.arn
  target   = "arn:aws:events:eu-west-1:536697261635:event-bus/silver-bullet-domain-events"
}

resource "aws_sqs_queue" "checkouts" {
  name                      = "silver-bullet-checkouts-queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.terraform_queue_deadletter.arn
    maxReceiveCount     = 4
  })
}

resource "aws_sns_topic_subscription" "checkouts_sqs_target" {
  topic_arn = "arn:aws:sns:eu-west-1:536697261635:silver-bullet-checkouts-events"
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.checkouts.arn
}

resource "aws_pipes_pipe" "checkouts" {
  name     = "silver-bullet-checkouts-pipe"
  role_arn = aws_iam_role.pipes.arn
  source   = aws_sqs_queue.checkouts.arn
  target   = "arn:aws:events:eu-west-1:536697261635:event-bus/silver-bullet-domain-events"
}

resource "aws_iam_role" "pipes" {
  name = "silver-bullet-pipes-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_role_policy" "pipes" {
  role = aws_iam_role.pipes.id
  name = "Pipes"
  policy = jsonencode({
    Statement = [{
      Effect = "Allow"
      Action = ["pipes:*"]
      Resource = ["arn:aws:pipes:eu-west-1:536697261635:pipes/silver-bullet-*"]
    }]
  })
}