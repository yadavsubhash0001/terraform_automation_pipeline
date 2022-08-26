provider "aws" {
  access_key = "put your id here"
  secret_key = "put your key here"
  region     = "us-east-1"
}
resource "aws_instance" "server" {
  ami             = "ami-04505e74c0741db8d"
  instance_type   = "t2.medium"
  security_groups = ["allow_all"]
  user_data = <<-EOF
#! /bin/bash
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKjCudOb1foC+TdIX2+LCjZSXdi/E9nbJ5Lck7g0+4jmv21vpW0RfvkhK6DsooQVhhutt2NaVVQysw8pBNQLDCZyX/lqFHsW+rTN6Nljtvwx+tdreaJWizcfYnfhNh8xk+RmB+pCTxKaLNKk2Jr7L8r3qVyRJm6isSy5+edSwHnRlFXakqLnryj90yQJGOjOdiZ/STRWaB1kRWNnua8jMjR7KlYzvCVEExa1EAKfpI+PzbqpfpOwOWNbqr1Vdi5w9eF35yj8r51ZP0AUV43XayxQHFQPKbSEOembJybnGhhwk0IlAo7SgWO0i339+enr61pWMW4JDXPYmiT/sXnkmP websultanate@websultanate-260-a040il
" > /root/.ssh/authorized_keys
sudo apt-get update
sudo apt-get install -y python
EOF
  root_block_device {
    volume_size = 40
  }
  tags = {
    Name = "ipless"
  }
}
resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"

  ingress = [
    {
      description      = "Custom TCP"
      from_port        = 22
      to_port          = 500
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      self             = true
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      description      = "Custom TCP"
      from_port        = 3000
      to_port          = 3010
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      self             = true
      prefix_list_ids  = []
      security_groups  = []
    }
  ]
  egress = [
    {
      description      = "All traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      self             = true
      prefix_list_ids  = []
      security_groups  = []
    }
  ]
  tags = {
    Name = "allow_all"
  }

}
output "ansible_host" {
  value = aws_instance.server.public_ip
}
