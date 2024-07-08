resource "aws_instance" "My_server1" {
  ami             = "ami-0195204d5dce06d99"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.pub1.id
  security_groups = [aws_security_group.sg-project.id]
  #vpc_security_group_ids = [aws_security_group.sg-project.id]
  key_name  = aws_key_pair.aws_key.key_name
  user_data = file("bash.sh")
  tags = {
    Name = "project-app"
  }
}
