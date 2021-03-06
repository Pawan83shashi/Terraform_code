module "backup-rds" {
  source = "../AWS_RDS"
  AWS_SECRET_KEY = var.AWS_SECRET_KEY
}

# Get latest snapshot from  levelup-mariadb  DB
data "aws_db_snapshot" "db_snapshot" {
    most_recent = true
    db_instance_identifier = "mariadb"
}

#RDS Instance properties
resource "aws_db_instance" "levelup-mariadb-backup" {
  instance_class          = "db.t2.micro"
  identifier              = "mariadb-backup"
  username                = "root"           # username
  password                = "mariadb141"     # password
  snapshot_identifier     = "${data.aws_db_snapshot.db_snapshot.id}"
  multi_az                = "false"            # set to true to have high availability: 2 instances synchronized with each other
  storage_type            = "gp2"
  backup_retention_period = 30                                         # how long you’re going to keep your backups
  availability_zone       = "us-east-1a" # prefered AZ
  skip_final_snapshot     = true                                     # skip final snapshot when doing terraform destroy
 
  
  tags = {
    Name = "levelup-mariadb-backup"
  }
}

output "rds" {
  value = aws_db_instance.levelup-mariadb-backup.endpoint
}