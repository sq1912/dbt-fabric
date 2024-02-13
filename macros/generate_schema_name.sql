{# siehe https://docs.getdbt.com/docs/build/custom-schemas

  wir brauchen das, damit der custom schema name nicht beim standard-Schema hintendran gehaengt wird
  
  Wenn das standard-scchema dbo ist, und das custom schema c ist, dann is das Standard-Verhalten, dass
  dbt ein schema namens dbo_c generiert. Wir wollen das nicht. Wir wollen, dass das custom schema das 
  standard-schema vollkommen überschreibt, und im OUtput also nur c rauskommt. Hier steuern wir das:  
   #}

{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}

        {{ default_schema }}

    {%- else -%}

        {{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}
