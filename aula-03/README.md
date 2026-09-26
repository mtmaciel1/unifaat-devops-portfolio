# Aula 03 — Terraform + IAM | Matheus Maciel (6325065)

## Design da Estrutura IAM
Criei dois grupos principais (`developers` e `platform_eng`) para segregar acesso. Desenvolvedores comuns e estagiários caem no grupo base com acesso de leitura (S3). Engenheiros de plataforma ganham permissões avançadas para gerenciar a infra (EC2/S3). As policies foram aplicadas diretamente nos grupos para facilitar a auditoria e escalabilidade.

## Princípio do Menor Privilégio
O menor privilégio dita que uma entidade deve ter apenas as permissões estritamente necessárias.
1. A policy `ec2_s3_full` permite dar stop/start apenas em instâncias com a tag `Project=TechNova`.
2. A policy `deny_destructive` garante que desenvolvedores e estagiários não possam deletar buckets ou terminar EC2, mesmo se uma policy futura tentar permitir.
Se eu usasse `AmazonS3FullAccess`, qualquer dev poderia deletar buckets vitais da empresa.

## Diagrama de Permissões
User (Juliana, Lucas, Rafael) -> Group (Developers / Platform) -> Custom Policies (S3 Read / EC2 Full / Deny) -> AWS Resources (EC2, S3)
Role (EC2) -> Instance Profile -> AWS EC2 Service -> Acesso S3

## Comandos Utilizados
`terraform init`, `terraform validate`, `terraform plan`, `terraform apply`, `terraform destroy`

## Reflexão
Fazer IAM via Terraform é infinitamente mais seguro e auditável do que no Console. Via código, a infra fica versionada no Git, passa por code review e qualquer tentativa de vazamento de privilégio é facilmente detectada no `terraform plan`.
