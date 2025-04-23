{{ config ( schema ='mart') }}
{{ fact_table(
    table_name='merchandise_imports',
    date_column = 'Month_Year',
    new_column_name='Goods'
) }}