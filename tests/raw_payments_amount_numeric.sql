{{ config(warn_if = '>4',error_if = '>500') }}

SELECT *
FROM {{ref("raw_payments")}}
WHERE TRY_CAST(amount AS INT) IS NULL