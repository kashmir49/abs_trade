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
    union
    select
        {{ dbt_utils.generate_surrogate_key(['Industry']) }} as industry_key,
        Industry
    from 
     (select 'Not Available' as Industry)