terraform {
  required_providers {
    scalingo = {
      source  = "scalingo/scalingo"
      version = "2.3.0" # Or the latest version
    }
  }
}

variable "scalingo_token" {
  type        = string
  description = "the scalingo token"
}

provider "scalingo" {
  api_token = var.scalingo_token
  region    = "osc-fr1"
}

resource "scalingo_app" "ci_cd_app" {
  name   = "ci-cd-ynov-app"
}

resource "scalingo_addon" "mysql" {
  provider_id = "mysql"
  plan        = "mysql-starter-512"
  app         = scalingo_app.ci_cd_app.id
}

resource "scalingo_addon" "mongodb" {
  provider_id = "mongodb"
  plan        = "mongo-starter-512"
  app         = scalingo_app.ci_cd_app.id
}

resource "scalingo_container_type" "web" {
  app    = scalingo_app.ci_cd_app.name
  name   = "web"
  size   = "S"
  amount = 1
}

resource "scalingo_container_type" "api_python" {
  app    = scalingo_app.ci_cd_app.name
  name   = "api-python"
  size   = "S"
  amount = 1
}

resource "scalingo_container_type" "api_node" {
  app    = scalingo_app.ci_cd_app.name
  name   = "api-node"
  size   = "S"
  amount = 1
}