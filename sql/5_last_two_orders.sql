CREATE PROCEDURE select_consumer_last_two_orders
AS
BEGIN
    SELECT orderID,order_date,product,sales,customer FROM 
    (
        SELECT 
            orders.orderID,
            orders.order_date,
            products.product,
            order_products.sales,
            customers.customer,
            DENSE_RANK() OVER(PARTITION BY customers.customer ORDER BY orders.order_date DESC) AS OrderRank
            FROM products
            JOIN order_products ON order_products.productID = products.productID
            JOIN orders ON orders.orderID = order_products.orderID
            JOIN customers ON customers.customerID = orders.customerID
            WHERE customers.segment='Consumer'
            
    ) AS TempTable
    WHERE OrderRank <= 2
    ORDER BY customer, order_date desc
END

GO
