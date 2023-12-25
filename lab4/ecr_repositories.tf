resource "aws_ecrpublic_repository" "rest_app" {
  provider        = aws.us_east_1
  repository_name = "rest-app"

  catalog_data {
    architectures = ["ARM 64",
    "x86", ]
    operating_systems = ["Linux"]
  }
}

resource "aws_ecrpublic_repository" "stresstest_app" {
  provider        = aws.us_east_1
  repository_name = "stresstest-app"

  catalog_data {
    operating_systems = ["Linux"]
  }
}