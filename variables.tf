variable "flow_market_image" {
    description = "repository url for the main app's image."
    type    = "string"
    default = "hademircii/flow-market:latest"
}

variable "region" {   
    description = "aws availability zone."
    type = "string" # yes, assume single zone.
    default = "us-west-1"
}

variable "app_secret" {   
    description = "secret key for app to use."
    type = "string"
}

variable "pg_user" {   
    description = "default postgres user."
    type = "string"
}

variable "pg_password" {   
    description = "pasword for default postgres user."
    type = "string"
}

variable "pg_db_name" {   
    description = "default postgres db name."
    type = "string"
}

variable "pg_volume_name" {   
    description = "postgres volume name for task definition."
    type = "string"
    default = "postgres-data"
}