#!/bin/bash

gtw=$(cat /data/params/portal)
user=$(cat /data/params/user)
group=$(cat /data/params/group)
crt=$(cat /data/params/crt)
server_crt=$(cat /data/params/server_crt)

echo "sudo openconnect --no-dtls --authgroup=$group --protocol=gp -u $user -c $crt -v $gtw"
sudo openconnect --no-dtls --authgroup=$group --protocol=gp -u $user -c $crt -v $gtw
