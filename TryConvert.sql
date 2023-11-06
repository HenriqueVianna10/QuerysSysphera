select *
  from 
  (
  SELECT 
    CASE
        WHEN TRY_CAST(REPLACE(REPLACE([net_sales_usd],',','.'),'R$','') AS numeric(28,14)) IS NULL
        THEN 'Cast failed'
        ELSE 'Cast succeeded'
    END AS Result,
	net_sales_usd
	from
	DT_etl_tmp_base_pl_realizado
	) as w
	where w.Result = 'Cast failed'



SELECT REPLACE(REPLACE(@coluna,CHAR(13) + Char(10) ,' '), CHAR(10), '')

