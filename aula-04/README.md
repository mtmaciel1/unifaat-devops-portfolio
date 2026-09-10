# Infraestrutura TechNova — Aula 04

Infraestrutura AWS criada com Terraform para a Aula 04 de DevOps.

O projeto implementa uma VPC com arquitetura Multi-AZ, subnets públicas e privadas, Internet Gateway, Route Table, Security Groups e uma instância EC2 executando uma API Node.js.

## Arquitetura

```text
                          INTERNET
                              |
                     Internet Gateway
                              |
                  +-----------------------+
                  |    TechNova VPC       |
                  |     10.0.0.0/16       |
                  |                       |
        +---------+-----------+-----------+---------+
        |                                             |
   us-east-1a                                    us-east-1b
        |                                             |
 +------+-------+                              +------+-------+
 |              |                              |              |
Public        Private                        Public        Private
10.0.1.0/24   10.0.2.0/24                  10.0.3.0/24   10.0.4.0/24
 |                                             |
 |                                             |
 +------ Public Route Table -------------------+
              |
         0.0.0.0/0
              |
       Internet Gateway

EC2 TechNova API
 |
 +-- Public Subnet
 +-- t2.micro
 +-- Amazon Linux 2023
 +-- Node.js 18
 +-- API Express :3000
 +-- API Security Group
```

## Recursos criados

| Recurso | Função |
|---|---|
| VPC | Rede principal da infraestrutura TechNova |
| 2 Subnets Públicas | Recursos que precisam de acesso direto à internet |
| 2 Subnets Privadas | Recursos internos sem acesso direto à internet |
| Internet Gateway | Comunicação da VPC com a internet |
| Public Route Table | Rota `0.0.0.0/0` para o Internet Gateway |
| Route Table Associations | Associação das duas subnets públicas à tabela pública |
| API Security Group | Libera SSH na porta 22 e API Node.js na porta 3000 |
| Database Security Group | Libera PostgreSQL na porta 5432 somente dentro da VPC |
| Key Pair | Permite acesso SSH à EC2 |
| EC2 | Executa a TechNova API |
| User Data | Instala e configura automaticamente Node.js e a aplicação |
| LabInstanceProfile | Instance Profile disponibilizado pelo AWS Academy |

## Pré-requisitos

- Terraform instalado
- AWS CLI instalada
- Credenciais válidas do AWS Academy Learner Lab
- Chave SSH em `~/.ssh/technova-key`
- Chave pública em `~/.ssh/technova-key.pub`

## Como executar

Inicialize o Terraform:

```bash
terraform init
```

Formate e valide:

```bash
terraform fmt
terraform validate
```

Visualize o plano:

```bash
terraform plan
```

Crie a infraestrutura:

```bash
terraform apply
```

Confirme digitando:

```text
yes
```

Após a criação:

```bash
terraform output
```

## Testando a API

URL principal:

```bash
curl "$(terraform output -raw api_url)"
```

Health check:

```bash
curl "$(terraform output -raw api_url)/health"
```

Pedidos:

```bash
curl "$(terraform output -raw api_url)/orders"
```

## Acesso SSH

```bash
ssh -i ~/.ssh/technova-key ec2-user@$(terraform output -raw ec2_public_ip)
```

Para verificar Node.js e identidade AWS:

```bash
node --version
aws sts get-caller-identity
```

## Decisões técnicas

### Multi-AZ

Foram utilizadas duas Availability Zones para distribuir as subnets e preparar a infraestrutura para maior disponibilidade e futura utilização de recursos como Load Balancer.

### Subnets públicas e privadas

As subnets públicas possuem acesso ao Internet Gateway e podem hospedar recursos que precisam receber tráfego externo.

As subnets privadas não possuem rota direta para a internet e são destinadas a componentes internos, como bancos de dados.

### Security Groups

O Security Group da API permite somente as portas necessárias para o exercício: SSH na porta 22 e a API na porta 3000.

O Security Group do banco permite acesso à porta PostgreSQL 5432 apenas a partir da rede interna `10.0.0.0/16`.

### Inicialização automática

A API é configurada pelo User Data durante a criação da EC2. Um serviço systemd mantém a aplicação Node.js ativa e permite sua inicialização automática após reinicializações da instância.

### Instance Profile no AWS Academy

O ambiente AWS Academy Learner Lab possui restrições para criação de determinados recursos IAM. Por isso, a EC2 utiliza o `LabInstanceProfile` disponibilizado pelo próprio ambiente Academy.

## Evidências

Os arquivos de evidência estão nesta pasta:

- `evidencia-plan.txt`
- `terraform-plan-output.txt`
- `evidencia-api.json`
- `evidencia-ssh.txt`

## Destruindo a infraestrutura

Após os testes e coleta das evidências:

```bash
terraform destroy
```

Confirme digitando:

```text
yes
```

Isso remove os recursos criados pelo Terraform e evita consumo desnecessário de recursos AWS.