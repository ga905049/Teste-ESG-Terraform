## Estrutura

A estrutura é definida pelo diretório principal que faz referência ao cloud provider (Ex.: aws e gcp) e subdiretórios definindo qual ambiente em questão (Ex.: prod, dev e staging).

O ambiente de prod (aws/prod) possui o arquivo principal main.tf que define a configuração do backend sendo este um bucket S3 na AWS e uam tabele no DynamoDB para controle de gravações.
