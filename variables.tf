
variable "terratowns_endpoint" {
  type = string
}

variable "terratowns_access_token" {
  type = string
  sensitive = true
}

variable "teacherseat_user_uuid" {
  type = string
  sensitive = true
}

# variable "tft" {
#   type = object({
#     public_path = string
#     content_version = number
#   })
# }

# variable "f1_cars" {
#   type = object({
#     public_path = string
#     content_version = number
#   })
# }