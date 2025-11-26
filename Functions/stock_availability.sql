USE inventory_order_db;

DELIMITER $$

DROP FUNCTION IF EXISTS fn_check_stock_availability$$

CREATE FUNCTION fn_check_stock_availability(
    p_product_id INT,
    p_quantity INT
) 
RETURNS BOOLEAN
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_current_stock INT;
    
    -- Get current stock quantity
    SELECT stock_quantity 
    INTO v_current_stock
    FROM products
    WHERE product_id = p_product_id;
    
    -- If product doesn't exist, return FALSE
    IF v_current_stock IS NULL THEN
        RETURN FALSE;
    END IF;
    
    -- Return TRUE if sufficient stock, FALSE otherwise
    RETURN v_current_stock >= p_quantity;
END$$