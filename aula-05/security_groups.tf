resource "aws_security_group" "ec2" {
  name        = "technova-ec2-sg"
  description = "Permite SSH e porta 3000 para EC2"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "API Port"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "technova-ec2-sg"
  }
}

resource "aws_security_group" "rds" {
  name        = "technova-rds-sg"
  description = "Permite conexao PostgreSQL vinda do SG do EC2"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "PostgreSQL de EC2 SG"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "technova-rds-sg"
  }
}