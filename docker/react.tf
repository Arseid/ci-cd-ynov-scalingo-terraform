# React
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
