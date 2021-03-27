terraform {
 required_version = ">= 0.14.1"
}
provider "vault" {
  address = var.vault_address
  token   = var.vault_token
}
data "vault_aws_access_credentials" "aws_credentials" {
  backend = "aws"
  role = "iam-admin"
}
provider "aws" {
  access_key = "${data.vault_aws_access_credentials.aws_credentials.access_key}"
  secret_key = "${data.vault_aws_access_credentials.aws_credentials.secret_key}"
  region = var.region
}
terraform {
 backend "s3" {
 encrypt = true
 bucket = "terraform-state-storage01"
 dynamodb_table = "terraform-state-lock-dynamo01"
 region = "us-east-2"
 key = "global/state/terraform.tfstate"
 }
}
module "nw" {
  source = "./modules/nw"
}
module "app-base" {
  source = "./modules/app-base"
}
module "db" {
  source = "./modules/db"
}
