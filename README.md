# Infraestrutura como Serviço (IaaS)
## Desafio Minsait: Deploy de WordPress na Azure com Terraform e Docker

## Briefing do projeto

Este projeto foi desenvolvido como parte do **Desafio Extra – DevOps** do programa **Pessoa Jovem Profissional e 40+ – Infraestrutura e Cyber**, da Minsait. O objetivo é criar uma infraestrutura automatizada na Azure utilizando Terraform para provisionar uma máquina virtual, configurar o Docker na VM e iniciar um container com WordPress.

<div align="center">
  <img src="https://github.com/CamilaSCodes/desafio-infra-minsait/blob/main/imagens-infra/diagrama.jpg?raw=true" alt="diagrama" width="800">
</div>


### Requisitos

Criação de um script Terraform que realiza o seguinte, de maneira automática:
* Provisiona uma máquina virtual (VM) na Azure;
* Configura a VM para instalar o Docker;
* Inicia um container com o WordPress na VM.

### Pontos extras implementados

* **Containers Separados:** Configuração de containers separados para o WordPress e o banco de dados, garantindo a retenção de dados durante um upgrade do WordPress;
* **Comentários no Código:** Inclusão de comentários explicativos no código Terraform para indicar a função de cada bloco;
* **Arquivo docker-compose.yml:** Disponibilização de um arquivo `docker-compose.yml` para facilitar a criação dos containers;
* **Senha do Banco de Dados:** Configuração da senha do usuário root do banco de dados como GAud4mZby8F3SD6P.

### Estrutura dos arquivos

📁 `config.tf` - Arquivo de configuração do Terraform, incluindo recursos, fontes de dados e outros elementos necessários para provisionar e gerenciar a infraestrutura.

📁 `init-script.sh` - Bash Script para instalar e iniciar o Docker, configurar o `docker-compose.yml`, e criar os containers para o WordPress e o banco de dados.

### Tecnologias 

![Microsoft Azure Badge](https://img.shields.io/badge/Microsoft%20Azure-0078D4?logo=microsoftazure&logoColor=fff&style=for-the-badge) ![Docker Badge](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=fff&style=for-the-badge) ![Terraform Badge](https://img.shields.io/badge/Terraform-844FBA?logo=terraform&logoColor=fff&style=for-the-badge) ![WordPress Badge](https://img.shields.io/badge/WordPress-21759B?logo=wordpress&logoColor=fff&style=for-the-badge)

## Instruções para execução

### Pré-requisitos

1. Faça o [download](https://learn.microsoft.com/pt-br/cli/azure/install-azure-cli) do CLI do Azure e prossiga com a instalação.
2. Crie uma conta no [Azure](https://azure.microsoft.com/pt-br/).
3. Faça o [download](https://developer.hashicorp.com/terraform/install?product_intent=terraform) do Terraform.
4. Crie uma variável de ambiente com o caminho do Terraform previamente baixado.

### Passo a passo 

Clone esse repositório:
```
git clone https://github.com/CamilaSCodes/desafio-infra-minsait.git
cd desafio-infra-minsait
```
Se autentique no Azure: 
```
az login
```
Inicialize um diretório de trabalho contendo os arquivos de configuração do Terraform: 
```
terraform init
```
Crie um plano de execução e confira as alterações feitas: 
```
terraform plan
```
Execute as ações propostas no plano: 
```
terraform apply
```
Insira o site na barra de navegação e acesse o Wordpress: 
```
inframinsait.eastus2.cloudapp.azure.com
```
Agora você deve ser capaz de prosseguir com a instalação do Wordpress, caso queira. 

## Conclusão

O desenvolvimento deste projeto permitiu consolidar na prática o conhecimento teórico adquirido durante toda a capacitação em Cyber e Infraestrutura fornecida pela Minsait. Com o tema principal de Infraestrutura como Serviço (IaaS), o projeto abrangeu desde a criação de uma máquina virtual Linux na Azure até a instalação e configuração automatizada do Docker para hospedar containers do WordPress e MySQL. Além de cumprir todos os [requisitos](#requisitos) básicos, a maioria dos pontos extras solicitados também foi atendida.

   
