

SELECT *
FROM {{ ref("top_10_customers")}}
WHERE first_name = 'Howard'