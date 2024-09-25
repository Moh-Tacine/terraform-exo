output "instance_ec2_list" {
  value = [for instance in aws_instance.mon_instance_ec2:instance.id]
}

output "sg_ec2_id" {
  value = aws_security_group.sg_ec2.id
}