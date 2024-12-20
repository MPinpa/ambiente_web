# Ambiente Web Terraform

## Sobre o App

Esse terraform consiste em criar estrutura na aws para suportar aplicação web.

### Recursos a serem criados:

- EC2
- Elastic IP
- RDS
- IAM ( roles, policy e instance\_profile )
- SG
- NETWORK ( VPC, SUBNETS, IGW e RTB )

## Pré-requisitos

Antes de começar, certifique-se de ter os seguintes itens instalados e configurados em sua máquina:

- [Terraform](https://developer.hashicorp.com/terraform/downloads) (versão mínima recomendada: `1.4.6`)
- Permissão de leitura e escrita para criar os recursos acima.
- Conta na AWS com permissões adequadas para provisionar os recursos necessários
- Sistema operacional Linux
- [AWS CLI](https://aws.amazon.com/cli/) Instalado 

## Configuração de Credenciais AWS

Este projeto utiliza duas variáveis para configurar as credenciais de acesso à AWS:

- **access\_key**: A chave de acesso da AWS
- **secret\_key**: A chave secreta correspondente

Essas variáveis devem ser configuradas no arquivo `terraform.tfvars` para que o Terraform possa autenticar na AWS.

### Exemplo no arquivo `terraform.tfvars`:

```hcl
access_key = "sua_access_key_aqui"
secret_key = "sua_secret_key_aqui"
```

Certifique-se de manter esse arquivo em um local seguro ou use variaveis de ambiente, pois contém informações sensiveis.

## Configuração Inicial

1. Clone este repositório para sua máquina local:

```bash
git clone <URL_DO_REPOSITORIO>
cd <DIRETORIO_DO_REPOSITORIO>
```

2. Crie um arquivo `terraform.tfvars` na raiz do projeto e insira suas credenciais da AWS conforme mostrado acima.

3. Opcionalmente, edite o arquivo `variables.tf` para configurar variáveis adicionais conforme necessário (como região, tipos de instância, etc.).

### Exemplo de utilização

Dentro do arquivo do `terraform.tfvars` mantenha dessa maneira.

```hcl
## AUTENTICATION
######################

region = "us-east-1"
access_key = ""
secret_key = ""

## PROJECT
#####################

project_name = "suporteshow"
env_name = "prod"

## NETWORK
#####################

vpc_cidr_block = "10.0.0.0/16"
public_subnets_cidr = ["10.0.0.0/24", "10.0.1.0/24"]
private_subnets_cidr = ["10.0.2.0/24", "10.0.3.0/24"]

## APPS
####################

apps = [
  {
    app_name = "suporteshow"
    ingress_allow = [
      {
        port         = 80
        protocol     = "tcp"
        cidr_blocks  = ["0.0.0.0/0"]
      },
      {
        port         = 443
        protocol     = "tcp"
        cidr_blocks  = ["0.0.0.0/0"]
      },
      {
        port         = 22
        protocol     = "tcp"
        cidr_blocks  = ["170.333.333.6/32"]
      }
    ]
  }
  # NOVAS APLICAÇÕES PODEM SER INSERIDAS A PARTIR DAQUI
]
```



### Reference



| Nome da Variável       | Tipo da Variável | Explicação                                 |
| ---------------------- | ---------------- | ------------------------------------------ |
| region                 | string           | Região da AWS.                             |
| access\_key            | string           | Access key da AWS para autenticação.       |
| secret\_key            | string           | Secret key da AWS para autenticação.       |
| project\_name          | string           | Nome do projeto.                           |
| env\_name              | string           | Nome do ambiente (exemplo: dev, qa, prod). |
| vpc\_cidr\_block       | string           | O CIDR block da VPC.                       |
| public\_subnets\_cidr  | list(string)     | Lista de range de IP da subnet pública.    |
| private\_subnets\_cidr | list(string)     | Lista de range de IP da subnet privada.    |
| apps                   | list(Map(any))   | Lista de aplicativos que devem ser criados |


### `apps` block reference


| Argumento       | Tipo            | Explicação                                     |
|------------------|-----------------|-----------------------------------------------|
| app_name         | string          | O nome da aplicação.                          |
| ingress_allow    | list(map)       | Lista de redes permitidas para acessar a aplicação. |

### `ingress_allow` block reference

| Argumento       | Tipo            | Explicação                                     |
|------------------|-----------------|-----------------------------------------------|
| port             | number          | A porta que será acessada.                    |
| protocol         | string          | O protocolo utilizado para o acesso.          |
| cidr_blocks      | list(string)    | Lista de endereços IP permitidos para acesso. |


## Como Rodar o Terraform

1. **Inicialize o Terraform**:
Este comando baixa os provedores e configura os módulos necessários.

```bash
terraform init
```

2. **Planeje a execução**:
Veja um plano do que o Terraform criará ou modificará.

```bash
terraform plan
```

3. **Aplique a configuração**:
Provisione os recursos na AWS com o comando abaixo. Certifique-se de que o plano de execução está correto antes de confirmar.

```bash
terraform apply
```

Durante a execução, o Terraform solicitará sua confirmação. Digite `yes` para continuar.

4. **Destruir os recursos (opcional)**:
Caso precise remover os recursos provisionados, use o comando:

```bash
terraform destroy
```

## Estimativa de custos


## Sobre o Infracost
O Infracost ajuda a estimar os custos da infraestrutura em nuvem baseada nas configurações do Terraform. Ele se integra facilmente ao fluxo de trabalho e fornece uma análise detalhada de custos para recursos da AWS, Azure e GCP.

---

## Criar uma Conta

1. Acesse o [site do Infracost](https://www.infracost.io/).
2. Cadastre-se gratuitamente clicando em **Sign Up**.
3. Após o cadastro, você receberá um **token de API**. Guarde este token com segurança, pois ele será usado para autenticar o CLI do Infracost.

---

## Instalar o Infracost

### Em Linux ou macOS:
Execute o comando abaixo para instalar o Infracost:
```bash
curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh
```

### Verificar instalação

```bash
infracost --version
```

## Configurar terraform para gerar os custos

### Autenticar na AWS

```
aws configure
```

### Autenticar no infracost

```bash
infracost auth login
```
### Executar o plan do terraform

```bash
terraform plan -out=plan.out
```

### Estimar o custo com infracost

```bash
infracost breakdown --path plan.out
```

## Problemas Comuns

- **Erro de autenticação na AWS:** Verifique se as chaves de acesso e região estão corretas no arquivo `terraform.tfvars`.
- **Terraform não inicializa:** Certifique-se de que o comando `terraform init` foi executado com sucesso e que os provedores foram baixados corretamente.

Para mais dúvidas ou problemas, consulte a [documentação oficial do Terraform](https://developer.hashicorp.com/terraform/docs) ou entre em contato com a equipe responsável.

