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
    
    -- Get current price
    SELECT price 
    INTO v_price
    FROM products
    WHERE product_id = p_product_id;
    
    -- Return price (will be NULL if product doesn't exist)
    RETURN v_price;
END $$