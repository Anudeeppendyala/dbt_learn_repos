--{{ config(materialized='view') }}

SELECT
    MD5(sale_id) AS sale_key,
    sale_id AS sale_id,
    MD5(order_id) AS order_sk,  -- Reference to stg_orders
    MD5(product_id) AS product_sk,  -- Reference to stg_products
    GREATEST(quantity, 0) AS quantity,
    GREATEST(unit_price, 0) AS unit_price,
    CAST(sale_date AS DATE) AS sale_date,
    quantity * unit_price AS sale_amount,  -- Derived column
    CASE WHEN quantity * unit_price > 500 THEN TRUE ELSE FALSE END AS is_high_value_sale,
    CURRENT_TIMESTAMP() AS record_loaded_at
FROM retail_db.public.sales --{{ ref('sales') }}
WHERE sale_id IS NOT NULL
  AND order_id IS NOT NULL
  AND product_id IS NOT NULL