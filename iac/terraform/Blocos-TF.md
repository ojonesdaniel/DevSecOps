# 🌱 Blocos do Terraform

O **Terraform** utiliza blocos para definir e gerenciar a infraestrutura como código (IaC). Cada bloco tem um propósito específico, e sua combinação permite a criação, modificação e gerenciamento de recursos em diversos provedores, como o **Azure**, **AWS**, **Google Cloud**, entre outros.

## 🧱 1. Bloco `provider`
Define o provedor de nuvem e suas configurações.

```yaml
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

```yaml
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

```yaml
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

```yaml
output "resource_group_name" {
  value = azurerm_resource_group.example.name
}
```

- **Útil** para obter IPs, nomes e outros detalhes sem acessar o portal.

---

## 🔄 5. Bloco `data`
Consulta dados existentes sem recriar recursos.

```yaml
data "azurerm_resource_group" "example" {
  name = "my-existing-rg"
}
```

- **Exemplo**: buscar o ID de um grupo de recursos existente.

---

## 🔗 6. Bloco `module`
Reutiliza código de infraestrutura.

```yaml
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

```yaml
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

```yaml
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

---

# 🌱 Meta arguments

## 1. Depends On 

Essa função serve para colocar uma condição no recurso que só pode ser provisionado caso essa de dependência seja atendida.

```yaml

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestoracc"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on = [azurerm_resource_group] # Nessa linha podemos ver que o Storage Account só sera criado caso já tenha o sido criado o grupo de recursos
}
```

---

## 2. Count

O argumento count permite criar múltiplas instâncias do mesmo recurso com base em um valor numérico. Isso é útil quando você precisa de vários recursos idênticos sem duplicar código.

```yaml

resource "azurerm_storage_account" "example" {
  count = 3  # Criará 3 Storage Accounts automaticamente

  name                     = "examplestoracc${count.index}"  # Adiciona um índice para nomes únicos
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```
---

## 3. For Each

O for_each permite criar múltiplos recursos dinamicamente com base em listas (set) ou mapas (map), garantindo maior flexibilidade em relação ao count.

```YAML
variable "storage_accounts" {
  type = map(string)
  default = {
    storage1 = "West Europe"
    storage2 = "East US"
    storage3 = "Brazil South"
  }
}

resource "azurerm_storage_account" "example" {
  for_each = var.storage_accounts  # Cria um Storage Account para cada item no mapa

  name                     = "examplestoracc-${each.key}"  # Nome único para cada Storage Account
  resource_group_name      = azurerm_resource_group.example.name
  location                 = each.value  # Define a região com base no mapa
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```