{{ config ( schema ='mart') }}
    (
        {{ dim_table(
            table_name='merchandise_exports_by_industry',
            date_column = 'Month_Year',
            new_column_name='Industry'
        ) }}
    )
    union
    (
        {{ dim_table(
            table_name='merchandise_imports_by_industry',
            date_column = 'Month_Year',
            new_column_name='Industry'
        ) }}
    )