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
