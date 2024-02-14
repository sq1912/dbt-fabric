
WITH vals AS (
    SELECT  
         raw_cnt = (SELECT count(*) FROM {{ref("raw_payments")}})
        ,clean_cnt = (SELECT count(*) FROM {{ref("payments_clean")}})
        ,allowed_missing = 10
)
SELECT *
FROM vals
WHERE clean_cnt + allowed_missing < raw_cnt