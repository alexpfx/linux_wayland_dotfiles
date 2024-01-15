#!/bin/bash

gtw=$(cat /data/params/portal)
user=$(cat /data/params/user)
group=$(cat /data/params/group)
crt=$(cat /data/params/crt)
server_crt=$(cat /data/params/server_crt)

echo -v "sudo openconnect --no-dtls --authgroup=$group --protocol=gp -u $user -c $crt -v $gtw"

# Armazena o tempo inicial
start_time=$SECONDS

# Função para calcular e exibir o tempo decorrido
show_elapsed_time() {
  while true; do
    elapsed_time=$((SECONDS - start_time))
    echo "Tempo decorrido: $elapsed_time segundos\n"
    sleep 30
  done
}

show_elapsed_time &

sudo openconnect --no-dtls --authgroup=$group --protocol=gp -u $user -c $crt -v $gtw


kill $!
