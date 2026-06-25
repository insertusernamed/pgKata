CREATE OR REPLACE FUNCTION get_products_by_price_range(min_price NUMERIC, max_price NUMERIC)
RETURNS TABLE(product_id INT, name VARCHAR, price NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT p.product_id, p.name::VARCHAR, p.price
    FROM products p
    WHERE p.price BETWEEN min_price AND max_price
    ORDER BY p.price;
END;
$$;

SELECT * FROM get_products_by_price_range(0, 0);
