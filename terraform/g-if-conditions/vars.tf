variable "image_name" {
  default = "nginx:alpine"
}

variable "enable_containers" {
  description = "Whether to start containers or not"
  type        = bool
  default     = true
}

variable "container_names" {
  default = ["web1", "web2", "web3"]
}

variable "port_map" {
  type = map(number)
  default = {
    web1 = 8051
    web2 = 8052
    web3 = 8053
  }
}
