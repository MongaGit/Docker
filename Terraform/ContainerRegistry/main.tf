
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}


resource "azurerm_network_security_group" "nsg" {
  name                = "NSG-Monga"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = var.tags
}


resource "azurerm_virtual_network" "vnet" {
  name                = var.resource_virtual_network
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = var.resource_subnet
    address_prefix = "10.0.1.0/24"
  }
  tags = var.tags
}



locals {
  roles_map = { for role in var.roles : "${role.object_id}.${role.role}" => role }

  diag_contreg_logs = [
    "ContainerRegistryRepositoryEvents",
    "ContainerRegistryLoginEvents",
  ]
  diag_contreg_metrics = [
    "AllMetrics",
  ]

  diag_resource_list = var.diagnostics != null ? split("/", var.diagnostics.destination) : []
  parsed_diag = var.diagnostics != null ? {
    log_analytics_id   = contains(local.diag_resource_list, "Microsoft.OperationalInsights") ? var.diagnostics.destination : null
    storage_account_id = contains(local.diag_resource_list, "Microsoft.Storage") ? var.diagnostics.destination : null
    event_hub_auth_id  = contains(local.diag_resource_list, "Microsoft.EventHub") ? var.diagnostics.destination : null
    metric             = contains(var.diagnostics.metrics, "all") ? local.diag_contreg_metrics : var.diagnostics.metrics
    log                = contains(var.diagnostics.logs, "all") ? local.diag_contreg_logs : var.diagnostics.logs
    } : {
    log_analytics_id   = null
    storage_account_id = null
    event_hub_auth_id  = null
    metric             = []
    log                = []
  }
}

resource "azurerm_container_registry" "acr" {
  name                = format("%sregistry", lower(replace(var.name, "/[[:^alnum:]]/", "")))
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.sku
  admin_enabled       = false
  tags                = var.tags

  trust_policy {
    enabled = var.content_trust && var.sku == "Premium"
  }
}

resource "azurerm_role_assignment" "roles" {
  for_each = local.roles_map

  scope                = azurerm_container_registry.acr.id
  role_definition_name = each.value.role
  principal_id         = each.value.object_id
}

data "azurerm_monitor_diagnostic_categories" "default" {
  resource_id = azurerm_container_registry.acr.id
}

resource "azurerm_monitor_diagnostic_setting" "namespace" {
  count = var.diagnostics != null ? 1 : 0

  name                           = "${var.name}-registry-diag"
  target_resource_id             = azurerm_container_registry.acr.id
  log_analytics_workspace_id     = local.parsed_diag.log_analytics_id
  eventhub_authorization_rule_id = local.parsed_diag.event_hub_auth_id
  eventhub_name                  = local.parsed_diag.event_hub_auth_id != null ? var.diagnostics.eventhub_name : null
  storage_account_id             = local.parsed_diag.storage_account_id

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.default.log_category_types
    content {
      category = log.value
      enabled  = contains(local.parsed_diag.log, log.value)

      retention_policy {
        enabled = false
        days    = 0
      }
    }
  }

  # Ref: https://github.com/terraform-providers/terraform-provider-azurerm/issues/7235
  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.default.metrics
    content {
      category = metric.value
      enabled  = contains(local.parsed_diag.metric, metric.value)

      retention_policy {
        enabled = false
        days    = 0
      }
    }
  }
}


