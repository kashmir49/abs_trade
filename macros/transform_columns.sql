{% macro transform_columns(source_table, exclude_columns=[], multiplier=1000000) %}
  {%- set columns = adapter.get_columns_in_relation(source_table) -%}
  
  select
    {%- for col in columns %}
      {%- if col.name in exclude_columns %}
        {{ col.name }}
      {%- else %}
        CAST({{ col.name }} * {{ multiplier }} AS BIGINT) as {{ col.name }}
      {%- endif %}
      {%- if not loop.last %},{% endif %}
    {%- endfor %}
  from {{ source_table }}
{% endmacro %}