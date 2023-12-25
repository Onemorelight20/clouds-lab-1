resource "aws_ssm_parameter" "db_url" {
  name  = "/db/SPRING_DATASOURCE_URL"
  type  = "String"
  value = "jdbc:mysql://${aws_db_instance.lab4_db.address}/bohdan_boretskyi_smartcap?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true"
  overwrite = true
}

resource "aws_ssm_parameter" "db_password" {
  name      = "/db/SPRING_DATASOURCE_PASSWORD"
  type      = "String"
  value     = var.db_password
  overwrite = true
}

resource "aws_ssm_parameter" "db_username" {
  name      = "/db/SPRING_DATASOURCE_USERNAME"
  type      = "String"
  value     = var.db_username
  overwrite = true
}

data "aws_ssm_parameter" "stress_user_email" {
  name = "/stress/USER_EMAIL"
}

data "aws_ssm_parameter" "stress_user_password" {
  name = "/stress/USER_PASSWORD"
}