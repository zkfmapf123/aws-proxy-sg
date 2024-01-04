########################### rds subnet group ###########################
resource "aws_db_subnet_group" "subnet-group" {
  name        = "poc-rds-subnet-group"
  description = "poc-rds-subnet-group"
  subnet_ids  = local.subnet_ids
}

########################### rds ###########################
resource "aws_db_instance" "poc-rds" {

}
