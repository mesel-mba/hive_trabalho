#! /bin/bash

# Cria estrutura de dados e realiza o load dos arquivos

docker compose exec -it namenode bash -c "hdfs dfs -mkdir /app"
docker compose exec -it namenode bash -c "hdfs dfs -mkdir /app/data"
docker compose exec -it namenode bash -c "hdfs dfs -put /data/* /app/data/"

# Roda criação de scripts de criação de tabela

