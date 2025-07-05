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
