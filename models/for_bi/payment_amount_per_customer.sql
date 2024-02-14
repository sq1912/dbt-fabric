
SELECT
    c.first_name
    , c.last_name
    , SUM(p.amount) AS sum_amount
FROM {{ref("payments_clean")}} p
INNER JOIN {{ref("orders_clean")}} o
    ON o.order_id = p.order_id
INNER JOIN {{ref("raw_customers")}} c
    ON c.id = o.customer_id
GROUP BY
    c.first_name
    , c.last_name