--{{ config(materialized='view') }}

SELECT
    MD5(store_id) AS store_key,
    store_id AS store_id,  -- Natural key
    TRIM(UPPER(store_name)) AS store_name,
    COALESCE(TRIM(UPPER(location)), 'Unknown') AS location,
    TRUE AS is_active,  -- Derived column (can be updated based on business logic)
    CURRENT_TIMESTAMP() AS record_loaded_at  -- Audit column
FROM retail_db.public.stores -- {{ ref('stores') }} 
WHERE store_id IS NOT NULL  -- Ensure no invalid records