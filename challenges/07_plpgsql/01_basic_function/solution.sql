CREATE OR REPLACE FUNCTION total_orders_for_customer(p_customer_id INT)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    result INTEGER;
BEGIN
    SELECT COUNT(*) INTO result
    FROM orders
    WHERE customer_id = p_customer_id;
    RETURN result;
END;
$$;
