resource "random_password" "postgres_password" {
  length = 10
  special = true
  override_special = "!#$%&*()-_=+[]"
}

resource "aws_secretsmanager_secret" "credentials_key_secret" {
  name        = "postgres-db-terraform-password-1"
}

resource "aws_secretsmanager_secret_version" "credentials_secret_version" {
  secret_id = aws_secretsmanager_secret.credentials_key_secret.id
  secret_string = jsonencode({
    username = "mohamed"
    password = random_password.postgres_password.result
  })
}

resource "aws_security_group" "rds_security_group" {

  name = "rds_sg"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "postgres" {
  allocated_storage   = 20
  instance_class      = "db.t3.micro"
  storage_type        = "gp2"
  engine_version      = "15.5"
  engine              = "postgres"
  identifier          = "terraform-exo-postgres-rds"
  username            = jsondecode(aws_secretsmanager_secret_version.credentials_secret_version.secret_string)["username"]
  password            = jsondecode(aws_secretsmanager_secret_version.credentials_secret_version.secret_string)["password"]
  db_name             = "db_test"
  publicly_accessible = false
  availability_zone   = "us-east-1c"
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
}