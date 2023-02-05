
CREATE TYPE OrderType AS TABLE
(id                             INT IDENTITY(1,1),
market                		 VARCHAR(128)    , 
country                		 VARCHAR(128)    ,
state                		 VARCHAR(128)    ,
city                		 VARCHAR(128)    ,
postal_code                  VARCHAR(8)      ,
customerID                	 VARCHAR(32)    ,
customer                	 VARCHAR(128)    ,
segment                		 VARCHAR(128)    ,
orderID						 VARCHAR(64)    ,
order_date                	 DATE    ,
ship_date                	 DATE    ,
shipmode                	 VARCHAR(32)    ,
category                	 VARCHAR(128)    ,
subcategory                 VARCHAR(128)    ,
productID                	 VARCHAR(32)    ,
product               	 VARCHAR(128)    ,
quantity					 INT,
sales					     SMALLMONEY,
discount					 NUMERIC(3,2),
shipping_cost			     SMALLMONEY,
profit					     SMALLMONEY
)
GO

CREATE PROCEDURE addorders 
        @parorder       OrderType READONLY  
       
AS 
BEGIN 
        SET NOCOUNT ON 
        DECLARE @idcolumn INT
        DECLARE @market                		 VARCHAR(128)     
        DECLARE @country                		 VARCHAR(128)     
        DECLARE @state                		 VARCHAR(128)     
        DECLARE @city                		 VARCHAR(128)     
        DECLARE @postal_code                  VARCHAR(8)       
        DECLARE @customerID                	 VARCHAR(32)     
        DECLARE @customer                	 VARCHAR(128)     
        DECLARE @segment                		 VARCHAR(128)     
        DECLARE @orderID						 VARCHAR(64)     
        DECLARE @order_date                	 DATE    
        DECLARE @ship_date                	 DATE     
        DECLARE @shipmode                	 VARCHAR(32)     
        DECLARE @category                	 VARCHAR(128)     
        DECLARE @subcategory                 VARCHAR(128)     
        DECLARE @productID                	 VARCHAR(32)     
        DECLARE @product                	 VARCHAR(128)     
        DECLARE @quantity					 INT 
        DECLARE @sales					     SMALLMONEY 
        DECLARE @discount					 NUMERIC(3,2) 
        DECLARE @shipping_cost			     SMALLMONEY 
        DECLARE @profit					     SMALLMONEY 

        SELECT @idcolumn=min( id ) from @parorder
        WHILE @idcolumn IS NOT NULL
        BEGIN
                SELECT 
                @market=market,
                @country=country,
                @state=state,
                @city=city,
                @postal_code=postal_code,
                @customerID = customerID,
                @customer = customer,
                @segment = segment,
                @orderID= orderID,						
                @order_date=  order_date,              	
                @ship_date=  ship_date,              
                @shipmode= shipmode,               	 
                @category= category,             	 
                @subcategory= subcategory,                
                @productID= productID,               	 
                @product= product,               	
                @quantity= quantity,					 
                @sales=	sales,				     
                @discount= discount,					 
                @shipping_cost=	shipping_cost,		     
                @profit= profit					      
                FROM @parorder WHERE id=@idcolumn
                
                



                BEGIN TRANSACTION
                IF NOT EXISTS (SELECT 1 FROM categories WHERE category=@category)
                BEGIN
                        INSERT INTO categories (category)
                        VALUES (@category);
                END
                COMMIT TRANSACTION

                BEGIN TRANSACTION
                IF NOT EXISTS (SELECT 1 FROM subcategories WHERE subcategory=@subcategory)
                BEGIN
                        INSERT INTO subcategories (categoryID,subcategory)
                        VALUES (
                        (SELECT categoryID FROM categories WHERE category=@category),
                        @subcategory);
                END
                COMMIT TRANSACTION

                BEGIN TRANSACTION
                IF NOT EXISTS (SELECT 1 FROM products WHERE product=@product)
                BEGIN
                        INSERT INTO products (productID,subcategoryID,product)
                        VALUES (@productID,
                                (SELECT subcategoryID FROM subcategories WHERE subcategory=@subcategory),
                                @product);
                END
                COMMIT TRANSACTION
                
                BEGIN TRANSACTION
                IF NOT EXISTS (SELECT 1 FROM markets WHERE market=@market)
                BEGIN                
                        INSERT INTO markets (market) 
                        VALUES (@market);
                END
                COMMIT TRANSACTION
                
                BEGIN TRANSACTION
                IF NOT EXISTS (SELECT 1 FROM countries WHERE country=@country)
                BEGIN        
                        INSERT INTO countries (marketID,country) 
                        VALUES ((SELECT marketID FROM markets WHERE market=@market),
                                @country);
                END
                COMMIT TRANSACTION
                
                BEGIN TRANSACTION
                IF NOT EXISTS (SELECT 1 FROM states WHERE state=@state)
                BEGIN                
                        INSERT INTO states (countryID,state)
                        VALUES ((SELECT countryID FROM countries WHERE country=@country),
                                @state);
                END
                COMMIT TRANSACTION
                
                BEGIN TRANSACTION
                IF NOT EXISTS (SELECT 1 FROM cities WHERE city=@city)
                BEGIN                
                        INSERT INTO cities (stateID,city,postal_code)
                        VALUES ((SELECT stateID FROM states WHERE state=@state),
                                @city,
                                @postal_code);
                END
                COMMIT TRANSACTION
                
                BEGIN TRANSACTION
                IF NOT EXISTS (SELECT 1 FROM customers WHERE customer=@customer)
                BEGIN                
                        INSERT INTO customers (customerID,customer,segment)
                        VALUES (@customerID,
                                @customer,
                                @segment);
                END
                COMMIT TRANSACTION
                
                BEGIN TRANSACTION
                IF NOT EXISTS (SELECT 1 FROM shipmodes WHERE shipmode=@shipmode)
                BEGIN
                        INSERT INTO shipmodes (shipmode) 
                        VALUES (@shipmode);
                END
                COMMIT TRANSACTION
                
                BEGIN TRANSACTION
                IF NOT EXISTS (SELECT 1 FROM orders WHERE orderID=@orderID)
                BEGIN
                        INSERT INTO orders (orderID,customerID,cityID,shipmodeID,order_date,ship_date) 
                        VALUES (@orderID,
                                (SELECT customerID FROM customers WHERE customer=@customer),
                                (SELECT cityID FROM cities WHERE city=@city),
                                (SELECT shipmodeID FROM shipmodes WHERE shipmode=@shipmode),
                                @order_date,
                                @ship_date); 
                END
                COMMIT TRANSACTION
                
                BEGIN TRANSACTION
                INSERT INTO order_products (orderID,productID,quantity,sales,discount,shipping_cost,profit)
                VALUES ((SELECT orderID FROM orders WHERE orderID=@orderID),
                        (SELECT productID FROM products WHERE product=@product),
                        @quantity,
                        @sales,
                        @discount,
                        @shipping_cost,
                        @profit);
                COMMIT TRANSACTION

                SELECT @idcolumn=min( id ) FROM @parorder WHERE id>@idcolumn
        END        
    
END 
