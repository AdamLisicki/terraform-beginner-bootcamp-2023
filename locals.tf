locals {
  hostings = {
    "home_tft_hosting" = {
        public_path = "/workspaces/terraform-beginner-bootcamp-2023/public/tft"
        content_version = 8
    }
  }
  homes = {
    "home_tft" = {
        name = "Teamfight Tactics Guide"
        description = <<DESCRIPTION
        Here’s everything you need to know before jumping into your first Teamfight Tactics game.
        DESCRIPTION
        domain_name = module.terrahome_aws["home_tft_hosting"].domain_name
        town = "gamers-grotto"
        content_version = 8
    }
  }

}