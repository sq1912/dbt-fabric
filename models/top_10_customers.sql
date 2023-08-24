

SELECT TOP 10 c.customer_id, c.first_name, c.last_name, sum(amount) as amount
FROM {{ ref("customers")}} AS c
INNER JOIN {{ ref("orders")}} AS o
    ON o.customer_id = c.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name
ORDER BY 4 DESC 