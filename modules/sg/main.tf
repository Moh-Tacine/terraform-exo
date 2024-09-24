#
#resource "aws_security_group" "mon_security_group_1" {
#  name = "exo-terraform-sg"
#  description = "Security group to access via port 80"
#
#  ingress {
#    from_port = 80
#    to_port = 80
#    protocol = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  egress {
#    from_port = 80
#    to_port = 80
#    protocol = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#}