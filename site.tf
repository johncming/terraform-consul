variable "ip" {}

variable "ui_port" {
  default = 8500
}

provider "docker" {
  host = "tcp://${var.ip}:2376/"
}

resource "docker_image" "consul" {
  name = "consul:0.8.1"
}

resource "docker_container" "consul" {
  image = "${docker_image.consul.latest}"
  name  = "consul"

  ports {
    internal = 8500
    external = "${var.ui_port}"
    protocol = "TCP"
  }

  volumes {
    container_path = "/consul/data"
    volume_name = "${docker_volume.consul_data.name}"
  }

  volumes {
    container_path = "/consul/config"
    volume_name = "${docker_volume.consul_config.name}"
  }

  network_mode = "host"
}

resource "docker_volume" "consul_data" {
  name = "consul_data"
}

resource "docker_volume" "consul_config" {
  name = "consul_config"
}
