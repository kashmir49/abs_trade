{{ config ( schema ='mart') }}

with upper as (
    select 
        UPPER(Goods_Sub_Category) as Goods_Sub_Category,
        UPPER(Goods_Category) as Goods_Category
    from {{ source('abs_trade', 'goods') }}
), goods as (
    select 
        {{ dbt_utils.generate_surrogate_key(['Goods_Sub_Category']) }} as Goods_Key,
        INITCAP(REPLACE(Goods_Sub_Category, '_', ' ')) as Goods_Sub_Category,
        {{ dbt_utils.generate_surrogate_key(['Goods_Category']) }} as Goods_Category_Key,
        INITCAP(REPLACE(Goods_Category, '_', ' ')) as Goods_Category
    from upper
    where UPPER(Goods_Sub_Category) != 'TOTAL'
)
select * from goods