# cretate vpc

resource "aws_vpc" "my-vpc1" {
  cidr_block       = "172.120.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "project-app"
    Team = "pro"
    env  = "dev"
  }
}

# Internet gateway

resource "aws_internet_gateway" "gtway1" {
  vpc_id = aws_vpc.my-vpc1.id
}

# public subnet 1

resource "aws_subnet" "pub1" {
  availability_zone       = "us-east-1a"
  cidr_block              = "172.120.1.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.my-vpc1.id
  tags = {
    Name = "project-public-subnet-1a"
  }

}
# public subnet 2

resource "aws_subnet" "pub2" {
  availability_zone       = "us-east-1b"
  cidr_block              = "172.120.2.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.my-vpc1.id
  tags = {
    Name = "project-public-subnet-1b"
  }
}

#private subnet 1

resource "aws_subnet" "priv1" {
  availability_zone = "us-east-1a"
  cidr_block        = "172.120.3.0/24"
  vpc_id            = aws_vpc.my-vpc1.id
  tags = {
    Name = "project-private-subnet-1a"
  }
}
# private subnet 2

resource "aws_subnet" "priv2" {
  availability_zone = "us-east-1b"
  cidr_block        = "172.120.4.0/24"
  vpc_id            = aws_vpc.my-vpc1.id
  tags = {
    Name = "project-private-subnet-1b"
  }
}
#Nat Gateway

resource "aws_eip" "ngate" {
}
resource "aws_nat_gateway" "nway1" {
  allocation_id = aws_eip.ngate.id
  subnet_id     = aws_subnet.pub1.id
}
# Public route table 1

resource "aws_route_table" "rtpub1" {
  vpc_id = aws_vpc.my-vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gtway1.id
  }
}
# private route table 2

resource "aws_route_table" "rtpriv2" {
  vpc_id = aws_vpc.my-vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nway1.id
  }
}

# route and public subnet association

resource "aws_route_table_association" "rtab1" {
  subnet_id      = aws_subnet.pub1.id
  route_table_id = aws_route_table.rtpub1.id
}
resource "aws_route_table_association" "rtab2" {
  subnet_id      = aws_subnet.pub2.id
  route_table_id = aws_route_table.rtpub1.id
}
# route and private subnet association

resource "aws_route_table_association" "rtab3" {
  subnet_id      = aws_subnet.priv1.id
  route_table_id = aws_route_table.rtpriv2.id
}
resource "aws_route_table_association" "rtab4" {
  subnet_id      = aws_subnet.priv2.id
  route_table_id = aws_route_table.rtpriv2.id
}
