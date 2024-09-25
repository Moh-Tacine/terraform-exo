
resource "aws_security_group" "sg_ec2" {
  name = "sg_ec2"
  description = "Security group to access via port 80"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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


resource "aws_instance" "mon_instance_ec2" {

  count = var.ec2_instance_number
  ami = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.sg_ec2.id]
  subnet_id = var.subnet_list[count.index]
  user_data = templatefile(var.user_data, {ec2_instance_number = count.index })

  tags = {
    Name = "instance-${count.index}"
  }
}