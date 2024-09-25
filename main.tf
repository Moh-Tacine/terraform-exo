locals {
  input_data = jsondecode(file("./config.json"))
}

module "ec2" {
  source              = "./modules/ec2/"
  ec2_instance_number = local.input_data.numberOfInstances
  subnet_list = local.input_data.subnets
  user_data = "${path.module}/nginx_install.sh"
}

module "vpc" {
  count = local.input_data.numberOfInstances > 1 ? 1 : 0
  source      = "./modules/vpc/"
  instance_id = module.ec2.instance_ec2_list
}

#module "acl" {
#  source = "./modules/acl/"
#  lb_arn = module.vpc.lb_arn.value
#}

#module "rds" {
#  source = "./modules/rds/"
#  sg_ec2_id = module.ec2.sg_ec2_id
#}