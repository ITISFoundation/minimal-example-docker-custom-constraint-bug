resource "aws_eip" "dev-manager1-ip" {
  vpc = true
  tags = {
    Name = "dev-manager1-ip"

  }
}

resource "aws_eip_association" "dev-manager1" {
  instance_id   = aws_instance.dev-manager1.id
  allocation_id = aws_eip.dev-manager1-ip.id
}

resource "aws_eip" "dev-nogpu-ip" {
  vpc = true
  tags = {
    Name = "dev-nogpu-ip"

  }
}

resource "aws_eip_association" "dev-nogpu" {
  instance_id   = aws_instance.dev-nogpu.id
  allocation_id = aws_eip.dev-nogpu-ip.id
}


resource "aws_eip" "dev-gpu-ip" {
  instance = aws_instance.dev-gpu.id
  tags = {
    Name = "dev-gpu-ip"
  }
}
