#!/bin/sh

sudo docker rm x2go
sudo docker run -it -d -p 2222:22 --name=x2go zhouyibhic/x2go-pycharm:latest
sleep 3
sudo docker logs x2go
