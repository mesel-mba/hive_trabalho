USE AdventureWorks;
SELECT * FROM sales_order_detail JOIN product ON (product.ProductID = sales_order_detail.ProductID);