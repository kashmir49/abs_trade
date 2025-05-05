-- This macro generates a fact table by unpivoting the specified columns from the source table.
{% macro fact_table(table_name, date_column, new_column_name) %}
    with unpivoted as (
        {{
            dbt_utils.unpivot(
                relation=source('abs_trade', table_name),
                exclude=[date_column]
            )
        }}
    ),
    transformed as (
        select
            {{ dbt_utils.generate_surrogate_key([date_column, 'Field_Name']) }} as ID,
            CAST(TO_CHAR(TO_DATE({{date_column}}, 'MON-YYYY'), 'YYYYMMDD') AS INT) as Date_Key,
            {{ dbt_utils.generate_surrogate_key(['Field_Name']) }} as {{new_column_name~ '_Key'}},
            CAST(Value as NUMERIC(10, 0)) as Amount_in_Million_AUD
        from unpivoted
        where lower(Field_Name) != 'total'
    )
    select * from transformed
{% endmacro %}