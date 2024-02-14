

SELECT [order_id]
      ,[payment_method]
      , CAST(amount AS INT) as amount
FROM {{ref("raw_payments")}}
WHERE TRY_CAST(amount AS INT) IS NOT NULL