---DataLoadParameter([CAPEX].[Cenário Destino ETL]) = Instance(Cenário Destino ETL);

--Busca Cenário Destino ETL
select cast(dscValue as int) as cenario from REP_LOADPARAMETER where codLoadParameter = 18

--Insere Novos Investimentos

insert into d_projeto_app10 (codigo_projeto, projeto, descricao_projeto, nome_ingles, tipo, grupo_de_coordenador, coordenador, aquisicao, flgBelongs)
SELECT 
	   dbo.FN_ReplaceASCII(p.codigo) as codigo, 
       dbo.FN_ReplaceASCII(p.codigo) + ' - ' + dbo.FN_ReplaceASCII(p.nome) as nome, 
       dbo.FN_ReplaceASCII(p.descricao) as descricao, 
       dbo.FN_ReplaceASCII(p.nome_en) as nome_en, 
	   dbo.FN_ReplaceASCII(t.tipo) as tipo, 
	   dbo.FN_ReplaceASCII(gp.nome) as grupo_coordenador, 
       dbo.FN_ReplaceASCII(coordenador) AS coordenador, 
		case
			when aquisicao = 1 then 'Sim'
			when aquisicao = 2 then 'Não'
			else ''
		end aquisicao,
	CAST(1 AS BIT) AS flgBelongs
FROM DT_investimento AS p INNER JOIN
	 DT_tipo_de_projeto AS t ON p.aquisicao = t.identificador LEFT JOIN
	 DT_grupo_de_coordenador gp WITH(NOLOCK) ON(ISNULL(p.grupo_de_coordenador,4)=gp.identificador)
where p.codigo IS NOT NULL and p.status = 7 and p.dimensao_projeto IS NULL and codigo <> ''

--Atualiza Campo Dimensão Projeto
update DT_investimento
set dimensao_projeto = (select sk_projeto from d_projeto_app10 where codigo_interno = DT_investimento.codigo and DT_investimento.codigo <> '')
where (dimensao_projeto is null) and codigo is not null 

--Atualiza Relacionamento de Dimensão
insert into REP_DIMENSIONRELATIONSHIP_MEMBERS
select distinct 35 as codDimensionRelationship, entidade as codMemberDimensionA, sk_projeto as codMemberDimensionB from DT_investimento p inner join d_projeto_app10 dp
on (p.codigo = dp.codigo_projeto)
WHERE sk_projeto NOT IN(SELECT sk_projeto FROM dbo.REP_DIMENSIONRELATIONSHIP_MEMBERS WITH(NOLOCK) WHERE codDimensionRelationship=35 AND codMemberDimensionA=p.entidade AND codMemberDimensionB=dp.sk_projeto)
AND status IN (2, 7) -- Em Andamento ou Aprovado

union all

select distinct 36 as codDimensionRelationship, categoria as codMemberDimensionA, sk_projeto as codMemberDimensionB from DT_investimento p inner join d_projeto_app10 dp
on (p.codigo = dp.codigo_projeto)
WHERE sk_projeto NOT IN (SELECT sk_projeto FROM dbo.REP_DIMENSIONRELATIONSHIP_MEMBERS WITH(NOLOCK) WHERE codDimensionRelationship=36 AND codMemberDimensionA=p.categoria AND codMemberDimensionB=dp.sk_projeto)
AND status IN (2, 7) -- Em Andamento ou Aprovado


