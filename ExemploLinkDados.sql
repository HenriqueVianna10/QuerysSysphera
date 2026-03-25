CREATE view [dbo].[VW_App5_to_App1] as 
select map.[sk_account_planning], f.[sk_time], f.[sk_scenario], [sk_entity], sum(f.[value]) as [value], 'etl' as [cod_user], getdate() as [dat_update], 
6 as [type_update], [sk_company], -1 as [sk_department], c1.[sk_channel], -1 as [sk_source]
from f_app5 f
inner join (
	select 1058	as sk_account_planning, 225 as sk_account_sales union all
	select 1054	as sk_account_planning, 4 as sk_account_sales union all
	select 1060	as sk_account_planning, 1057 as sk_account_sales union all
	select 195	as sk_account_planning, 1 as sk_account_sales union all
	select 1056	as sk_account_planning, 223 as sk_account_sales union all
	select 197	as sk_account_planning, 17 as sk_account_sales union all
	select 198	as sk_account_planning, 7 as sk_account_sales union all
	select 199	as sk_account_planning, 11 as sk_account_sales union all
	select 201	as sk_account_planning, 10 as sk_account_sales union all
	select 1097	as sk_account_planning, 2 as sk_account_sales 
) map on (f.sk_account = map.sk_account_sales)
--inner join f_app1_scenario sc on (f.sk_scenario = sc.sk_scenario and f.sk_time = sc.sk_time and sc.value in (0, 1))
inner join d_customer_app5 c5 on (f.sk_customer = c5.sk_customer) 
inner join d_channel_app1 c1 on ((c5.channel <> '' and c1.channel_code <> '' AND c5.channel = c1.channel_code)
	or (c5.sk_customer = -1 and c1.sk_channel = -1))
inner join d_buy_type_app5 bt on (f.sk_buy_type = bt.sk_buy_type and bt.sk_buy_type_l0 = 1)
group by map.[sk_account_planning], f.[sk_time], f.[sk_scenario], [sk_entity], [sk_company], c1.[sk_channel]
GO





declare @BudgetBaseScenario int = 'Instance(BudgetBaseScenario)';

delete f from f_app1 f
join f_app1_scenario sce on sce.sk_scenario = f.sk_scenario and sce.sk_time = f.sk_time and sce.value = 1
where f.sk_scenario = @BudgetBaseScenario and sk_account in (197, 195, 198, 199, 201, 1054, 1056, 1058, 1060, 1097) 
--and sk_time between @ForecastPeriodStart and @ForecastPeriodEnd;

insert into f_app1 ([sk_account], [sk_time], [sk_scenario], [sk_entity], [value], [cod_user], [dat_update], 
[type_update], [sk_company], [sk_department], [sk_channel], [sk_source])
select [sk_account_planning], vw.[sk_time], vw.[sk_scenario], [sk_entity], vw.[value], [cod_user], [dat_update], 
[type_update], [sk_company], [sk_department], [sk_channel], [sk_source]
from VW_App5_to_App1 vw
join f_app1_scenario sce on sce.sk_scenario = vw.sk_scenario and sce.sk_time = vw.sk_time and sce.value = 1
where vw.sk_scenario = @BudgetBaseScenario --and sk_time between @ForecastPeriodStart and @ForecastPeriodEnd;