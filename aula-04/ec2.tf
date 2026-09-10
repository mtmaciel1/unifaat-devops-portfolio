# =============================================================
# AMAZON LINUX 2023
# =============================================================

data "aws_ami" "latest_al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# =============================================================
# KEY PAIR
# =============================================================

resource "aws_key_pair" "technova_key" {
  key_name   = "${var.project_name}-key"
  public_key = file("~/.ssh/technova-key.pub")

  tags = {
    Name = "${var.project_name}-key"
  }
}

# =============================================================
# EC2
# =============================================================

resource "aws_instance" "api" {
  ami           = data.aws_ami.latest_al2023.id
  instance_type = "t2.micro"

  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.api.id]
  associate_public_ip_address = true

  key_name = aws_key_pair.technova_key.key_name

  # AWS Academy bloqueia a criação de IAM Roles.
  # Utilizamos o Instance Profile já disponibilizado pelo Learner Lab.
  iam_instance_profile = "LabInstanceProfile"

  user_data = file("${path.module}/user_data.sh")

  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "${var.project_name}-api"
  }
}