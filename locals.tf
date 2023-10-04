locals {
  hostings = {
    "home_tft_hosting" = {
        public_path = "/workspace/terraform-beginner-bootcamp-2023/public/tft"
        content_version = 1
    }
    "home_f1_cars_hosting" = {
        public_path = "/workspace/terraform-beginner-bootcamp-2023/public/f1_cars"
        content_version = 1
    }
  }
  homes = {
    "home_tft" = {
        name = "How to play TFT"
        description = <<DESCRIPTION
        Teamfight Tactics (TFT) is an auto battler game developed and published by Riot Games. 
        The game is a spinoff of League of Legends and is based on Dota Auto Chess, 
        where players compete online against seven other opponents by building a team 
        o be the last one standing.
        DESCRIPTION
        domain_name = module.terrahome_aws["home_tft_hosting"].domain_name
        town = "missingo"
        content_version = 1
    }
    "home_f1_cars" = {
        name = "How F1 Cars Work"
        description = <<DESCRIPTION
        Dive into the high-octane world of Formula 1 as we unravel the engineering marvels
        that power these lightning-fast racing machines. Our exploration will take you through
        the intricate design, cutting-edge technology, and aerodynamic wizardry behind F1 bolides.
        From the powerful engines to the innovative aerodynamics, we'll break down the components
        that make these cars the pinnacle of racing performance. Discover the secrets behind
        the speed, precision, and agility of Formula 1 cars, and gain a deeper understanding
        of the science and innovation driving the sport's evolution. Join us on a journey
        to demystify F1 bolides and learn how these incredible vehicles work their magic
        on the racetrack.
        DESCRIPTION
        domain_name = module.terrahome_aws["home_f1_cars_hosting"].domain_name
        town = "missingo"
        content_version = 1
    }
  }

}