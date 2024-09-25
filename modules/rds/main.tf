resource "aws_security_group" "rds_security_group" {

  name = "rds_sg"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [var.sg_ec2_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "postgres" {
  allocated_storage = 20
  instance_class = "db.t3.micro"
  storage_type = "gp2"
  engine_version = "15.5"
  engine = "postgres"
  identifier = "terraform-exo-postgres-rds"
  username = "mohamed"
  password = "yacine123456"
  db_name = "db_test"
  publicly_accessible = false
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]

  skip_final_snapshot = true
}