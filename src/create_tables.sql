CREATE DATABASE IF NOT EXISTS AdventureWorks;

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
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ';' STORED AS TEXTFILE LOCATION '/app/data/address/'
TBLPROPERTIES ("skip.header.line.count"="1");

CREATE EXTERNAL TABLE IF NOT EXISTS customer
(
    CustomerID string,
    Title string,
    Suffix string,
    CompanyName string,
    SalesPerson string,
    EmailAddress string,
    PasswordHash string,
    PasswordSalt string,
    rowguid string,
    ModifiedDate string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ';' STORED AS TEXTFILE LOCATION '/app/data/customer/'
TBLPROPERTIES ("skip.header.line.count"="1");

CREATE EXTERNAL TABLE IF NOT EXISTS customer_address
(
    CustomerID string,
    AddressID string,
    rowguid string,
    ModifiedDate string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ';' STORED AS TEXTFILE LOCATION '/app/data/customer_address/'
TBLPROPERTIES ("skip.header.line.count"="1");

CREATE EXTERNAL TABLE IF NOT EXISTS product
(
    ProductID string,
    ProductNumber string,
    Color string,
    StandardCost string,
    ListPrice string,
    Size string,
    Weight string,
    ProductCategoryID string,
    ProductModelID string,
    SellStartDate string,
    SellEndDate string,
    DiscontinuedDate string,
    ThumbNailPhoto string,
    ThumbnailPhotoFileName string,
    rowguid string,
    ModifiedDate string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ';' STORED AS TEXTFILE LOCATION '/app/data/product/'
TBLPROPERTIES ("skip.header.line.count"="1");

CREATE EXTERNAL TABLE IF NOT EXISTS product_category
(
    ProductCategoryID string,
    ParentProductCategoryID string,
    rowguid string,
    ModifiedDate string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ';' STORED AS TEXTFILE LOCATION '/app/data/product_category/'
TBLPROPERTIES ("skip.header.line.count"="1");

CREATE EXTERNAL TABLE IF NOT EXISTS product_description
(
    ProductDescriptionID string,
    Description string,
    rowguid string,
    ModifiedDate string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ';' STORED AS TEXTFILE LOCATION '/app/data/product_description/'
TBLPROPERTIES ("skip.header.line.count"="1");

CREATE EXTERNAL TABLE IF NOT EXISTS product_model
(
    ProductModelID string,
    CatalogDescription string,
    rowguid string,
    ModifiedDate string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ';' STORED AS TEXTFILE LOCATION '/app/data/product_model/'
TBLPROPERTIES ("skip.header.line.count"="1");

CREATE EXTERNAL TABLE IF NOT EXISTS product_model_description
(
    ProductModelID string,
    ProductDescriptionID string,
    Culture string,
    rowguid string,
    ModifiedDate string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ';' STORED AS TEXTFILE LOCATION '/app/data/product_model_description/'
TBLPROPERTIES ("skip.header.line.count"="1");


CREATE EXTERNAL TABLE IF NOT EXISTS sales_order_detail
(
    SalesOrderID string,
    SalesOrderDetailID string,
    OrderQty string,
    ProductID string,
    UnitPrice string,
    UnitPriceDiscount string,
    LineTotal string,
    rowguid string,
    ModifiedDate string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ';' STORED AS TEXTFILE LOCATION '/app/data/sales_order_detail/'
TBLPROPERTIES ("skip.header.line.count"="1");


CREATE EXTERNAL TABLE IF NOT EXISTS sales_order_head
(
    SalesOrderID string,
    RevisionNumber string,
    OrderDate string,
    DueDate string,
    ShipDate string,
    Status string,
    SalesOrderNumber string,
    CustomerID string,
    ShipToAddressID string,
    BillToAddressID string,
    ShipMethod string,
    CreditCardApprovalCode string,
    SubTotal string,
    TaxAmt string,
    Freight string,
    TotalDue string,
    Comment string,
    rowguid string,
    ModifiedDate string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ';' STORED AS TEXTFILE LOCATION '/app/data/sales_order_head/'
TBLPROPERTIES ("skip.header.line.count"="1");

-- PARTITIONED TABLE
insert into table product_sales PARTITION (orderdate="01-06-2008")
SELECT
    p.productcategoryid,
    sod.orderqty,
--    soh.orderdate,
    c.salesperson,
    c.companyname,
    a.addressline1,
    a.city
FROM
    product p
JOIN sales_order_detail sod 
ON
    sod.productid = p.productid
JOIN sales_order_head soh 
ON
    soh.salesorderid = sod.salesorderid
JOIN customer c 
ON
    soh.customerid = c.customerid
JOIN customer_address ca 
ON
    c.customerid = ca.customerid
JOIN address a 
ON
    ca.addressid = a.addressid
ORDER BY city;