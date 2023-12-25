#!/usr/bin/env bash
chmod +x /home/ec2-user/server/*.jar
chmod +x /home/ec2-user/server/server_start.sh
chmod +x /home/ec2-user/server/server_stop.sh

sudo su
export SPRING_DATASOURCE_URL=$(aws ssm get-parameter --name "/db/SPRING_DATASOURCE_URL" --query "Parameter.Value" --output text)
export SPRING_DATASOURCE_USERNAME=$(aws ssm get-parameter --name "/db/SPRING_DATASOURCE_USERNAME" --query "Parameter.Value" --output text)
export SPRING_DATASOURCE_PASSWORD=$(aws ssm get-parameter --name "/db/SPRING_DATASOURCE_PASSWORD" --query "Parameter.Value" --output text)