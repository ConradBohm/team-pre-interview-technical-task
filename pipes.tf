resource "aws_pipes_pipe" "basket" {
  name     = "silver-bullet-basket-pipe"
  role_arn = aws_iam_role.pipes.arn
  source   = "arn:aws:sns:eu-west-1:536697261635:silver-bullet-basket-events"
  target   = "arn:aws:events:eu-west-1:536697261635:event-bus/silver-bullet-domain-events"
}

resource "aws_pipes_pipe" "checkout" {
  name     = "silver-bullet-checkouts-pipe"
  role_arn = aws_iam_role.pipes.arn
  source   = "arn:aws:sns:eu-west-1:536697261635:silver-bullet-checkouts-events"
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