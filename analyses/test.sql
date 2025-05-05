-- Dynamically calculate start_date and end_date from the source table
{% set min_date_query %}
    select MIN(TO_DATE(Month_Year, 'MON-YYYY')) as min_date from {{ source('abs_trade', 'merchandise_exports') }}
{% endset %}
{% set min_date_value = run_query(min_date_query) %}
{% if execute %}
{% set min_date = min_date_value.columns[0].values()[0]%}
{% endif %}

with date_dim as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('" ~ min_date ~ "' as date)",
        end_date="cast('2026-01-01' as date)"
    ) }}
),
date_details as (
    select
        cast(to_char(date_day, 'YYYYMMDD') as integer) as Date_Key,
        date_day as date,
        cast(date_part('year', date_day) as int) as year,
        cast(date_part('month', date_day) as int) as month,
        cast(date_part('day', date_day) as int) as day,
        cast(date_part('quarter', date_day) as int) as quarter,
        to_char(date_day, 'DY') as day_name,
        to_char(date_day, 'MMMM') as month_name,
        to_char(date_day, 'MON') as short_month_name
    from date_dim
)
select * from date_details