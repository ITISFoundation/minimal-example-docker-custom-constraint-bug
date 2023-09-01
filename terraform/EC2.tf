
resource "aws_instance" "dev-manager1" {
  ami                                  = "ami-0261755bbcb8c4a84"
  associate_public_ip_address          = true
  availability_zone                    = "us-east-1f"
  disable_api_stop                     = false
  disable_api_termination              = true
  ebs_optimized                        = true
  get_password_data                    = false
  hibernation                          = false
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "m7a.medium"
  ipv6_addresses                       = []
  key_name                             = aws_key_pair.testing.key_name
  monitoring                           = false
  placement_partition_number           = 0
  private_ip                           = "10.0.1.125"
  secondary_private_ips                = []
  security_groups                      = []
  source_dest_check                    = true
  subnet_id                            = aws_subnet.dev-subnet1.id
  tags = {
    "Name" = "dev-manager"
  }
  tags_all = {
    "Name" = "dev-manager"
  }
  tenancy = "default"
  vpc_security_group_ids = [
    aws_security_group.dev.id,
  ]

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  ebs_block_device {
    delete_on_termination = true
    device_name           = "/dev/sdb"
    encrypted             = false
    iops                  = 0
    throughput            = 0
    volume_size           = 1000
    volume_type           = "st1"
  }

  enclave_options {
    enabled = false
  }

  maintenance_options {
    auto_recovery = "default"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "optional"
  }

  private_dns_name_options {}
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    tags                  = {}
    volume_size           = 50
    volume_type           = "gp2"
  }
}


resource "aws_instance" "dev-nogpu" {
  ami                                  = "ami-0261755bbcb8c4a84"
  instance_type                        = "m7a.medium"
  associate_public_ip_address          = true
  availability_zone                    = "us-east-1f"
  disable_api_stop                     = false
  disable_api_termination              = true
  ebs_optimized                        = true
  get_password_data                    = false
  hibernation                          = false
  instance_initiated_shutdown_behavior = "stop"
  ipv6_addresses                       = []
  key_name                             = aws_key_pair.testing.key_name
  monitoring                           = false
  placement_partition_number           = 0
  private_ip                           = "10.0.1.89"
  secondary_private_ips                = []
  security_groups                      = []
  source_dest_check                    = true
  subnet_id                            = aws_subnet.dev-subnet1.id
  tags = {
    "Name" = "dev-nogpu"
  }
  tags_all = {
    "Name" = "dev-nogpu"
  }
  tenancy                     = "default"
  user_data_replace_on_change = false
  vpc_security_group_ids = [
    aws_security_group.dev.id,
  ]

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  ebs_block_device {
    delete_on_termination = true
    device_name           = "/dev/sdb"
    encrypted             = false
    iops                  = 0
    throughput            = 0
    volume_size           = 1000
    volume_type           = "st1"
  }

  enclave_options {
    enabled = false
  }

  maintenance_options {
    auto_recovery = "default"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "optional"
  }

  private_dns_name_options {}

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    tags                  = {}
    volume_size           = 50
    volume_type           = "gp2"
  }
  connection {
    type = "ssh"
    user = "ubuntu"
    # Mention the exact private key name which will be generated
    private_key = file("key.pem")
    timeout     = "4m"
  }


}


resource "aws_instance" "dev-gpu" {
  ami                                  = "ami-0261755bbcb8c4a84"
  instance_type                        = "g4dn.2xlarge"
  associate_public_ip_address          = true
  availability_zone                    = "us-east-1a"
  disable_api_stop                     = false
  disable_api_termination              = false
  ebs_optimized                        = true
  get_password_data                    = false
  hibernation                          = false
  instance_initiated_shutdown_behavior = "stop"
  ipv6_addresses                       = []
  key_name                             = aws_key_pair.testing.key_name
  monitoring                           = false
  placement_partition_number           = 0
  private_ip                           = "10.0.3.132"
  secondary_private_ips                = []
  security_groups                      = []
  source_dest_check                    = true
  subnet_id                            = aws_subnet.dev-subnet2.id
  tags = {
    "Name" = "dev-GPU"
  }
  tags_all = {
    "Name" = "dev-GPU"
  }
  tenancy                     = "default"
  user_data_replace_on_change = false
  vpc_security_group_ids = [
    aws_security_group.dev.id,
  ]

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  cpu_options {
    core_count       = 4
    threads_per_core = 2
  }

  ebs_block_device {
    delete_on_termination = true
    device_name           = "/dev/sdb"
    encrypted             = false
    iops                  = 0
    throughput            = 0
    volume_size           = 1000
    volume_type           = "st1"
  }

  enclave_options {
    enabled = false
  }

  maintenance_options {
    auto_recovery = "default"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "optional"
    instance_metadata_tags      = "disabled"
  }

  private_dns_name_options {}

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = 100
    volume_type           = "gp2"
  }
}
