SELECT 'Admin' as cod_user, getdate() as dat_update, * 
--into ##temp
FROM  
 OPENJSON (
			(select 
				JsnResponse 
			 from 
				(select codDataLoadRest, 
						replace(JsnResponse, '{"total":2986,"items":', '')			as JsnResponse, 
						ROW_NUMBER() OVER(ORDER BY datExecuted desc)	as Row#  
				  from REP_DATALOAD_REST 
				  where codDataLoadRest = 5
				  and dschttpresponsecode = 'OK'
				 ) a
			 where a.row# = 1 )
		   )  
WITH(
anoProduto varchar(max) '$.anoProduto',
descOrdInv varchar(max) '$.descOrdInv',
codEstExec varchar(max) '$.codEstExec',
dtLiberacao varchar(max) '$.dtLiberacao',
valEstimado varchar(max) '$.valEstimado',
valNov varchar(max) '$.valNov',
dtRecepcao varchar(max) '$.dtRecepcao',
dtValidIni varchar(max) '$.dtValidIni',
codEstGestor varchar(max) '$.codEstGestor',
anoPrograma varchar(max) '$.anoPrograma',
situacao varchar(max) '$.situacao',
valOut varchar(max) '$.valOut',
descSecao varchar(max) '$.descSecao',
codEspecial varchar(max) '$.codEspecial',
valVerbaOrdem varchar(max) '$.valVerbaOrdem',
numOrdInvest varchar(max) '$.numOrdInvest',
dtPrevFim varchar(max) '$.dtPrevFim',
observacao varchar(max) '$.observacao',
codTipProj varchar(max) '$.codTipProj',
dtValidFim varchar(max) '$.dtValidFim',
codSubEspec varchar(max) '$.codSubEspec',
valSet varchar(max) '$.valSet',
numProj varchar(max) '$.numProj',
codCCResp varchar(max) '$.codCCResp',
valJan varchar(max) '$.valJan',
codProduto varchar(max) '$.codProduto',
dtPrevInst varchar(max) '$.dtPrevInst',
valMar varchar(max) '$.valMar',
codCContabTrans varchar(max) '$.codCContabTrans',
sugerePreco varchar(max) '$.sugerePreco',
codOrigemDesp varchar(max) '$.codOrigemDesp',
percRateio varchar(max) '$.percRateio',
valJun varchar(max) '$.valJun',
descProj varchar(max) '$.descProj',
valMai varchar(max) '$.valMai',
valJul varchar(max) '$.valJul',
numProjAnt varchar(max) '$.numProjAnt',
codCCBenef varchar(max) '$.codCCBenef',
valVerba varchar(max) '$.valVerba',
codDivisao varchar(max) '$.codDivisao',
percParticip varchar(max) '$.percParticip',
respOrdInv varchar(max) '$.respOrdInv',
codUnidNeg varchar(max) '$.codUnidNeg',
dtEmissaoFicha varchar(max) '$.dtEmissaoFicha',
codCategoria varchar(max) '$.codCategoria',
descRespProj varchar(max) '$.descRespProj',
valFev varchar(max) '$.valFev',
codCCProj varchar(max) '$.codCCProj',
percProduto varchar(max) '$.percProduto',
valAgo varchar(max) '$.valAgo',
sigla varchar(max) '$.sigla',
dtEmissaoVerba varchar(max) '$.dtEmissaoVerba',
dtPrevIni varchar(max) '$.dtPrevIni',
valAbr varchar(max) '$.valAbr',
codSCTrans varchar(max) '$.codSCTrans',
TRCPrev varchar(max) '$.TRCPrev',
idSysphera varchar(max) '$.idSysphera',
numProjNovo varchar(max) '$.numProjNovo'
)