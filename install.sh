#!/bin/bash

if curl -O https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel70-4.2.1.tgz && tar -xzvf mongodb-linux-x86_64-rhel70-4.2.1.tgz ~/
then
    echo "Get mongodb successefully."
    echo "export PATH=\$PATH:~/mongodb-linux-x86_64-rhel70-4.2.1.tgz/bin" >> /etc/profile
    source /etc/profile
    mkdir ~/note-data
else
    echo "Get mongodb faild."
    exit 1
fi

if curl -O https://raw.githubusercontent.com/nieaowei/anychat-note/master/mongodb_backup.tar && tar -xf mongodb_backup.tar ~/
then
    echo "Get backup successefully."
else
    echo "Get backup faild."
    exit 2
fi

if mongod --dbpath ~/note-data
then
    echo "The mongodb started successfully."
else
    echo "The mongodb start faild."
    exit 3
fi

if mongorestore -h localhost -d leanote --dir ~/mongodb_backup/leanote_install_data/
then
    echo "The data restored successfully."
else
    echo "The data restored faild."
    exit 4
fi

res=""
echo "The script is running."
echo "The docker installer is running."
if res=`docker --version | grep "Docker"`
then
	echo "The Docker is installed."
	echo "Your Docker vesion is $res"
elif	curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
then
	echo "The Docker install is sucessed."
else
	echo "The Docker install is faild."
	exit 1
fi

if systemctl status docker | grep "running"
then
	echo "The Docker is running."
elif systemctl start docker
then
	echo "The Docker is started."
else
	echo "The Docker start is faild."
	exit 2
fi

if systemctl enable docker
then
	echo "The Docker autonal starting is set."
else
	echo "The Docker autonal start seting is faild."	
fi

if docker pull nieaowei/anychat-note
then
	echo "The image is pull."
else
	echo "The image pulling is faild.Your network is probrably faild."
	exit 3
fi

if docker run -d -p 9000:9000 nieaowei/anychat-note
then
    echo "The container is running."
else
    echo "THe container running is faild."
    exit 4
fi