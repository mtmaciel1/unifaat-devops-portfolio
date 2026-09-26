output "users" { value = [aws_iam_user.juliana.name, aws_iam_user.rafael.name, aws_iam_user.lucas.name] }
output "groups" { value = [aws_iam_group.developers.name, aws_iam_group.platform_eng.name] }
output "policies" { value = [aws_iam_policy.s3_read.arn, aws_iam_policy.ec2_s3_full.arn, aws_iam_policy.deny_destructive.arn] }
output "role_arn" { value = aws_iam_role.ec2_role.arn }
