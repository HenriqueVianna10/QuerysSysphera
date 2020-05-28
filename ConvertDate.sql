[cc lang=”sql”]
— Month first
SELECT CONVERT(varchar(12),GETDATE(), 101) — 06/29/2009
SELECT CONVERT(varchar(12),GETDATE(), 110) — 06-29-2009
SELECT CONVERT(varchar(12),GETDATE(), 100) — Jun 29 2009
SELECT CONVERT(varchar(12),GETDATE(), 107) — Jun 29, 2009

— Year first
SELECT CONVERT(varchar(12),GETDATE(), 102) — 2009.06.29
SELECT CONVERT(varchar(12),GETDATE(), 111) — 2009/06/29
SELECT CONVERT(varchar(12),GETDATE(), 112) — 20090629

— Day first
SELECT CONVERT(varchar(12),GETDATE(), 103) — 29/06/2009
SELECT CONVERT(varchar(12),GETDATE(), 105) — 29-06-2009
SELECT CONVERT(varchar(12),GETDATE(), 104) — 29.06.2009
SELECT CONVERT(varchar(12),GETDATE(), 106) — 29 Jun 2009

— Time only
SELECT CONVERT(varchar(12),GETDATE(), 108) — 07:26:16
SELECT CONVERT(varchar(12),GETDATE(), 114) — 07:27:11:203

— Date Only No Time (SQL 2008) [thank you John]
SELECT Cast(GetDate() AS date); — 08/12/2011
[/cc]