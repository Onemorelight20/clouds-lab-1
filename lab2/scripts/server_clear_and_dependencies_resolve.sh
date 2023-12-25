#!/usr/bin/env bash
sudo rm -rf /home/ec2-user/server
sudo dnf update

sudo dnf install java-17-amazon-corretto
sudo dnf install java-17-amazon-corretto-devel

sudo dnf install mariadb105

