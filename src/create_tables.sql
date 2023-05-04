CREATE DATABASE AdventureWorks;

USE AdventureWorks;

CREATE EXTERNAL TABLE IF NOT EXISTS address
(
    AddressID string,
    AddressLine1 string,
    AddressLine2 string,
    City string,
    PostalCode string,
    rowguid string,
    ModifiedDate string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ';' STORED AS TEXTFILE LOCATION '/app/address';

LOAD DATA INPATH '/app/data/address.csv' OVERWRITE INTO TABLE address;