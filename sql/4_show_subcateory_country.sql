CREATE PROCEDURE show_subcateory_country
        @subcategory                VARCHAR(128)  = NULL, 
        @country                	VARCHAR(128)  = NULL   
AS
BEGIN
        SELECT 
        subcategories.subcategory,
        countries.country,
        orders.orderID,
        orders.order_date,
        orders.ship_date,
        products.product,
        order_products.sales,
        order_products.quantity,
        order_products.profit
        FROM products
        JOIN subcategories ON products.subcategoryID = subcategories.subcategoryID
        JOIN order_products ON order_products.productID = products.productID
        JOIN orders ON orders.orderID = order_products.orderID
        JOIN cities ON cities.cityID = orders.cityID
        JOIN states ON states.stateID = cities.stateID
        JOIN countries ON countries.countryID = states.countryID
        WHERE subcategories.subcategory=@subcategory AND countries.country= @country;
END
