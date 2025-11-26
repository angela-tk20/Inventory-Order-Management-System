USE inventory_order_db;
DELIMITER $$
DROP FUNCTION IF EXISTS fn_get_product_price$$

CREATE FUNCTION fn_get_product_price(
    p_product_id INT
)
RETURNS DECIMAL(10,2)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_price DECIMAL(10,2);
    
   
    SELECT price 
    INTO v_price
    FROM products
    WHERE product_id = p_product_id;
    
    
    RETURN v_price;
END $$