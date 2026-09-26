data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "${var.ra}-technova-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  tags               = { Project = "TechNova", ManagedBy = "Terraform", Aluno = var.aluno, RA = var.ra, Disciplina = "DevOps - UniFAAT 2026-2", Aula = "03" }
}

data "aws_iam_policy_document" "ec2_s3_access" {
  statement {
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["arn:aws:s3:::technova-app-data-*/*"]
  }
}

resource "aws_iam_role_policy" "ec2_s3_access" {
  name   = "${var.ra}-ec2-s3-access"
  role   = aws_iam_role.ec2_role.id
  policy = data.aws_iam_policy_document.ec2_s3_access.json
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.ra}-technova-ec2-profile"
  role = aws_iam_role.ec2_role.name
  tags = { Project = "TechNova", ManagedBy = "Terraform", Aluno = var.aluno, RA = var.ra, Disciplina = "DevOps - UniFAAT 2026-2", Aula = "03" }
}
