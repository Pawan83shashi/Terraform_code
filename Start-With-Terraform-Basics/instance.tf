# Create AWS Key Pair
resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

# Create Fronted Server
resource "aws_instance" "Frontend" {
    ami = lookup(var.AMIS, var.AWS_REGION)
    instance_type="t2.micro"
    key_name = aws_key_pair.levelup_key.key_name


  tags = {
    Name = "Frontend_Server"
    Project = "BMT"
    Environment = "TEST"
  }

  provisioner "file" {
      source = "installNginx.sh"
      destination = "/tmp/installNginx.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/installNginx.sh",
      "sudo sed -i -e 's/\r$//' /tmp/installNginx.sh",  # Remove the spurious CR characters.
      "sudo /tmp/installNginx.sh",
    ]
  }

  provisioner "local-exec" {
    command = "echo the server's IP address is ${self.private_ip}"
  }

 connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }
}