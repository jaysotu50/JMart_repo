# create security group for the application load balancer
resource "aws_security_group" "alb_security_group" {
  name        = "alb security group"
  description = "enable http/https access on port 80/443"
  vpc_id      = var.vpc_id

  ingress {
    description      = "http access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "https access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "alb security group"
  }
}

# Create security for the container
# resource "aws_security_group" "ecs-security-group" {
#   name        = "ecs security group"
#   description = "enable http/https access on port 80/443 via alb sg"
#   vpc_id      = var.vpc_id

#   ingress {
#     description          = "http access"
#     from_port            = 80
#     to_port              = 80
#     protocol             = "tcp"
#     security_groups      = [aws_security_group.alb_security_group.id]
#   }

#    ingress {
#     description          = "https access"
#     from_port            = 443
#     to_port              = 443
#     protocol             = "tcp"
#     security_groups      = [aws_security_group.alb_security_group.id]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = -1
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   tags   = {
#     Name = " ecs security group"
#   }
# }

# Create Security Group for the Bastion Host aka Jump Box
# terraform aws create security group
resource "aws_security_group" "ssh-security-group" {
  name        = "ssh security group"
  description = "enable ssh access on port 22 via alb sg"
  vpc_id      = var.vpc_id

  ingress {
    description          = "ssh access"
    from_port            = 22
    to_port              = 22
    protocol             = "tcp"
    security_groups      = [aws_security_group.alb_security_group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "ssh security group"
  }
}


# Create Security Group for the Web Server
# terraform aws create security group
resource "aws_security_group" "webserver-security-group" {
  name        = "webserver security group"
  description = "enable http/https traffic from ports 80/443 via alb"
  vpc_id      = var.vpc_id

  ingress {
    description      = "webserver http access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb_security_group.id]
  }

  ingress {
    description      = "webserver https access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb_security_group.id]
  }

  ingress {
    description      = " ssh bastion acces"
    from_port        = 20
    to_port          = 20
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb_security_group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "webserver security group"
  }
}

# Create Security Group for the Database
# terraform aws create security group
resource "aws_security_group" "database-security-group" {
  name        = "database security group"
  description = "Enable Aurora/MySQL/MariaDB access throught port 3306 via webserver sg"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Aurora/MySQL/MariaDB access"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = [aws_security_group.webserver-security-group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "database security group"
  }
}