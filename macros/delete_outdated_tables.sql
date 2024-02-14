{% macro delete_outdated_tables(list_only=False) %} 

/*
Dieses Makro droppt alle Tables und Views, die nicht in dbt existieren. Es dient dazu, alte
und ungenutzte Tables und Views aus der Produktivumgebung zu entfernen um diese übersichtlich
zu halten. BITTE SEEEEHR VORSICHTIG DAMIT UMGEHEN!

Es kann ausgeführt werden mit folgendem Konsolen-Befehl:
    
    dbt run-operation delete_outdated_tables

Wenn man nur sehen will, welche Tabellen und Views das Makro löschen würde, ohne diese Objekte
tatsächlich zu löschen, dann ist der list_only Parameter auf True zu setzen:

    dbt run-operation delete_outdated_tables --args "{list_only: True}"

*/

    {% call statement('outdated_tables', fetch_result=True) %}

        with currenly_existing as (
           select
                table_schema as schema_name,
                table_name as ref_name,
                lower(coalesce(nullif(table_type, 'BASE TABLE'), 'table')) as ref_type
            from information_schema.tables
        )
        select curr.schema_name,
                curr.ref_name,
                curr.ref_type
        from currenly_existing as curr
        left join (values
            {%- for node in graph.nodes.values() | selectattr("resource_type", "equalto", "model") | list
                        + graph.nodes.values() | selectattr("resource_type", "equalto", "seed")  | list %} 
            ('{{node.schema}}', '{{node.name}}'){% if not loop.last %},{% endif %}
            {%- endfor %}
        ) as desired (schema_name, ref_name) 
            on desired.schema_name = curr.schema_name
            and desired.ref_name    = curr.ref_name
        
        where desired.ref_name is null

    {% endcall %}
    {%- for to_delete in load_result('outdated_tables')['data'] %} 

        {% if list_only %}

            {{ log('would drop ' ~ to_delete[2] ~ ' ' ~ to_delete[0] ~ '.' ~ to_delete[1], info=true) }}

        {% else %}

            {{ log('dropping ' ~ to_delete[2] ~ ' ' ~ to_delete[0] ~ '.' ~ to_delete[1], info=true) }}
            {% call statement() -%}    
            drop {{ to_delete[2] }} if exists "{{ to_delete[0] }}"."{{ to_delete[1] }}" 
            {%- endcall %}

        {%- endif %}

    {%- endfor %}

{% endmacro %}