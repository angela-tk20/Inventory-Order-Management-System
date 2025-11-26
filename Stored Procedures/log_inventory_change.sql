USE inventory_order_db;
DELIMITER $$
DROP PROCEDURE IF EXISTS log_inventory_change$$

CREATE PROCEDURE log_inventory_change(
    IN p_product_id INT,
    IN p_change_type VARCHAR(10),
    IN p_quantity_change INT,
    IN p_order_id INT
)
BEGIN

    INSERT INTO inventory_logs (
        product_id,
        change_type,
        quantity_change,
        order_id
    ) VALUES (
        p_product_id,
        p_change_type,
        p_quantity_change,
        p_order_id
    );
END $$