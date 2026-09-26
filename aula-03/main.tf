resource "aws_iam_group" "developers" {
  name = "${var.ra}-technova-developers"
}

resource "aws_iam_group" "platform_eng" {
  name = "${var.ra}-technova-platform-eng"
}

locals {
  common_tags = {
    Project    = "TechNova"
    ManagedBy  = "Terraform"
    Aluno      = var.aluno
    RA         = var.ra
    Disciplina = "DevOps - UniFAAT 2026-2"
    Aula       = "03"
  }
}

resource "aws_iam_user" "juliana" {
  name = "${var.ra}-juliana-dev"
  tags = local.common_tags
}

resource "aws_iam_user" "rafael" {
  name = "${var.ra}-rafael-platform"
  tags = local.common_tags
}

resource "aws_iam_user" "lucas" {
  name = "${var.ra}-lucas-intern"
  tags = local.common_tags
}

resource "aws_iam_group_membership" "dev_team" {
  name  = "${var.ra}-dev-membership"
  users = [aws_iam_user.juliana.name, aws_iam_user.rafael.name, aws_iam_user.lucas.name]
  group = aws_iam_group.developers.name
}

resource "aws_iam_group_membership" "platform_team" {
  name  = "${var.ra}-platform-membership"
  users = [aws_iam_user.rafael.name]
  group = aws_iam_group.platform_eng.name
}
