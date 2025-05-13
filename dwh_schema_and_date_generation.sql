
-- ========================================
-- Data Warehouse Schema + dim_date script
-- ========================================

-- Generate dim_date table and populate from 2016-01-01 to 2018-12-31
GO

CREATE TABLE dim_date (
    date_key       INT         PRIMARY KEY,  -- YYYYMMDD
    full_date      DATE        NOT NULL,
    day_of_week    TINYINT     NOT NULL,     -- 1=Monday … 7=Sunday
    month          TINYINT     NOT NULL,
    quarter        TINYINT     NOT NULL,
    year           SMALLINT    NOT NULL,
    month_name     VARCHAR(20) NOT NULL,     -- 'January'
    quarter_name   VARCHAR(4)  NOT NULL,     -- 'Q1'
    day_of_year    SMALLINT    NOT NULL,
    is_weekend     BIT         NOT NULL,
    fiscal_year    SMALLINT    NOT NULL,
    fiscal_quarter TINYINT     NOT NULL,
    fiscal_month   TINYINT     NOT NULL
);
GO

SET DATEFIRST 7;  -- Ensure Sunday = 1, Saturday = 7

DECLARE @start_date DATE = '2016-01-01';
DECLARE @end_date   DATE = '2018-12-31';

WHILE @start_date <= @end_date
BEGIN
    INSERT INTO dim_date
    SELECT
        CONVERT(INT, CONVERT(CHAR(8), @start_date, 112)) AS date_key,
        @start_date,
        DATEPART(WEEKDAY, @start_date),
        MONTH(@start_date),
        DATEPART(QUARTER, @start_date),
        YEAR(@start_date),
        DATENAME(MONTH, @start_date),
        'Q' + CONVERT(VARCHAR(1), DATEPART(QUARTER, @start_date)),
        DATEPART(DAYOFYEAR, @start_date),
        CASE WHEN DATEPART(WEEKDAY, @start_date) IN (1,7) THEN 1 ELSE 0 END,
        YEAR(@start_date),
        DATEPART(QUARTER, @start_date),
        MONTH(@start_date);

    SET @start_date = DATEADD(DAY, 1, @start_date);
END;

-- ========================================
-- Dimension and Fact Table Definitions
-- ========================================

CREATE TABLE dim_customer (
    customer_key INT PRIMARY KEY IDENTITY(1,1),
    customer_id NVARCHAR(50),
    customer_unique_id NVARCHAR(50),
    customer_city NVARCHAR(100),
    customer_state NVARCHAR(50),
    start_date DATETIME,
    end_date DATETIME,
    current_flag BIT,
    load_date DATETIME DEFAULT GETDATE()
);

CREATE TABLE dim_product (
    product_key INT PRIMARY KEY IDENTITY(1,1),
    product_id NVARCHAR(50),
    product_category_name NVARCHAR(100),
    start_date DATETIME,
    end_date DATETIME,
    current_flag BIT,
    load_date DATETIME DEFAULT GETDATE()
);

CREATE TABLE dim_seller (
    seller_key INT PRIMARY KEY IDENTITY(1,1),
    seller_id NVARCHAR(50),
    seller_city NVARCHAR(100),
    seller_state NVARCHAR(50),
    load_date DATETIME DEFAULT GETDATE()
);


CREATE TABLE fact_order_items (
    order_item_key INT PRIMARY KEY IDENTITY(1,1),
    order_id NVARCHAR(50),
    order_item_id NVARCHAR(50),
    customer_key INT FOREIGN KEY REFERENCES dim_customer(customer_key),
    product_key INT FOREIGN KEY REFERENCES dim_product(product_key),
    seller_key INT FOREIGN KEY REFERENCES dim_seller(seller_key),
    date_key INT FOREIGN KEY REFERENCES dim_date(date_key),
    quantity INT,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    payment_value DECIMAL(10,2),
    load_date DATETIME DEFAULT GETDATE()
);

ALTER TABLE fact_order_items
ADD accm_txn_create_time DATETIME NULL,
    accm_txn_complete_time DATETIME NULL,
    txn_process_time_hours INT NULL;
