
    {{ config( schema='mart' ) }}
    with date_dim as (
        {{ dbt_utils.date_spine(
            datepart="day",
            start_date="cast('1988-01-01' as date)",
            end_date="cast('2026-01-01' as date)"
            )
        }} 
     ),
    date_details as (
        select
        to_char(date_day, 'YYYYMMDD') as Date_Key,
        date_day as date,
        date_part('year', date_day) as year,
        date_part('month', date_day) as month,
        date_part('day', date_day) as day,
        date_part('quarter', date_day) as quarter,
        to_char(date_day, 'DY') as day_name,
        to_char(date_day, 'MMMM') as month_number,
        to_char(date_day, 'MON') as short_month_name
        from date_dim
    )
    select * from date_details
