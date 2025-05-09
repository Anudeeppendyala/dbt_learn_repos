SELECT
    MD5(order_id) AS order_key,
    order_id AS order_id,
    MD5(customer_id) AS customer_sk,  -- Reference to stg_customers
    MD5(store_id) AS store_sk,  -- Reference to stg_stores
    TO_DATE(order_date) AS order_date,
    GREATEST(total_amount, 0) AS total_amount,
    GREATEST(discount_applied, 0) AS discount_applied,
    total_amount - discount_applied AS net_amount,  -- Derived column
    CASE WHEN discount_applied > 0 THEN TRUE ELSE FALSE END AS has_discount,
    CURRENT_TIMESTAMP() AS record_loaded_at
FROM retail_db.public.orders
WHERE order_id IS NOT NULL
  AND customer_id IS NOT NULL
  AND store_id IS NOT NULL
QUALIFY ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY order_date) =1