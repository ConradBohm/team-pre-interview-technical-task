resource "aws_iam_role" "pipes" {
  name = "silver-bullet-pipes-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "pipes.amazonaws.com"
        }
      },
    ]
  })
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

resource "aws_iam_role_policy" "sqs" {
  role = aws_iam_role.pipes.id
  name = "SQS"
  policy = jsonencode({
    Statement = [{
      Effect = "Allow"
      Action = [
            "sqs:ReceiveMessage",
            "sqs:DeleteMessage",
            "sqs:GetQueueAttributes"
        ]
      Resource = "arn:aws:sqs:eu-west-1:536697261635:silver-bullet-*"
    }]
  })
}

resource "aws_iam_policy" "logs_policy" {
  role = aws_iam_role.pipes.id
  name = "Logs"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = aws_cloudwatch_log_group.pipes.arn
      }
    ]
  })
}

# =============================================================================================