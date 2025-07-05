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

# MySQL
resource "docker_image" "mysql" {
  name = "arseid/ci-cd-ynov-arseid:mysql-latest"
}

resource "docker_container" "mysql" {
  name  = "mysql"
  image = docker_image.mysql.image_id

  env = [
    "MYSQL_ROOT_PASSWORD=root"
  ]

  ports {
    internal = 3306
    external = 3306
  }

  networks_advanced {
    name = docker_network.ci-cd-ynov-network.name
  }
}

# API Python
resource "docker_image" "api-python" {
  name = "arseid/ci-cd-ynov-arseid:api-python-latest"
}

resource "docker_container" "api-python" {
  name  = "api-python"
  image = docker_image.api-python.image_id

  env = [
    "MYSQL_HOST=mysql",
    "MYSQL_DATABASE=ynov_ci",
    "MYSQL_USER=root",
    "MYSQL_ROOT_PASSWORD=root",
    "PORT=8000"
  ]

  ports {
    internal = 8000
    external = 8000
  }

  networks_advanced {
    name = docker_network.ci-cd-ynov-network.name
  }

  depends_on = [docker_container.mysql]
}

# MongoDB
resource "docker_image" "mongo" {
  name = "mongo:6.0"
}

resource "docker_container" "mongo" {
  name  = "mongo"
  image = docker_image.mongo.image_id

  env = [
    "MONGO_INITDB_DATABASE=mydatabase"
  ]

  ports {
    internal = 27017
    external = 27017
  }

  networks_advanced {
    name = docker_network.ci-cd-ynov-network.name
  }
}

# MongoSeed
resource "docker_image" "mongo_seed" {
  name = "arseid/ci-cd-ynov-arseid:mongo-latest"
}

resource "docker_container" "mongo_seed" {
  name  = "mongo_seed"
  image = docker_image.mongo_seed.image_id

  networks_advanced {
    name = docker_network.ci-cd-ynov-network.name
  }

  depends_on = [docker_container.mongo]
}

# API NodeJS
resource "docker_image" "api-node" {
  name = "arseid/ci-cd-ynov-arseid:api-node-latest"
}

resource "docker_container" "api-node" {
  name  = "api_node"
  image = docker_image.api-node.image_id

  env = [
    "MONGO_URI=mongodb://mongo:27017/mydatabase",
    "PORT=8000"
  ]

  ports {
    internal = 8000
    external = 8001
  }

  networks_advanced {
    name = docker_network.ci-cd-ynov-network.name
  }

  depends_on = [docker_container.mongo_seed]
}

# Frontend React
resource "docker_image" "react" {
  name = "arseid/ci-cd-ynov-arseid:react-latest"
}

resource "docker_container" "react" {
  name  = "react"
  image = docker_image.react.image_id

  env = [
    "REACT_APP_SERVER_BASE_URL=http://localhost:8000",
    "REACT_APP_POSTS_SERVER_BASE_URL=http://localhost:8001/v1"
  ]

  ports {
    internal = 3000
    external = 3000
  }

  networks_advanced {
    name = docker_network.ci-cd-ynov-network.name
  }

  depends_on = [docker_container.api-python, docker_container.api-node]
}