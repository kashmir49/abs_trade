{{ config ( schema ='mart') }}
(
{{ dim_table(
    table_name='merchandise_exports_by_country',
    date_column = 'Month_Year',
    new_column_name='Country'
) }}
)
union
(
{{ dim_table(
    table_name='merchandise_imports_by_country',
    date_column = 'Month_Year',
    new_column_name='Country'
) }}
)