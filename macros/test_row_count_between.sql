{% test row_count_between(model, min, max) %}

    select row_count
    from (select count(*) as row_count from {{ model }}) AS x
    where row_count < {{ min }}
       or row_count > {{ max }}
       
{% endtest %}