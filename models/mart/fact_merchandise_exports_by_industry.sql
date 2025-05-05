{{ config ( schema ='mart') }}
{{ fact_table(
    table_name='merchandise_exports_by_industry',
    date_column = 'Month_Year',
    new_column_name='Industry'
) }}
