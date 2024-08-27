#!/bin/bash
echo "Iniciando Deploy..."
result=${PWD##*/}
echo "Montando Imagem do container $result"
docker build --target staging -t $result .
echo "Removendo container antigos de $result"
docker container stop $result
docker container rm -f $result
echo "Iniciando container $result"
docker run -d -p 8225:80 -v ".:/app" --restart always --name $result $result
