#! /bin/bash

# Cria estrutura de dados e realiza o load dos arquivos

hdfs dfs -mkdir /app
hdfs dfs -mkdir /app/data
hdfs dfs -put /data/* /app/data/

# Roda criação de scripts de criação de tabela

