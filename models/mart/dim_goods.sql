{{ config ( schema ='mart') }}
(
{{ dim_table(
    table_name='merchandise_exports',
    date_column = 'Month_Year',
    new_column_name='Goods'
) }}
)
union
(
{{ dim_table(
    table_name='merchandise_imports',
    date_column = 'Month_Year',
    new_column_name='Goods'
) }}
)