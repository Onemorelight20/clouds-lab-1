#!/usr/bin/env bash
cd /home/ec2-user/server
export SPRING_DATASOURCE_URL=$(aws ssm get-parameter --name "/db/SPRING_DATASOURCE_URL" --query "Parameter.Value" --output text)
export SPRING_DATASOURCE_USERNAME=$(aws ssm get-parameter --name "/db/SPRING_DATASOURCE_USERNAME" --query "Parameter.Value" --output text)
export SPRING_DATASOURCE_PASSWORD=$(aws ssm get-parameter --name "/db/SPRING_DATASOURCE_PASSWORD" --query "Parameter.Value" --output text)
sudo -E java -jar *.jar > /dev/null 2> /dev/null < /dev/null &