terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
#   cloud {
#     organization = "TBBorg"

#     workspaces {
#       name = "terra-house-1"
#     }
#   }
}

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.teacherseat_user_uuid
  # bucket_name = var.bucket_name
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  content_version = var.content_version
  assets_path = var.assets_path
}
resource "terratowns_home" "home" {
  name = "How to play Teamfight Tactics"
  description = <<DESCRIPTION
Teamfight Tactics (TFT) is an auto battler game developed and published by Riot Games. 
The game is a spinoff of League of Legends and is based on Dota Auto Chess, 
where players compete online against seven other opponents by building a team 
to be the last one standing.
  DESCRIPTION
  domain_name = module.terrahouse_aws.cloudfront_url
  town =  "missingo"
  content_version = var.content_version
  
}