CREATE DATABASE OrderDB
GO

USE OrderDB
GO

CREATE TABLE [categories]
(
  [categoryID] INT IDENTITY(1,1) PRIMARY KEY,
  [category] VARCHAR(128) NOT NULL UNIQUE
)

CREATE TABLE [subcategories]
(
  [subcategoryID] INT IDENTITY(1,1) PRIMARY KEY,
  [categoryID] INT NOT NULL FOREIGN KEY REFERENCES categories(categoryID),
  [subcategory] VARCHAR(128) NOT NULL UNIQUE
)
CREATE TABLE [products]
(
  [productID] VARCHAR(32) PRIMARY KEY,
  [subcategoryID] INT NOT NULL FOREIGN KEY REFERENCES subcategories(subcategoryID),
  [product] VARCHAR(128) NOT NULL UNIQUE
)
CREATE TABLE [markets]
(
  [marketID] INT IDENTITY(1,1) PRIMARY KEY,
  [market] VARCHAR(128) NOT NULL UNIQUE
)
CREATE TABLE [countries]
(
  [countryID] INT IDENTITY(1,1) PRIMARY KEY,
  [marketID] INT NOT NULL FOREIGN KEY REFERENCES markets(marketID),
  [country] VARCHAR(128) NOT NULL UNIQUE
)
CREATE TABLE [states]
(
  [stateID] INT IDENTITY(1,1) PRIMARY KEY,
  [countryID] INT NOT NULL FOREIGN KEY REFERENCES countries(countryID),
  [state] VARCHAR(128) NOT NULL UNIQUE
)
CREATE TABLE [cities]
(
  [cityID] INT IDENTITY(1,1) PRIMARY KEY,
  [stateID] INT NOT NULL FOREIGN KEY REFERENCES states(stateID),
  [city] VARCHAR(128) NOT NULL UNIQUE,
  [postal_code] VARCHAR(8)
)
CREATE TABLE [customers]
(
  [customerID] VARCHAR(32) NOT NULL PRIMARY KEY,
  [customer] VARCHAR(128) NOT NULL,
  [segment] VARCHAR(128) NOT NULL
)
CREATE TABLE [shipmodes]
(
  [shipmodeID] TINYINT IDENTITY(1,1) PRIMARY KEY,
  [shipmode] VARCHAR(32) NOT NULL UNIQUE
)
CREATE TABLE [orders]
(
  [orderID] VARCHAR(64) NOT NULL PRIMARY KEY,
  [customerID] VARCHAR(32) NOT NULL FOREIGN KEY REFERENCES customers(customerID),
  [cityID] INT NOT NULL FOREIGN KEY REFERENCES cities(cityID),
  [shipmodeID] TINYINT NOT NULL FOREIGN KEY REFERENCES shipmodes(shipmodeID),
  [order_date] DATE NOT NULL,
  [ship_date] DATE,
  CONSTRAINT ship_date CHECK (ship_date >= order_date)
)
CREATE TABLE [order_products]
(
  [orderID] VARCHAR(64) NOT NULL FOREIGN KEY REFERENCES orders(orderID),
  [productID] VARCHAR(32) NOT NULL FOREIGN KEY REFERENCES products(productID),
  PRIMARY KEY(orderID,productID),
  [quantity] INT NOT NULL CHECK (quantity>=0),
  [sales] SMALLMONEY NOT NULL,
  [discount] NUMERIC(3,2) NOT NULL,
  [shipping_cost] SMALLMONEY NOT NULL,
  [profit] SMALLMONEY NOT NULL
)
