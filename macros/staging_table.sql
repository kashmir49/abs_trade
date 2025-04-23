-- This macro generates a staging table for the given source table.
-- It unpivots the data, generates a surrogate key, and transforms the date column into a key format.
{% macro staging_table(table_name, date_column, new_column_name) %}
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
            TO_DATE({{date_column}}, 'MON-YYYY')as Month_Year,
            Field_Name as {{new_column_name}},
            Value as Amount_in_Million_AUD
        from unpivoted
    )
    select * from transformed
{% endmacro %}