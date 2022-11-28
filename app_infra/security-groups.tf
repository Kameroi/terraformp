resource "aws_security_group" "eks_security_group" {
  name        = "eks cluster security group"
  description = "Allowing traffic"
  vpc_id      = module.vpc.vpc_id

  # This cluster will run in a private subnet of a VPC 
  # so we are not actaully opening this to the world
  # Despite this I would suggest restricting the security 
  # group but for these purposes we will use this open group.
  ingress {
    description      = "Ingress all"
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description      = "Egress all"
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
  }
}


module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "db_sec_group"
  description = "Complete MySQL example security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]
}