variable "enable_containers" {
  type    = bool
  default = true
}

variable "container_names" {
  type    = list(string)
  default = ["web", "api", "db"]
}

variable "port_map" {
  type = map(object({
    internal = number
    external = number
  }))
  default = {
    web = {
      internal = 80
      external = 8080
    }
    api = {
      internal = 5000
      external = 5001
    }
    db = {
      internal = 3306
      external = 33060
    }
  }
}

variable "image_name" {
  type    = string
  default = "nginx:latest"
}

