--Distinct quando o dsFilial não existe no dsregional, ai ele pega o regional


select distinct IIF(len(isnull(ds_filial,'')) <=1,ds_regional,ds_filial) as ds_filial FROM d_entidade_app1
WHERE entidade IN (@paramRegional)