CREATE OR REPLACE PROCEDURE transfer_product_stock(
    from_product_id INT,
    to_product_id INT,
    qty INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    source_qty INT;
BEGIN
    SELECT quantity INTO source_qty
    FROM products
    WHERE product_id = from_product_id
    FOR UPDATE;

    IF source_qty < qty THEN
        RAISE EXCEPTION 'Insufficient stock in product %: have %, need %',
            from_product_id, source_qty, qty;
    END IF;

    UPDATE products SET quantity = quantity - qty WHERE product_id = from_product_id;
    UPDATE products SET quantity = quantity + qty WHERE product_id = to_product_id;
END;
$$;
