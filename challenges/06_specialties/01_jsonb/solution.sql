SELECT
    product_name,
    price,
    metadata->>'color' AS color,
    metadata->>'material' AS material,
    metadata->>'in_stock' AS in_stock
FROM products
WHERE metadata ? 'color'
ORDER BY product_name;
