variable "aws_region" {
  description = "Default AWS region"
  default     = "us-east-1"
  type        = string
}

variable "state_s3_bucket" {
  description = "State S3 bucket name"
  default     = "terraform-state-rsschool-devops-course-tasks"
  type        = string
}

variable "project" {
  description = "Name of project"
  default     = "rsschool"
  type        = string
}

variable "repo" {
  description = "Name of repo"
  default     = "CiscoSA/rsschool-devops-course-tasks:*"
  # default     = "CiscoSA/rsschool-devops-course-tasks:ref:refs/heads/task_4*"
  type = string
}

variable "instance_type_bastion" {
  description = "Instance type"
  default     = "t2.micro"
  # default     = "t3.small"
  # default     = "t3.medium"
  type = string
}

variable "instance_type_k8s" {
  description = "k8s Instance type"
  # default     = "t3.small"
  default = "t2.micro"
  type    = string
}


variable "public_subnets" {
  description = "List of CIDR blocks for public subnets"
  default     = ["10.200.0.0/20", "10.200.16.0/20"]
}

variable "private_subnets" {
  description = "List of CIDR blocks for public subnets"
  default     = ["10.200.128.0/20", "10.200.144.0/20"]
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}


data "template_file" "cloud-init-yaml" {
  template = file("${path.module}/userdata/cloud-config.yaml")
  vars = {
    init_ssh_public_key = file("~/.ssh/test.pub")
  }
}
