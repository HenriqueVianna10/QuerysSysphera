delete D
from dt_etl_stag_dados_carga_realizado_app13 D
  join d_tempo_app13 T
  on d.ano = T.yearunique
  and d.periodo = MONTH(T.date)
where
  T.sk_tempo =   Instance(sk_tempo)   
;

insert into dt_etl_stag_dados_carga_realizado_app13
(cod_user, dat_update, Linha_CSV, Ano, Periodo, Cod_Conta, Cod_Cc, Vlr_Debito_Moeda, Vlr_Credito_Moeda, Vlr_Saldo, Lancamento_Desc, Pessoa_Desc, Documento_Id, sk_tempo)
select
  'ETL',
  getdate(),
  [1] as 'Linha_CSV',
  [2] AS 'Ano',
  [3] AS 'Periodo',
  [4] AS 'Cod_Conta',
  [5] AS 'Cod_Cc',
  [6] AS 'Vlr_Debito_Moeda',
  [7] AS 'Vlr_Credito_Moeda',
  [8] AS 'Vlr_Saldo',
  [9] AS 'Lancamento_Desc',
  [10] AS 'Pessoa_Desc',
  [11] AS 'Documento_Id',
  T.sk_tempo
from (
  select
    sk_tempo, id, value, ROW_NUMBER() OVER (PARTITION BY id ORDER BY (SELECT NULL)) AS rn
  from (
    select ltrim(ROW_NUMBER() OVER (ORDER BY (SELECT NULL))) + ';' + value id, dt.sk_tempo
    from
      dt_etl_stag_arquivo_carga_realizado_app13 dt
      CROSS APPLY string_split(cast(dt.arq_carga_realizado_csv AS VARCHAR(max)), CHAR(10)) l
    where
      l.value <> ''
      and dt.ds_log_carga_realizado is null
    ) Lin
    CROSS APPLY string_split(Lin.id, ';') C
  ) Col
  pivot(max(value) FOR RN IN (
    [1],[2],[3],[4],[5],[6],[7],[8],[9],[10], [11])
  ) AS pvt
  join d_tempo_app13 T
  on pvt.[2] = T.yearunique
  and pvt.[3] = MONTH(T.date)
where
  T.sk_tempo =   Instance(sk_tempo)   
;

update da 
set da.ds_log_carga_realizado
= (
 -- select *, (
select coalesce('Registros inseridos: ' + ltrim(count(*)), 'ERRO')
from DT_etl_stag_dados_carga_realizado_app13 d
  join d_tempo_app13 T
  on d.ano = T.yearunique
  and d.periodo = MONTH(T.date)
where
  T.sk_tempo = da.sk_tempo
)
from dt_etl_stag_arquivo_carga_realizado_app13 da
where
  da.sk_tempo =   Instance(sk_tempo)   
;
