
resource "aws_iam_role" "ec2_postgres_role" {
  name = "ec2-postgres-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "rds_access_policy" {

  name = "rds-postgres-access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "rds:*",
          "rds-db:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_rds_policy" {
  policy_arn = aws_iam_policy.rds_access_policy.arn
  role       = aws_iam_role.ec2_postgres_role.name
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_postgres_role.name
}