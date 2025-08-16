region     = "eu-central-1"
project    = "selena"
env = "dev"

ami_id = "ami-00c8ac9147e19828e"  # AMI ID для EC2 instance
instance_type  = "t3.micro"
subnet_id      = "subnet-0b8db83bda509afbb"
vpc_id         = "vpc-030a96bd31fb160d2"
key_name       = "selena-aws-key"

availability_zone     = "eu-central-1a"
availability_zone_2   = "eu-central-1b"

vpc_cidr               = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
private_subnet_cidr       = "10.0.2.0/24"
private_subnet_cidr_2     = "10.0.3.0/24"

ec2_instance_id = "i-0b439c1a22c563dbe"
alert_email     = "vitaly2822@gmail.com"
