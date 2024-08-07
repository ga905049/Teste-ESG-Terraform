## Estrutura

A estrutura é definida pelo diretório principal que faz referência ao cloud provider (Ex.: aws e gcp) e subdiretórios definindo qual ambiente em questão (Ex.: prod, dev e staging).

``` text

```    

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
