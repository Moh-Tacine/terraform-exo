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
  source      = "./modules/vpc/"
  instance_id = module.ec2.instance_ec2_list
}