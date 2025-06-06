-- This macro generates a dimension table from a source table by unpivoting it and transforming the field names.
{% macro dim_table(table_name, date_column, new_column_name) %}
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
            distinct
            {{ dbt_utils.generate_surrogate_key(['Field_Name']) }} as {{new_column_name~ '_Key'}},
            INITCAP(REPLACE(Field_Name, '_', ' ')) as {{new_column_name}}
        from unpivoted
        where lower(Field_Name) != 'total'
    )
    select * from transformed
{% endmacro %}