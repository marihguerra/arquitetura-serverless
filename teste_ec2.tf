resource "aws_instance" "web" {
  ami           = "ami-0169aa51f6faf20d5"
  instance_type = "t3.micro"

  tags = {
    Name = "My instance"
  }
}