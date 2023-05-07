# Projeto Hive - MBA FIAP Data Engineering

## Autores

Daniel Udala - RM348932

Sara Luize - RM348391

Giancarlo Lester - RM348315

Vinicius Mesel - RM348353

## Ambiente 

O ambiente utilizado para este projeto pode ser encontrado no seguinte link: https://github.com/profleandrom/hadoop_eco_docker/


## Bases de Dados 

As bases de dados são de domínio da Adventure Works, e estão presentes na pasta **data_files** deste repositório.

## Desenvolvimento 

Os tópicos a seguir irão indicar as etapas do processo desenvolvido: 

**Extração**: a extração dos arquivos a partir do [repositório disponibilizado](https://drive.google.com/drive/folders/1OfZTSYcgcun-S7UFNVAzbcr0-PzlEc08) foi feita de maneira manual e a seguir criado o script **load_files.sh** em que carrega os arquivos para dentro do HDFS.

**Load e transform**: Ambas as etapas foram realizadas dentro dos arquivos da pasta `/src/`, com maior destaque abaixo.

## Arquivos de dentro da pasta src:

 - **load_files.sh**: determina a estruturação dos arquivos que foram extraídos e o carregamento dos mesmos ao diretório para que em seguida, seja realizado a ação de criar as tabelas do banco de dados.

 - **create_tables.sql**: o arquivo cria o banco de dados chamado `AdventureWorks` e seguindo sua utilização, faz a criação também das tabelas externas de acordo com sua pasta `/app/data/nome_tabela/`.

## Flattened Table (Tabela product_sales)

O script **create_tables.sql** mantém também a Flattened table, onde a técnica escolhida foi por Partition, devido a sua melhor performance ao distribuir os dados no cluster.

A coluna selecionada para a partição é `orderdate`. Tais ações foram escolhidas visando uma melhor análise dos dados e estudo dos clientes por data.

Como uma forma de otimizarmos custo computacional, vamos utilizar a mesma flattened table, que agrega vendas por cliente e produto, para a geração de KPIs sobre vendas e desempenho da empresa (EBIT, EBITDA, P&L, GMV e etc).