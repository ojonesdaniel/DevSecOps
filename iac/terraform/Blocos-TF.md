# 🌱 Blocos do Terraform

O **Terraform** utiliza blocos para definir e gerenciar a infraestrutura como código (IaC). Cada bloco tem um propósito específico, e sua combinação permite a criação, modificação e gerenciamento de recursos em diversos provedores, como o **Azure**, **AWS**, **Google Cloud**, entre outros.

## 🧱 1. Bloco `provider`
Define o provedor de nuvem e suas configurações.

```hcl
provider "azurerm" {
  features {}
  subscription_id = "xxxx-xxxx-xxxx"
  client_id       = "xxxx-xxxx-xxxx"
  client_secret   = "xxxx-xxxx-xxxx"
  tenant_id       = "xxxx-xxxx-xxxx"
}
```

- **Exemplos**: azurerm, aws, google, kubernetes.  
- O **features {}** é obrigatório para o AzureRM.

---

## ⚙️ 2. Bloco `resource`
Cria e gerencia recursos no provedor especificado.

```hcl
resource "azurerm_resource_group" "example" {
  name     = "my-resource-group"
  location = "East US"
}
```

- **Estrutura**: `resource "<PROVIDER>_<RESOURCE>" "<NOME_LÓGICO>"`.  
- O **name** e **location** são atributos comuns no Azure.

---

## 🔍 3. Bloco `variable`
Define variáveis que tornam o código mais dinâmico.

```hcl
variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}
```

- **Uso**: `var.location`.  
- **Boas práticas**: definir variáveis em arquivos separados como **variables.tf**.

---

## 🎛️ 4. Bloco `output`
Exibe informações após a execução do `terraform apply`.

```hcl
output "resource_group_name" {
  value = azurerm_resource_group.example.name
}
```

- **Útil** para obter IPs, nomes e outros detalhes sem acessar o portal.

---

## 🔄 5. Bloco `data`
Consulta dados existentes sem recriar recursos.

```hcl
data "azurerm_resource_group" "example" {
  name = "my-existing-rg"
}
```

- **Exemplo**: buscar o ID de um grupo de recursos existente.

---

## 🔗 6. Bloco `module`
Reutiliza código de infraestrutura.

```hcl
module "network" {
  source = "./modules/network"
  vnet_name = "my-vnet"
  address_space = ["10.0.0.0/16"]
}
```

- **Melhor prática**: organizar o código em módulos.

---

## 🔐 7. Bloco `locals`
Define variáveis locais temporárias.

```hcl
locals {
  env_prefix = "dev"
}
```

- **Uso**: `locals.env_prefix`.

---

## 🧠 Blocos menos comuns, mas úteis:
- **`terraform`**: configura o backend e outras opções globais.  
- **`provider_aliases`**: permite múltiplos provedores do mesmo tipo.  
- **`dynamic`**: gera blocos dinamicamente dentro de recursos.

---

## 🌐 Exemplo completo no Azure:

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "my-rg"
  location = var.location
}

variable "location" {
  default = "East US"
}

output "rg_name" {
  value = azurerm_resource_group.example.name
}
```

---

## 💡 Dicas:
- Utilize o **`terraform fmt`** para manter o código padronizado.  
- **`terraform plan`** sempre antes do **`apply`**.  
- Estruture seu código com arquivos separados: **main.tf**, **variables.tf** e **outputs.tf**.

