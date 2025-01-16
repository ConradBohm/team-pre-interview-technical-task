resource "aws_pipes_pipe" "basket" {
  name     = "silver-bullet-basket-pipe"
  role_arn = aws_iam_role.pipes.arn
  source   = aws_sqs_queue.basket.arn
  target   = "arn:aws:events:eu-west-1:536697261635:event-bus/silver-bullet-domain-events"

  target_parameters {
    input_template = <<-EOT
      { "event": <$.body> }
    EOT
  }
}

resource "aws_pipes_pipe" "checkout" {
  name     = "silver-bullet-checkout-pipe"
  role_arn = aws_iam_role.pipes.arn
  source   = aws_sqs_queue.checkout.arn
  target   = "arn:aws:events:eu-west-1:536697261635:event-bus/silver-bullet-domain-events"

  target_parameters {
    input_template = <<-EOT
      { "event": <$.body> }
    EOT
  }
}
