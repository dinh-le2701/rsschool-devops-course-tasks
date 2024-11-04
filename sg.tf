resource "aws_security_group" "public_sg" {
  name        = "public_sg"
  description = "SG for public EC2"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = "public_sg"
  }
}

## Private SG rules START
resource "aws_security_group_rule" "allow_http_public_sg" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_sg.id
}
resource "aws_security_group_rule" "allow_https_public_sg" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_sg.id
}
resource "aws_security_group_rule" "allow_k8s_public_sg" {
  type              = "ingress"
  from_port         = 32000
  to_port           = 32000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_sg.id
}
resource "aws_security_group_rule" "allow_ssh_public_sg" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_sg.id
}

resource "aws_security_group_rule" "allow_internal_sg" {
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = -1
  security_group_id        = aws_security_group.public_sg.id
  source_security_group_id = aws_security_group.public_sg.id
}

resource "aws_security_group_rule" "allow_icmp_public_sg" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_sg.id
}

resource "aws_security_group_rule" "egress_public_sg" {
  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_sg.id
}

