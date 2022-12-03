# Warning: Never check sensitive values like usernames and passwords into source control.
# MAIN.TF FILE
# Create RDS MySQL Database
resource "aws_db_instance" "db1" {
  allocated_storage   = 5
  engine              = "mysql"
  instance_class      = "db.t2.micro"
  name                = "mydb1"
  username            = var.db_username       # The same syntax has to maintain in both variable.tf and secrets.tfvars files
  password            = var.db_password       # The same here too
  skip_final_snapshot = true
}
