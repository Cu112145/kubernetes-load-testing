provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "my_new_key"
  public_key = file("~/.ssh/my_terraform_key.pub")
}

resource "aws_instance" "react_app_instance" {
  ami           = "ami-0c03cd55b030ad658" 
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  iam_instance_profile = "ssmaccess"

  tags = {
    Name = "ReactAppInstance"
  }

  vpc_security_group_ids = ["sg-0efd5c6b28cc7eee1", "sg-010154c62c9b36a0d"]


}



# Output instance details to a JSON file
resource "local_file" "instance_info" {
  depends_on = [aws_instance.react_app_instance]
  
  content = jsonencode({
    instance_id = aws_instance.react_app_instance.id
    instance_public_ip = aws_instance.react_app_instance.public_ip
    instance_private_ip = aws_instance.react_app_instance.private_ip
  })
  filename = "${path.module}/instance_info.json"
}

output "instance_info" {
  value = local_file.instance_info.content
  depends_on = [local_file.instance_info]
}

