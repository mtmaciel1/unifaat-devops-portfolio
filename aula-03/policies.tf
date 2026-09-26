data "aws_iam_policy_document" "s3_read" {
  statement {
    actions   = ["s3:GetObject", "s3:ListBucket"]
    resources = ["arn:aws:s3:::technova-*", "arn:aws:s3:::technova-*/*"]
  }
}

resource "aws_iam_policy" "s3_read" {
  name   = "${var.ra}-technova-s3-read"
  policy = data.aws_iam_policy_document.s3_read.json
  tags   = { Project = "TechNova", ManagedBy = "Terraform", Aluno = var.aluno, RA = var.ra, Disciplina = "DevOps - UniFAAT 2026-2", Aula = "03" }
}

data "aws_iam_policy_document" "ec2_s3_full" {
  statement {
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
  statement {
    actions   = ["ec2:StartInstances", "ec2:StopInstances"]
    resources = ["arn:aws:ec2:us-east-1:*:instance/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Project"
      values   = ["TechNova"]
    }
  }
  statement {
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::technova-*", "arn:aws:s3:::technova-*/*"]
  }
}

resource "aws_iam_policy" "ec2_s3_full" {
  name   = "${var.ra}-technova-ec2-s3-full"
  policy = data.aws_iam_policy_document.ec2_s3_full.json
  tags   = { Project = "TechNova", ManagedBy = "Terraform", Aluno = var.aluno, RA = var.ra, Disciplina = "DevOps - UniFAAT 2026-2", Aula = "03" }
}

data "aws_iam_policy_document" "deny_destructive" {
  statement {
    effect    = "Deny"
    actions   = ["ec2:TerminateInstances", "s3:DeleteBucket"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "deny_destructive" {
  name   = "${var.ra}-technova-deny-destructive"
  policy = data.aws_iam_policy_document.deny_destructive.json
  tags   = { Project = "TechNova", ManagedBy = "Terraform", Aluno = var.aluno, RA = var.ra, Disciplina = "DevOps - UniFAAT 2026-2", Aula = "03" }
}

resource "aws_iam_group_policy_attachment" "dev_s3_read" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.s3_read.arn
}

resource "aws_iam_group_policy_attachment" "dev_deny" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.deny_destructive.arn
}

resource "aws_iam_group_policy_attachment" "platform_full" {
  group      = aws_iam_group.platform_eng.name
  policy_arn = aws_iam_policy.ec2_s3_full.arn
}
