resource "aws_pipes_pipe" "basket" {
  name     = "basket-pipe"
  role_arn = "arn:aws:iam::536697261635:user/silver-bullet"
  source   = "arn:aws:sns:eu-west-1:536697261635:silver-bullet-basket-events"
  target   = "arn:aws:events:eu-west-1:536697261635:event-bus/silver-bullet-domain-events"
}

resource "aws_pipes_pipe" "checkout" {
  name     = "checkouts-pipe"
  role_arn = "arn:aws:iam::536697261635:user/silver-bullet"
  source   = "arn:aws:sns:eu-west-1:536697261635:silver-bullet-checkouts-events"
  target   = "arn:aws:events:eu-west-1:536697261635:event-bus/silver-bullet-domain-events"
}