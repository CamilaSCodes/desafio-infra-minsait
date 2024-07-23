# Define a Azure como provedora dos recursos na Cloud
terraform { 
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.112.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

# Cria o container para os recursos da VM, definindo nome e região
resource "azurerm_resource_group" "rg-tf" {
  name     = "rg-terraform"
  location = "eastus2"

  tags = {
    environment = "terraform"
  }
}

# Bloco de construção da faixa de endereçamento

# Configuração padrão para criação de rede virtual
resource "azurerm_virtual_network" "vnet" {
  name                = "rg-vnet"
  address_space       = ["10.0.0.0/16"] 
  # Associa a rede virtual ao grupo de recursos
  location            = azurerm_resource_group.rg-tf.location
  resource_group_name = azurerm_resource_group.rg-tf.name

  tags = {
    environment = "terraform"
  }
}

# Configuração padrão para criação de subrede dentro da rede virtual
resource "azurerm_subnet" "subnet" {
  name                 = "rg-subnet"
  resource_group_name  = azurerm_resource_group.rg-tf.name  # Associa a subnet ao grupo de recursos
  virtual_network_name = azurerm_virtual_network.vnet.name  # Associa a subnet à rede virtual
  address_prefixes     = ["10.0.2.0/24"]
}

# Bloco de configurações de segurança

# Associa um firewall ao grupo de recursos
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-terraform"
  location            = azurerm_resource_group.rg-tf.location
  resource_group_name = azurerm_resource_group.rg-tf.name

  tags = {
    environment = "terraform"
  }
}

# Cria regra no firewall para permitir o tráfego interno 
resource "azurerm_network_security_rule" "rule" {
  name                        = "rule-terraform"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg-tf.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Associa o firewall e suas regras à subrede criada
resource "azurerm_subnet_network_security_group_association" "nsg-association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id 
} 

# Bloco de configuração para conexão 

# Define um IP público e DNS para permitir o acesso externo ao grupo de recursos
resource "azurerm_public_ip" "ip" {
  name                = "ip-tf"
  resource_group_name = azurerm_resource_group.rg-tf.name
  location            = azurerm_resource_group.rg-tf.location
  allocation_method   = "Dynamic"
  domain_name_label   = "inframinsait"

  tags = {
    environment = "terraform"
  }
}

# Cria a interface de rede do grupo de recursos
resource "azurerm_network_interface" "nic" {
  name                = "rg-nic"
  location            = azurerm_resource_group.rg-tf.location
  resource_group_name = azurerm_resource_group.rg-tf.name

  ip_configuration { # Define os endereços de IP privado e público
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip.id
  }

  tags = {
    environment = "terraform"
  }
}

# Cria a Máquina Virtual Linux dentro do grupo de recursos
resource "azurerm_linux_virtual_machine" "vm-tf" {
  name                = "vm-terraform"
  resource_group_name = azurerm_resource_group.rg-tf.name
  location            = azurerm_resource_group.rg-tf.location
  size                = "Standard_F2"
  admin_username      = "adminuser"

  network_interface_ids = [ # Configura a interface de rede
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key { # Configuração para acesso remoto
    username   = "adminuser"
    public_key = file("~/.ssh/chaveazure.pub")
  }

  # Configuração padrão para montagem da máquina
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
 
  # Chama o script para instalar o Docker e os containers com o Wordpress e Banco de Dados
  custom_data = base64encode(file("init-script.sh"))
}

