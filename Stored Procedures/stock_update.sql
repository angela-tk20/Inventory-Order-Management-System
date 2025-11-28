USE inventory_order_db;
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_update_product_stock$$

CREATE PROCEDURE sp_update_product_stock(
    IN p_product_id INT,
    IN p_quantity_change INT,
    IN p_change_type VARCHAR(10),
    IN p_order_id INT,
    OUT p_success BOOLEAN
)
BEGIN
    DECLARE v_new_quantity INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- If error occurs, rollback and return failure
        ROLLBACK;
        SET p_success = FALSE;
    END;
    
    START TRANSACTION;
    
    -- Log the change BEFORE updating
    CALL sp_log_inventory_change(
        p_product_id,
        p_change_type,
        p_quantity_change,
        p_order_id
    );
    
    -- Update stock quantity
    UPDATE products
    SET stock_quantity = stock_quantity + p_quantity_change
    WHERE product_id = p_product_id;
    
    -- Get new quantity to validate
    SELECT stock_quantity 
    INTO v_new_quantity
    FROM products
    WHERE product_id = p_product_id;
    
    -- Check if stock went negative (shouldn't happen with proper validation)
    IF v_new_quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock cannot be negative';
    END IF;
    
    COMMIT;
    SET p_success = TRUE;
END $$