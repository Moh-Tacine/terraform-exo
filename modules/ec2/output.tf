output "instance_ec2_list" {
  value = [for instance in aws_instance.mon_instance_ec2:instance.id]
}