resource "aws_eip" "terraform_eip" {
  vpc      = true
  tags = {
    Name = "terraform_eip"
  }
}

