module "task" {
  source = "../../modules"

  create = true

  instance_name = "task"
  ami_id = "ami-068257025f72f470d"
  instance_id = "t2.micro"
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.task.id]
  subnet_id = var.subnet_id

  user_data = var.user_data

  root_volume_size = 8

}
