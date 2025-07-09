variable "image_name" {
  default = "nginx:alpine"
}

variable "enable_containers" {
  type    = bool
  default = true
}

variable "container_names" {
  type    = list(string)
  default = ["one", "two", "three"]
}

variable "port_map" {
  type = map(number)
  default = {
    one   = 8081
    two   = 8082
    three = 8083
  }
}
