terraform {
  required_version = ">= 0.12.0"

  required_providers {
    cloudfoundry = ">= 0.11.0"
  }

  backend "s3" {
    bucket = "govuk-pay-test-tfstate"
    key    = "test-paas"
    region = "eu-west-1"
  }
}

provider "cloudfoundry" {
  version = "0.11.0"
  api_url = "https://api.cloud.service.gov.uk"
}

provider "aws" {
  version = "~> 3.0"
  region  = "eu-west-1"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_db_instance" "db_instances" {
  for_each               = toset(["ledger", "products", "card_connector", "adminusers", "publicauth"])
  db_instance_identifier = "test-${replace(each.key, "_", "-")}-rds"
}

module "paas" {
  source = "../modules/paas"

  org                      = "govuk-pay"
  space                    = "test"
  environment              = "test"
  external_domain          = "test.gdspay.uk"
  external_hostname_suffix = ""
  internal_hostname_suffix = "-test"
  credentials              = var.credentials
  aws_region               = data.aws_region.current.name
  aws_account_id           = data.aws_caller_identity.current.account_id
  rds_host_names           = data.aws_db_instance.db_instances
}