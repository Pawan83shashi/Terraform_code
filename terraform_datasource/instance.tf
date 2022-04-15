data "aws_availability_zones" "available" {}
data "aws_ami" "latest-ami" {
  most_recent = true
  owner = ["amazon"]
  filter {
    name = "name"
    values = "amzn2-ami-hvm-2*"
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

# Create Fronted Server
resource "aws_instance" "Frontend" {
    ami = data.aws_ami.latest-ami.id
    instance_type="t2.micro"
    availability_zone = data.aws_availability_zones.available.names[1]


  tags = {
    Name = "Frontend_Server"
    Project = "BMT"
    Environment = "DEV"
  }

 
}
