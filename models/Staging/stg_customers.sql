--{{ config(materialized='view') }}

SELECT
    MD5(customer_id) AS customer_key,
    customer_id,
    TRIM(CONCAT(first_name, ' ', last_name)) AS full_name,
    TRIM(LOWER(email)) AS email,
    --CASE WHEN EXISTS (SELECT 1 FROM retail_db.public.orders o2
    -- WHERE o2.customer_id = c.customer_id AND o2.order_id != c.order_id)
    -- THEN 'Returning' ELSE 'New' END AS customer_type,
    INITCAP(region) AS region,
    CASE WHEN REGEXP_REPLACE(email, '[^a-zA-Z0-9@.]', '') LIKE '%@%.%' THEN TRUE ELSE FALSE END AS is_valid_email,  -- Basic email validation
    CURRENT_TIMESTAMP() AS record_loaded_at
FROM retail_db.public.customers --{{ ref('customers') }}
WHERE customer_id IS NOT NULL
  AND email IS NOT NULL