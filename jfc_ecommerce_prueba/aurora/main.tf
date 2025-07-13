# Provider AWS
provider "aws" {
  region = "us-east-1"
}

resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "${var.project_name}-aurora-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}-aurora-subnet-group"
  }
}


resource "aws_security_group" "aurora_sg" {
  name   = "${var.project_name}-aurora-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-aurora-sg"
  }
}

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = "${var.project_name}-aurora-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "8.0.mysql_aurora.3.05.2"  
  master_username         = var.master_username
  master_password         = var.master_password
  database_name           = var.database_name
  backup_retention_period = 7
  preferred_backup_window = "07:00-09:00"
  db_subnet_group_name    = aws_db_subnet_group.aurora_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.aurora_sg.id]
  availability_zones      = var.availability_zones
  skip_final_snapshot     = true

  tags = {
    Name = "${var.project_name}-aurora-cluster"
  }
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  count              = var.instance_count
  identifier         = "${var.project_name}-aurora-instance-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  instance_class     = var.instance_class
  engine             = "aurora-mysql"
  publicly_accessible = false

  tags = {
    Name = "${var.project_name}-aurora-instance-${count.index + 1}"
  }
}

resource "aws_iam_role" "rds_proxy_role" {
  name = "${var.project_name}-rds-proxy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "rds.amazonaws.com"
      }
    }]
  })
}


resource "aws_iam_role_policy_attachment" "rds_proxy_policy_attachment" {
  role       = aws_iam_role.rds_proxy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_db_proxy" "aurora_proxy" {
  name                   = "${var.project_name}-rds-proxy"
  engine_family          = "MYSQL"
  role_arn               = aws_iam_role.rds_proxy_role.arn
  vpc_security_group_ids = [aws_security_group.aurora_sg.id]
  vpc_subnet_ids         = var.private_subnet_ids

  auth {
    iam_auth   = "DISABLED"
    secret_arn = aws_secretsmanager_secret.db_credentials.arn
  }

  require_tls = true

  tags = {
    Name = "${var.project_name}-rds-proxy"
  }
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name = "${var.project_name}-db-credentials"

  tags = {
    Name = "${var.project_name}-db-credentials"
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials_value" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.master_username
    password = var.master_password
  })
}

# CloudWatch
resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name          = "High-DB-CPU-Utilization"
  alarm_description   = "Alarma si la CPU de la base de datos Aurora supera el 80%"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  statistic           = "Average"
  period              = 60
  threshold           = 80
  comparison_operator = "GreaterThanThreshold"
  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.aurora_cluster.id
  }
  evaluation_periods = 2
  alarm_actions      = [aws_sns_topic.alarms_topic.arn]
}


resource "aws_cloudwatch_metric_alarm" "high_proxy_connections" {
  alarm_name          = "High-Proxy-Connections"
  alarm_description   = "Alarma si las conexiones al RDS Proxy superan 1000"
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  statistic           = "Average"
  period              = 60
  threshold           = 1000
  comparison_operator = "GreaterThanThreshold"
  dimensions = {
    DBProxyName = aws_db_proxy.aurora_proxy.name
  }
  evaluation_periods = 2
  alarm_actions      = [aws_sns_topic.alarms_topic.arn]
}

resource "aws_sns_topic" "alarms_topic" {
  name = "${var.project_name}-alarms-topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alarms_topic.arn
  protocol  = "email"
  endpoint  = "joralhoy@hotmail.com" 
}


output "rds_proxy_endpoint" {
  description = "RDS Proxy endpoint"
  value       = aws_db_proxy.aurora_proxy.endpoint
}

