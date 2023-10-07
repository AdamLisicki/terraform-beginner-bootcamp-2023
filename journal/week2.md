# Terraform Beginner Bootcamp 2023 - Week 2

- [Working with Ruby](#working-with-ruby)
  - [Bundler](#bundler)
    - [Install Gems](#install-gems)
    - [Executing Ruby Scripts in the Context of Bundler](#executing-ruby-scripts-in-the-context-of-bundler)
  - [Sinatra](#sinatra)
- [Terratowns Mock Server](#terratowns-mock-server)
  - [Running the Web Server](#running-the-web-server)
- [CRUD](#crud)
- [Install Custom Provider](#install-custom-provider)
- [How to Create or Remove a Home](#how-to-create-or-remove-a-home)

## Working with Ruby

### Bundler

Bundler is a package manager for ruby.
It is the primary way to install ruby packages (known as gems) for ruby.

#### Install Gems

You need to create a Gemfile and define your gems in that file.

```rb
source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
```

Then you need to run the `bundle install` command

This will install the gems on the system globally (unlike nodejs which install packages in place in a folder called node_modules)

A Gemfile.lock will be created to lock down the gem versions used in this project.

#### Executing ruby scripts in the context of bundler

We have to use `bundle exec` to tell future ruby scripts to use the gems we installed. This is the way we set context.

### Sinatra

Sinatra is a micro web-framework for ruby to build web-apps.

Its great for mock or development servers or for very simple projects.

You can create a web-server in a single file.

https://sinatrarb.com/

## Terratowns Mock Server

### Running the web server

We can run the web server by executing the following commands:

```rb
bundle install
bundle exec ruby server.rb
```

All of the code for our server is stored in the `server.rb` file.

## CRUD

Terraform Provider resources utilize CRUD.

CRUD stands for Create, Read Update, and Delete

https://en.wikipedia.org/wiki/Create,_read,_update_and_delete


## Install Custom Provider

To build the custom provider `terratown` we need to run script `build_provider` that is located in the `bin` directory.

## How to Create or Remove a Home

In `locals.tf` are stored information about homes. 


```
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
```

To add new home eg. `home_lotr` we need to add new hosting `home_lotr_hosting` and provide path to the folder within public directory where are stored website files.
 
 ```
  hostings = {
    "home_tft_hosting" = {
        public_path = "/workspace/terraform-beginner-bootcamp-2023/public/tft"
        content_version = 1
    }
    "home_f1_cars_hosting" = {
        public_path = "/workspace/terraform-beginner-bootcamp-2023/public/f1_cars"
        content_version = 1
    }
    "home_lotr_hosting" = {
        public_path = "/workspace/terraform-beginner-bootcamp-2023/public/lotr"
        content_version = 1
    }

```

Then we need to enter the information about home in homes section. 
We need to provide: 

    - name - title of our website
    - description - description of our website
    - domain_name - we don't know this value because this is the output for our terrahome_aws module, so we need to reference to this value `module.terrahome_aws["home_lotr"].domain_name`.
    - town - town for our webiste
    - content_version - version of website

```
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
    "home_lotr" = {
        name = "Lord of The Rings website"
        description = <<DESCRIPTION
        Description for the Lord of The Rings website.
        DESCRIPTION
        domain_name = module.terrahome_aws["home_lotr_hosting"].domain_name
        town = "missingo"
        content_version = 1
    }
  }
```