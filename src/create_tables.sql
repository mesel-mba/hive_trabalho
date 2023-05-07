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

-- FLATTENED AND PARTITIONED TABLE WITH KPIS

CREATE TABLE product_sales (
    customerid string,
    title string,
    suffix string,
    companyname string,
    salesperson string,
    salesorderid string,
    orderqty string,
    unitprice string,
    unitpricediscount string,
    productid string,
    listprice string,
    productcategoryid string,
    productmodelid string,
    sellstartdate string,
    sellenddate string,
    a_city string,
    a_postalcode string,
    a2_city string,
    a2_postalcode string
) PARTITIONED BY(orderdate string)
ROW format delimited fields terminated BY ';'
location '/app/data/flattentable/';

insert into table product_sales PARTITION (orderdate="01-06-2008")
SELECT
    c.customerid as customerid,
    c.title as title,
    c.suffix as suffix,
    c.companyname as companyname,
    c.salesperson as salesperson,
    sod.salesorderid as salesorderid,
    sod.orderqty as orderqty,
    sod.unitprice as unitprice,
    sod.unitpricediscount as unitpricediscount,
    soh.orderdate as orderdate,
    p.productid as productid,
    p.listprice as listprice,
    p.productcategoryid as productcategoryid,
    p.productmodelid as productmodelid,
    p.sellstartdate as sellstartdate,
    p.sellenddate as sellenddate,
    a.city as a_city,
    a.postalcode as a_postalcode,
    a2.city as a2_city,
    a2.postalcode as a2_postalcode
    FROM sales_order_head soh
join customer c on c.customerid = soh.customerid
join sales_order_detail sod on sod.salesorderid = soh.salesorderid
join product p on p.productid = sod.productid
join address a on soh.billtoaddressid = a.addressid
join address a2 on soh.shiptoaddressid = a2.addressid