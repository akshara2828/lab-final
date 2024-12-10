variable "subnets" {
  description = "Subnets for the database"
  type        = list(string)
}

variable "db_password" {
  description = "Password for the database"
  type        = string
}

variable "tags" {
  description = "Tags to apply to storage resources"
  type        = map(string)
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = var.subnets
  tags       = var.tags
}

resource "aws_db_instance" "db" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7.44"  # Use a supported version
  instance_class       = "db.t3.micro"  # Updated instance class
  db_name              = "appdb"
  username             = "admin"
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  publicly_accessible  = false
  tags                 = var.tags
}

output "db_instance_address" {
  value = aws_db_instance.db.address
}
