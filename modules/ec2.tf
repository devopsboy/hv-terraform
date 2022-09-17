module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.1.4"

  name   = var.instance_name
  create = var.create

  ami              = var.ami_id
  instance_type    = var.instance_id
  key_name         = var.key_name

  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id              = var.subnet_id

  user_data = var.user_data

  monitoring                           = true
  disable_api_termination              = false
  hibernation                          = null
  disable_api_stop                     = null
  tenancy                              = null
  associate_public_ip_address          = true
  instance_initiated_shutdown_behavior = null
  source_dest_check                    = true

  root_block_device = [{
    delete_on_termination = true
    encrypted = false
    volume_type = "gp3"
    volume_size = var.root_volume_size
    iops = "3000"
    throughput = "125"
  }]
}
