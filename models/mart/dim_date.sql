{{ config( schema='mart' ) }}
{% set min_date_query %}
    select MIN(TO_DATE(Month_Year, 'MON-YYYY')) as min_date from {{ source('abs_trade', 'merchandise_exports') }}
{% endset %}
{% set min_date = dbt_utils.get_single_value(min_date_query) %}

{% set max_date_query %}
    select ADD_MONTHS(MAX(TO_DATE(Month_Year, 'MON-YYYY')), 1) as max_date from {{ source('abs_trade', 'merchandise_exports') }}
{% endset %}
{% set max_date = dbt_utils.get_single_value(max_date_query) %}

with date_dim as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('" ~ min_date ~ "' as date)",
        end_date="cast('" ~ max_date ~ "' as date)"
    ) }}
),
date_details as (
    select
        cast(to_char(date_day, 'YYYYMMDD') as integer) as Date_Key,
        date_day as Date,
        cast(date_part('year', date_day) as int) as Year,
        cast(date_part('month', date_day) as int) as Month,
        cast(date_part('day', date_day) as int) as Day,
        cast(date_part('quarter', date_day) as int) as Quarter,
        to_char(date_day, 'DY') as Day_Name,
        to_char(date_day, 'MMMM') as Month_Name,
        to_char(date_day, 'MON') as Short_Month_Name
    from date_dim
)
select * from date_details