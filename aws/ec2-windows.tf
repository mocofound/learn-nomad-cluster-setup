#Golden for both services commented out
#  sc.exe stop "Nomad"
# sc.exe stop "Consul"
# start-sleep -Seconds 2
# sc.exe delete "Nomad"
# sc.exe delete "Consul"

# $FolderName = "C:\nomad\"
# if (Test-Path $FolderName) {
# }
# else
# {
#     New-Item $FolderName -ItemType Directory
#     New-Item "$FolderName\data" -ItemType Directory
#     New-Item "$FolderName\plugin" -ItemType Directory
#     New-Item "$FolderName\logs" -ItemType Directory
# }
# #Invoke-WebRequest -Uri "https://releases.hashicorp.com/nomad/1.4.3+ent/nomad_1.4.3+ent_windows_amd64.zip" -OutFile "$FolderName\nomad.zip" 
# Invoke-WebRequest -Uri "https://releases.hashicorp.com/nomad/1.4.3/nomad_1.4.3_windows_amd64.zip" -OutFile "$FolderName\nomad.zip" 

# Expand-Archive "$FolderName\nomad.zip" -DestinationPath "$FolderName\" -Force
# $ConfigPath = "$FolderName\nomad_windows_client_config.hcl"
# $ConfigPath2 = "$FolderName\nomad_windows_client_config2.hcl"
# $formatText = @"
# # Increase log verbosity
# log_level = "DEBUG"
# log_file = "C:\\nomad\\logs\\nomad.log"
# data_dir  = "C:\\nomad\\data"
# plugin_dir = "C:\\nomad\\plugin"
# plugin "win_iis" {
#   config {
#     enabled = true
#     stats_interval = "5s"
#   }
# }
# bind_addr = "0.0.0.0"
# datacenter = "dc1"

# # Enable the client
# client {
#   enabled = true
#   options {
#     "driver.raw_exec.enable"    = "1"
#     "docker.privileged.enabled" = "true"
#   }
# }

# acl {
#   enabled = true
# }

# consul {
#   address = "127.0.0.1:8500"
#   #token = "CONSUL_TOKEN"
#   token = "5679b6b0-9e81-11ed-a8fc-0242ac120002"
# }

# vault {
#   enabled = true
#   address = "http://active.vault.service.consul:8200"
# }
# "@ > $ConfigPath
# Get-Content $ConfigPath | out-file -encoding ASCII $ConfigPath2
# sc.exe create "Nomad" binPath="$FolderName\nomad.exe agent -config=$ConfigPath2" start= auto
# sc.exe start "Nomad"

# $ConsulFolderName = "C:\consul\"
# if (Test-Path $ConsulFolderName) {
# }
# else
# {
#     New-Item $ConsulFolderName -ItemType Directory
#     New-Item "$ConsulFolderName\data" -ItemType Directory
# }


# #Invoke-WebRequest -Uri "https://releases.hashicorp.com/nomad/1.4.3+ent/nomad_1.4.3+ent_windows_amd64.zip" -OutFile "$FolderName\nomad.zip" 
# Invoke-WebRequest -Uri "https://releases.hashicorp.com/consul/1.14.4/consul_1.14.4_windows_amd64.zip" -OutFile "$ConsulFolderName\consul.zip"
# Expand-Archive "$ConsulFolderName\consul.zip" -DestinationPath "$ConsulFolderName\" -Force
# $ConsulConfigPath = "$ConsulFolderName\consul_windows_client_config.hcl"
# $ConsulConfigPath2 = "$ConsulFolderName\consul_windows_client_config2.hcl"
# #Powershell Here-string  $(Get-Date) ${myDate}
# #advertise_addr = $(Get-NetIPAddress | Where-Object -FilterScript { $_.PrefixOrigin -eq "Dhcp"  })
# $formatText = @"
# ui = true
# log_level = "INFO"
# data_dir = "C:\\consul\\data"
# bind_addr = "0.0.0.0"
# client_addr = "0.0.0.0"
# #advertise_addr = "IP_ADDRESS"
# #retry_join = ["RETRY_JOIN"]
# advertise_addr = "172.31.24.70"
# retry_join = ["provider=aws tag_key=ConsulAutoJoin tag_value=auto-join"]
# #retry_join = ["172.31.53.33"]

# acl {
#     enabled = true
#     default_policy = "deny"
#     down_policy = "extend-cache"
#     tokens {
#        agent  = "5679b6b0-9e81-11ed-a8fc-0242ac120002"
#   }
# }

# connect {
#   enabled = true
# }
# ports {
#   grpc = 8502
# }

# "@ > $ConsulConfigPath
# Get-Content $ConsulConfigPath | out-file -encoding ASCII $ConsulConfigPath2
# sc.exe create "Consul" binPath="$ConsulFolderName\consul.exe agent -config-file=$ConsulConfigPath2" start= auto
# #C:\consul\consul.exe C:\consul\consul_windows_client_config2.hcl
# sc.exe start "Consul" 


# Get latest Windows Server 2019 AMI
data "aws_ami" "windows-2019" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base*"]
  }
}

variable "windows_instance_type" {
  type        = string
  description = "EC2 instance type for Windows Server"
  default     = "t2.small"
}
variable "windows_associate_public_ip_address" {
  type        = bool
  description = "Associate a public IP address to the EC2 instance"
  default     = true
}
variable "windows_root_volume_size" {
  type        = number
  description = "Volume size of root volumen of Windows Server"
  default     = 30
}
variable "windows_data_volume_size" {
  type        = number
  description = "Volume size of data volumen of Windows Server"
  default     = 10
}
variable "windows_root_volume_type" {
  type        = string
  description = "Volume type of root volumen of Windows Server."
  default     = "gp2"
}
variable "windows_data_volume_type" {
  type        = string
  description = "Volume type of data volumen of Windows Server."
  default     = "gp2"
}
variable "windows_instance_name" {
  type        = string
  description = "EC2 instance name for Windows Server"
  default     = "tfwinsrv01"
}
variable "prefix" {
  type        = string
  description = "PREFIX"
  default     = "nomad-win"
}


# # Bootstrapping PowerShell Script
# data "template_file" "windows-userdata" {
#   template = <<EOF
# <powershell>
# # Rename Machine
# #Rename-Computer -NewName "${var.windows_instance_name}" -Force;
# # Install IIS
# Install-WindowsFeature -name Web-Server -IncludeManagementTools;
# # Restart machine
# shutdown -r -t 10;
# </powershell>
# EOF
# }


# Create EC2 Instance
resource "aws_instance" "windows-server-rdp-client" {
  get_password_data = true
  ami = data.aws_ami.windows-2019.id
  instance_type = var.windows_instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  #subnet_id                   = aws_subnet.boundary_poc.id
  vpc_security_group_ids      = [aws_security_group.rdp_ingress.id, aws_security_group.allow_all_internal.id]
  source_dest_check = false
  #user_data = data.template_file.windows-userdata.rendered 
  user_data = <<EOF
<powershell>
# Rename Machine
#Rename-Computer -NewName "${var.windows_instance_name}" -Force;
# Install IIS
Install-WindowsFeature -name Web-Server -IncludeManagementTools;
# Restart machine
shutdown -r -t 10;

#  .\consul.exe agent -config-file=C:\consul\consul_windows_client_config2.hcl 
#  .\nomad.exe agent -config=C:\nomad\nomad_windows_client_config2.hcl 

   sc.exe delete "Nomad"
sc.exe delete "Consul"
$FolderName = "C:\nomad\"
if (Test-Path $FolderName) {
}
else
{
    New-Item $FolderName -ItemType Directory
    New-Item "$FolderName\data" -ItemType Directory
}
#Invoke-WebRequest -Uri "https://releases.hashicorp.com/nomad/1.4.3+ent/nomad_1.4.3+ent_windows_amd64.zip" -OutFile "$FolderName\nomad.zip" 
Invoke-WebRequest -Uri "https://releases.hashicorp.com/nomad/1.4.3/nomad_1.4.3_windows_amd64.zip" -OutFile "$FolderName\nomad.zip" 

Expand-Archive "$FolderName\nomad.zip" -DestinationPath "$FolderName\" -Force
$ConfigPath = "$FolderName\nomad_windows_client_config.hcl"
$ConfigPath2 = "$FolderName\nomad_windows_client_config2.hcl"
$formatText = @'
data_dir  = "C:\\nomad\\data"
bind_addr = "0.0.0.0"
datacenter = "dc1"

# Enable the client
client {
  enabled = true
  options {
    "driver.raw_exec.enable"    = "1"
    "docker.privileged.enabled" = "true"
  }
}

acl {
  enabled = true
}

consul {
  address = "127.0.0.1:8500"
  #token = "CONSUL_TOKEN"
  token = "5679b6b0-9e81-11ed-a8fc-0242ac120002"
}

vault {
  enabled = true
  address = "http://active.vault.service.consul:8200"
}
'@ > $ConfigPath
Get-Content $ConfigPath | out-file -encoding ASCII $ConfigPath2
sc.exe create "Nomad" binPath="nomad agent -config=$ConfigPath2" start= auto
sc.exe start "Nomad"

$ConsulFolderName = "C:\consul\"
if (Test-Path $ConsulFolderName) {
}
else
{
    New-Item $ConsulFolderName -ItemType Directory
    New-Item "$ConsulFolderName\data" -ItemType Directory
}


#Invoke-WebRequest -Uri "https://releases.hashicorp.com/nomad/1.4.3+ent/nomad_1.4.3+ent_windows_amd64.zip" -OutFile "$FolderName\nomad.zip" 
Invoke-WebRequest -Uri "https://releases.hashicorp.com/consul/1.14.4/consul_1.14.4_windows_amd64.zip" -OutFile "$ConsulFolderName\consul.zip"
Expand-Archive "$ConsulFolderName\consul.zip" -DestinationPath "$ConsulFolderName\" -Force
$ConsulConfigPath = "$ConsulFolderName\consul_windows_client_config.hcl"
$ConsulConfigPath2 = "$ConsulFolderName\consul_windows_client_config2.hcl"
$formatText = @'
ui = true
log_level = "INFO"
data_dir = "C:\\consul\\data"
bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"
#advertise_addr = "IP_ADDRESS"
#retry_join = ["RETRY_JOIN"]
advertise_addr = "172.31.24.70"
#retry_join = ["provider=aws tag_key=ConsulAutoJoin tag_value=auto-join"]
retry_join = ["172.31.59.221"]

acl {
    enabled = true
    default_policy = "deny"
    down_policy = "extend-cache"
    tokens {
       agent  = "5679b6b0-9e81-11ed-a8fc-0242ac120002"
  }
}

connect {
  enabled = true
}
ports {
  grpc = 8502
}

'@ > $ConsulConfigPath
Get-Content $ConsulConfigPath | out-file -encoding ASCII $ConsulConfigPath2
sc.exe create "Consul" binPath="$ConsulFolderName\consul.exe agent -config=$ConsulConfigPath2" start= auto
sc.exe start "Consul" 

 

 

</powershell>
EOF

  # root disk
  root_block_device {
    volume_size           = var.windows_root_volume_size
    volume_type           = var.windows_root_volume_type
    delete_on_termination = true
    encrypted             = true
  }
  # extra disk
  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = var.windows_data_volume_size
    volume_type           = var.windows_data_volume_type
    encrypted             = true
    delete_on_termination = true
  }

    tags = {
    Name = "${var.prefix}-windows-server-rdp-client"
  }
iam_instance_profile = aws_iam_instance_profile.instance_profile.name
}

# Create Elastic IP for the EC2 instance
resource "aws_eip" "windows-eip-2" {
  vpc  = true
  tags = {
    Name = "windows-eip-2"
  }

}
# Associate Elastic IP to Windows Server
resource "aws_eip_association" "windows-eip-association-2" {
  instance_id   = aws_instance.windows-server-rdp-client.id
  allocation_id = aws_eip.windows-eip-2.id
}

output "rdp_client_public_ip" {
  value = aws_instance.windows-server-rdp-client.public_dns
}