resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type_bastion

  subnet_id = module.vpc.public_subnets[0]

  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.public_sg.id]

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = 16
    volume_type           = "gp2"
  }

  user_data = data.template_file.cloud-init-yaml.rendered

  tags = {
    Name = "Bastion"
  }
}
