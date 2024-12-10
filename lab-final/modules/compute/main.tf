variable "iam_instance_profile" {}

variable "vpc_id" {
  description = "VPC ID where the compute instances will be deployed"
  type        = string
}

variable "subnets" {
  description = "Subnets for the compute instances"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to compute instances"
  type        = map(string)
}

resource "aws_instance" "app" {
  count         = 2
  ami           = "ami-0d53d72369335a9d6" # Replace with a valid AMI
  instance_type = "t2.micro"
  subnet_id     = var.subnets[count.index]
  key_name      = "my-key-pair"
  iam_instance_profile = var.iam_instance_profile
  tags          = var.tags

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              echo "Hello from App Server $(hostname)" > /var/www/html/index.html
              EOF
}

output "instance_ids" {
  value = aws_instance.app[*].id
}

output "instance_public_ips" {
  value = aws_instance.app[*].public_ip
}
