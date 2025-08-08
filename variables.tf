variable "subnet_config" {
  type = map(object({
    cidr_block = string
    public     = bool
  }))
}

variable "resource_tags" {
  type = map(string)

  default = {
    Name      = "FlowLogs"
    CreatedBy = "Terraform"
  }
}