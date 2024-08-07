## Estrutura

A estrutura é definida por diretórios que fazem referência ao cloud provider (Ex.: aws e gcp) e subdiretórios definindo qual ambiente em questão (Ex.: prod, dev e staging).

``` text
.
├── aws
│   └── prod
│       ├── instance.tf
│       ├── key_pair.tf
│       ├── load_balancer.tf
│       ├── locals.tf
│       ├── main.tf
│       ├── output.tf
│       ├── provider.tf
│       ├── security_group.tf
│       └── vpc.tf
```    

## Requisitos
O ambiente de prod (aws/prod) possui o arquivo principal **main.tf** que define a configuração do backend sendo este um bucket S3 na AWS e uma tabela no DynamoDB para controle de gravações.

Deve ser criado um usuário para o terraform atribuindo a role  **AdministratorAccess**.

Deve ser criado um bucket S3 com **Block all public access** **habilitado**, **versionamento habilitado** e com a policy abaixo:

``` text
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam:::user/[nome-do-usuário]"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::[nome-do-bucket]"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam:::user/[nome-do-usuário]"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::[nome-do-bucket]/*"
        }
    ]
}
```

## Recursos

Foram provisionados os seguintes recursos:

Instances:

- bastion: Instância pública que ao acessar via SSH permite acesso a rede interna.
- nat-gw: Permite acesso à interna a partir das subnets privadas.
- docker-server: Instância que executa o docker engine e os containers da aplicação (frontend e backend).

Security Groups:

- docker-server-sg: Security group da instância docker-server.
- bastion-sg: Security group da instância bastion.
- nat-gw-sg: Security group da instância nat-gw.
- lb-app-sg: Security group do Load Balancer.

Network:

- vpc_producao: Foi criado uma VPC /16 para execução dos recursos.
- Subnets: Foram criadas três subnets privadas e três subnets públicas.
- private-subnet-a-route: Rota criada para enviar o tráfego público das subnets privadas para a instância nat-gw
- private-subnet-b-route: Rota criada para enviar o tráfego público das subnets privadas para a instância nat-gw 
- private-subnet-c-route: Rota criada para enviar o tráfego público das subnets privadas para a instância nat-gw 

Load Balancer:

- app-lb: Load balancer público do tipo Application criado para expor a aplicação.
- app-tg: Target group vinculado á instância docker-server e ao load balancer app-lb.
- app-tg-attach: Vinculo da instância docker-server com o target grpup app-tg.
- app-listener: Listener na porta 80 criado para expor a aplicação através do load balancer.

Key Pair:

- infra-aws-pk: Chave privada.
- infra-prod-key: Par de chaves criado a partir da chave privada infra-aws-pk para acesso às instâncias.

Locals:

- ubuntu-focal: Data utilizado para recuperar o id da AMI do ubuntu focal.
- amazon-linux-2-ami: Data utilizado para recuperar o id da AMI do amazon linux 2. 
- project_name: Nome da VPC.
- vpc_cidr: Bloco CIDR da VPC.
- azs: Lista com a quantidade de zonas de disponibilidade da região de us-east-1.


Output:

- private_key: Output da chave privada infra-aws-pk para ser possível recupera-lo e acessar as instâncias via SSH.



## Comandos

Caso opte pela execução do terraform localmente você pode utilizar os seguintes comandos:

Acesse o diretório onde esta o backend do ambiente que queremos alterar:

``` text
cd aws/prod
```
Inicie o código terraform e formate-o corretamente:

``` text
terraform init
terraform fmt -recursive
```

Para aplicar alterações/criações:

``` text
terraform plan
terraform apply
```

Para aplicar alterações/criações específicas:

``` text
terraform plan
terraform apply -target=[recurso]
```
Para destruir todos os recursos:

``` text
terraform destroy
```

Para destruir um recurso específico:

``` text
terraform destroy -target=[recurso]
```

## CI/CD

O arquivo principal que configura a pipeline é o **terraform.yml** que está em **.github/workflows**. Para executar a pipeline basta fazer um push para a branch main.

Para que seja criado um job segregado para cada ambiente, foi configurado workspaces (Ex.: aws/prod). 

A pipeline possui os seguintes steps:

- Configure aws credentials: Configura as credencias da AWS que devem ser criadas como secrets no github com o nome de AWS_ACCESS_KEY_ID e AWS_SECRET_ACCESS_KEY.
Setup Terraform.
- Terraform Init: Inicializa o código terraform.
- Terraform Format: Checa se a formatação esta correta.
- Terraform Plan: Realiza o plan e exibe no console do github.
- Terraform Apply: Aplica as alterações.
