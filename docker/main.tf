terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {
}

resource "docker_network" "ci-cd-ynov-network" {
  name = "ci-cd-ynov-network"
}
