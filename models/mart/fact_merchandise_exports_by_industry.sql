{{ config ( schema ='mart') }}
with industry as (
{{ fact_table(
    table_name='merchandise_exports_by_industry',
    date_column = 'Month_Year',
    new_column_name='Industry'
) }}
),
add_date as (
    select
        i.ID,
        d.date_key,
        coalesce(i.industry_key, 'Not Available') as industry,
        i.Amount_in_million_aud
    from {{ref('dim_date')}} d
    left join industry i on d.date_key = i.date_key
    where d.date = DATE_TRUNC('month', d.date)
    and i.ID is null
),
fill_null as (
    select
        {{ dbt_utils.generate_surrogate_key(['date_key', 'industry']) }} as ID,
        date_key,
        {{ dbt_utils.generate_surrogate_key(['industry']) }} as industry_key,
        Amount_in_million_aud
    from add_date
)
select * from fill_null
union
select * from industry
