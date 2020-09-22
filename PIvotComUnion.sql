
--Insere Valores dos Investimento no Capex Conselho

insert into f_app10(sk_conta, sk_tempo, sk_cenario, sk_entidade, sk_projeto, sk_categoria, sk_consolidacao, value, cod_user, dat_update, type_update)
select 1, valores.sk_tempo, valores.cenario, valores.entidade, valores.dimensao_projeto, valores.categoria, 9, valores.value, 'etl', GETDATE(), 6
from (
--Janeiro
SELECT p.identificador,p.categoria, p.dimensao_projeto, temp.sk_tempo, p.entidade, p.cenario, p.codigo, a.ano, Sum(v.jan) as value
FROM DT_investimento AS p INNER JOIN DT_valores_do_investimento AS v ON v.identificador = p.identificador
INNER JOIN DT_ano AS a ON v.ano = a.identificador
INNER JOIN d_tempo_app10 as temp on a.ano = temp.tempo_l0 and temp.shortMonthName = 'Jan'
where p.[status] = 7 and ISNULL(jan,0) <> 0 --AND --p.codigo IS NOT NULL 
group by p.identificador,p.categoria, p.dimensao_projeto, temp.sk_tempo, p.entidade, p.cenario, p.codigo, a.ano
union all
--Fevereiro
SELECT p.identificador, p.categoria, p.dimensao_projeto, temp.sk_tempo, p.entidade, p.cenario, p.codigo, a.ano, Sum(v.fev) as value
FROM DT_investimento AS p INNER JOIN DT_valores_do_investimento AS v ON v.identificador = p.identificador
INNER JOIN DT_ano AS a ON v.ano = a.identificador
INNER JOIN d_tempo_app10 as temp on a.ano = temp.tempo_l0 and temp.shortMonthName = 'Fev'
where p.[status] = 7 and ISNULL(fev,0) <> 0 --AND --p.codigo IS NOT NULL 
group by p.identificador,p.categoria, p.dimensao_projeto, temp.sk_tempo, p.entidade, p.cenario, p.codigo, a.ano
union all
--Março
SELECT p.identificador,p.categoria, p.dimensao_projeto, temp.sk_tempo, p.entidade, p.cenario, p.codigo, a.ano, Sum(v.mar) as value
FROM DT_investimento AS p INNER JOIN DT_valores_do_investimento AS v ON v.identificador = p.identificador
INNER JOIN DT_ano AS a ON v.ano = a.identificador
INNER JOIN d_tempo_app10 as temp on a.ano = temp.tempo_l0 and temp.shortMonthName = 'Mar'
where p.[status] = 7 and ISNULL(mar,0) <> 0 --AND --p.codigo IS NOT NULL 
group by p.identificador,p.categoria, p.dimensao_projeto, temp.sk_tempo, p.entidade, p.cenario, p.codigo, a.ano
union all
--Abril
SELECT p.identificador,p.categoria, p.dimensao_projeto, temp.sk_tempo, p.entidade, p.cenario, p.codigo, a.ano, Sum(v.abr) as value
FROM DT_investimento AS p INNER JOIN DT_valores_do_investimento AS v ON v.identificador = p.identificador
INNER JOIN DT_ano AS a ON v.ano = a.identificador
INNER JOIN d_tempo_app10 as temp on a.ano = temp.tempo_l0 and temp.shortMonthName = 'Abr'
where p.[status] = 7 and ISNULL(abr,0) <> 0 --AND --p.codigo IS NOT NULL 
group by p.identificador,p.categoria, p.dimensao_projeto, temp.sk_tempo, p.entidade, p.cenario, p.codigo, a.ano
union all
--Maio
SELECT p.identificador,p.categoria, p.dimensao_projeto, temp.sk_tempo, p.entidade, p.cenario, p.codigo, a.ano, Sum(v.mai) as value
FROM DT_investimento AS p INNER JOIN DT_valores_do_investimento AS v ON v.identificador = p.identificador
INNER JOIN DT_ano AS a ON v.ano = a.identificador
INNER JOIN d_tempo_app10 as temp on a.ano = temp.tempo_l0 and temp.shortMonthName = 'Mai'
where p.[status] = 7 and ISNULL(mai,0) <> 0 --AND --p.codigo IS NOT NULL 
group by p.identificador,p.categoria, p.dimensao_projeto, temp.sk_tempo, p.entidade, p.cenario, p.codigo, a.ano
union all
--Junho
SELECT p.identificador,p.categoria, p.dimensao_projeto, temp.sk_tempo, p.entidade, p.cenario, p.codigo, a.ano, Sum(v.jun) as value
FROM DT_investimento AS p INNER JOIN DT_valores_do_investimento AS v ON v.identificador = p.identificador
INNER JOIN DT_ano AS a ON v.ano = a.identificador
INNER JOIN d_tempo_app10 as temp on a.ano = temp.tempo_l0 and temp.shortMonthName = 'Jun'
where p.[status] = 7 and ISNULL(jun,0) <> 0 --AND --p.codigo IS NOT NULL 
group by p.identificador,p.categoria, p.dimensao_projeto, temp.sk_tempo, p.entidade, p.cenario, p.codigo, a.ano
union all
--Julho
SELECT p.identificador,p.categoria, p.dimensao_projeto, temp.sk_tempo, p.entidade, p.cenario, p.codigo, a.ano, Sum(v.jul) as value
FROM DT_investimento AS p INNER JOIN DT_valores_do_investimento AS v ON v.identificador = p.identificador
INNER JOIN DT_ano AS a ON v.ano = a.identificador
INNER JOIN d_tempo_app10 as temp on a.ano = temp.tempo_l0 and temp.shortMonthName = 'Jul'
where p.[status] = 7 and ISNULL(jul,0) <> 0 --AND --p.codigo IS NOT NULL 
group by p.identificador,p.categoria, p.dimensao_projeto, temp.sk_tempo, p.entidade, p.cenario, p.codigo, a.ano
union all
--Agosto
SELECT p.identificador,p.categoria, p.dimensao_projeto, temp.sk_tempo, p.entidade, p.cenario, p.codigo, a.ano, Sum(v.ago) as value
FROM DT_investimento AS p INNER JOIN DT_valores_do_investimento AS v ON v.identificador = p.identificador
INNER JOIN DT_ano AS a ON v.ano = a.identificador
INNER JOIN d_tempo_app10 as temp on a.ano = temp.tempo_l0 and temp.shortMonthName = 'Ago'
where p.[status] = 7 and ISNULL(ago,0) <> 0 --AND --p.codigo IS NOT NULL 
group by p.identificador,p.categoria, p.dimensao_projeto, temp.sk_tempo, p.entidade, p.cenario, p.codigo, a.ano
union all
--Setembro
SELECT p.identificador,p.categoria, p.dimensao_projeto, temp.sk_tempo, p.entidade, p.cenario, p.codigo, a.ano, Sum(v.set_) as value
FROM DT_investimento AS p INNER JOIN DT_valores_do_investimento AS v ON v.identificador = p.identificador
INNER JOIN DT_ano AS a ON v.ano = a.identificador
INNER JOIN d_tempo_app10 as temp on a.ano = temp.tempo_l0 and temp.shortMonthName = 'Set'
where p.[status] = 7 and ISNULL(set_,0) <> 0 --AND --p.codigo IS NOT NULL 
group by p.identificador,p.categoria, p.dimensao_projeto, temp.sk_tempo, p.entidade, p.cenario, p.codigo, a.ano
union all
--Outubro
SELECT p.identificador,p.categoria, p.dimensao_projeto, temp.sk_tempo, p.entidade, p.cenario, p.codigo, a.ano, Sum(v.out) as value
FROM DT_investimento AS p INNER JOIN DT_valores_do_investimento AS v ON v.identificador = p.identificador
INNER JOIN DT_ano AS a ON v.ano = a.identificador
INNER JOIN d_tempo_app10 as temp on a.ano = temp.tempo_l0 and temp.shortMonthName = 'Out'
where p.[status] = 7 and ISNULL(out,0) <> 0 --AND --p.codigo IS NOT NULL 
group by p.identificador,p.categoria, p.dimensao_projeto, temp.sk_tempo, p.entidade, p.cenario, p.codigo, a.ano
union all
--Novembro
SELECT p.identificador,p.categoria, p.dimensao_projeto, temp.sk_tempo, p.entidade, p.cenario, p.codigo, a.ano, Sum(v.nov) as value
FROM DT_investimento AS p INNER JOIN DT_valores_do_investimento AS v ON v.identificador = p.identificador
INNER JOIN DT_ano AS a ON v.ano = a.identificador
INNER JOIN d_tempo_app10 as temp on a.ano = temp.tempo_l0 and temp.shortMonthName = 'Nov'
where p.[status] = 7 and ISNULL(nov,0) <> 0 --AND --p.codigo IS NOT NULL 
group by p.identificador,p.categoria, p.dimensao_projeto, temp.sk_tempo, p.entidade, p.cenario, p.codigo, a.ano
union all
--Dezembro
SELECT p.identificador,p.categoria, p.dimensao_projeto, temp.sk_tempo, p.entidade, p.cenario, p.codigo, a.ano, Sum(v.dez) as value
FROM DT_investimento AS p INNER JOIN DT_valores_do_investimento AS v ON v.identificador = p.identificador
INNER JOIN DT_ano AS a ON v.ano = a.identificador
INNER JOIN d_tempo_app10 as temp on a.ano = temp.tempo_l0 and temp.shortMonthName = 'Dez'
where p.[status] = 7 and ISNULL(dez,0) <> 0 --AND --p.codigo IS NOT NULL 
group by p.identificador,p.categoria, p.dimensao_projeto, temp.sk_tempo, p.entidade, p.cenario, p.codigo, a.ano) as valores