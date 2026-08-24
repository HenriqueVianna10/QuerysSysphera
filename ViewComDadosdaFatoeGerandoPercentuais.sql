USE [Sysphera]
GO

/****** Object:  View [dbo].[vw_financial_summary]    Script Date: 3/26/2026 2:41:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vw_financial_summary] AS
SELECT 
    channel.channel AS 'Channel',
    brand.entity AS 'Brand',
    SUM(CASE WHEN fto.sk_account = 195 THEN fto.[value] ELSE 0 END) AS 'Gross Sales',
    SUM(CASE WHEN fto.sk_account = 197 THEN fto.[value] ELSE 0 END) AS 'Sales - Allowances',
    SUM(CASE WHEN fto.sk_account = 198 THEN fto.[value] ELSE 0 END) AS 'Sales - Returns',
    SUM(CASE WHEN fto.sk_account = 199 THEN fto.[value] ELSE 0 END) AS 'Sales Other',
    SUM(CASE WHEN fto.sk_account = 200 THEN fto.[value] ELSE 0 END) AS 'Discount Cost',
    SUM(CASE WHEN fto.sk_account = 201 THEN fto.[value] ELSE 0 END) AS 'Volume Discount',
    SUM(CASE WHEN fto.sk_account IN (197,198,200,201,1048,1088) THEN fto.[value] ELSE 0 END) AS 'Returns, Allowances & Discounts',
    CAST(CAST(ROUND(CASE 
        WHEN SUM(CASE WHEN fto.sk_account IN (195,197,198,200,201,1048,1088) THEN fto.[value] ELSE 0 END) = 0 
        THEN 0 
        ELSE SUM(CASE WHEN fto.sk_account IN (197,198,200,201,1048,1088) THEN fto.[value] ELSE 0 END) / 
             SUM(CASE WHEN fto.sk_account IN (195,197,198,200,201,1048,1088) THEN fto.[value] ELSE 0 END) * 100
    END,2) as decimal(18,2)) as varchar(20)) + '%' AS 'Percent RAD of Net Sales',
    SUM(CASE WHEN fto.sk_account IN (195,197,198,200,201,1048,1088) THEN fto.[value] ELSE 0 END) AS 'Net Sales - P&L',
    SUM(CASE WHEN fto.sk_account IN (1054,1055,1273) THEN fto.[value] ELSE 0 END) AS 'Cost of Sales',
    CAST(CAST(ROUND(CASE 
        WHEN SUM(CASE WHEN fto.sk_account IN (195,197,198,200,201,1048,1088) THEN fto.[value] ELSE 0 END) = 0 
        THEN 0 
        ELSE SUM(CASE WHEN fto.sk_account IN (1054,1055,1273) THEN fto.[value] ELSE 0 END) / 
             SUM(CASE WHEN fto.sk_account IN (195,197,198,200,201,1048,1088) THEN fto.[value] ELSE 0 END) * 100
    END,2) as decimal(18,2)) as varchar(20)) + '%' AS 'Percent Cost of Sales',
    SUM(CASE WHEN fto.sk_account IN (1054,1055,1273) THEN fto.[value] ELSE 0 END) AS 'Cost of Goods Sold at Std',
    CAST(CAST(ROUND(CASE 
        WHEN SUM(CASE WHEN fto.sk_account IN (195,197,198,200,201,1048,1088) THEN fto.[value] ELSE 0 END) = 0 
        THEN 0 
        ELSE SUM(CASE WHEN fto.sk_account IN (1054,1055,1273) THEN fto.[value] ELSE 0 END) / 
             SUM(CASE WHEN fto.sk_account IN (195,197,198,200,201,1048,1088) THEN fto.[value] ELSE 0 END) * 100
    END,2) as decimal(18,2)) as varchar(20)) + '%' AS 'Percent Cost of Goods Sold Std',
    SUM(CASE WHEN fto.sk_account IN (195,197,198,200,201,1048,1088) THEN fto.[value] ELSE 0 END) - 
    SUM(CASE WHEN fto.sk_account IN (1054,1055,1273) THEN fto.[value] ELSE 0 END) AS 'Gross Profit before Royalties',
    CAST(CAST(ROUND(CASE 
        WHEN SUM(CASE WHEN fto.sk_account IN (195,197,198,200,201,1048,1088) THEN fto.[value] ELSE 0 END) = 0 
        THEN 0 
        ELSE (SUM(CASE WHEN fto.sk_account IN (195,197,198,200,201,1048,1088) THEN fto.[value] ELSE 0 END) - 
              SUM(CASE WHEN fto.sk_account IN (1054,1055,1273) THEN fto.[value] ELSE 0 END)) / 
              SUM(CASE WHEN fto.sk_account IN (195,197,198,200,201,1048,1088) THEN fto.[value] ELSE 0 END) * 100
    END,2) as decimal(18,2)) as varchar(20)) + '%' AS '% Percent Net GP',
    fto.sk_time,
    fto.sk_scenario,
    fto.sk_channel,
    fto.sk_entity
FROM 
    f_app1 fto 
    INNER JOIN d_channel_app1 channel ON fto.sk_channel = channel.sk_channel
    INNER JOIN d_entity_app1 brand ON fto.sk_entity = brand.sk_entity
WHERE 
    fto.sk_account IN (195,197,198,199,200,201,1048,1088,1054,1055,1273)
GROUP BY 
    channel.channel, 
    brand.entity,
    fto.sk_time,
    fto.sk_scenario,
    fto.sk_channel,
    fto.sk_entity;
GO


