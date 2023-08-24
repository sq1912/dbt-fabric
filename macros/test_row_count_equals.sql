{% test row_count_equals(model, value) %}
    SELECT row_count
    FROM (SELECT count(*) AS row_count from {{ model }}) x
    where x.row_count <> {{ value }}
{% endtest %}