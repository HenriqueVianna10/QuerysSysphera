USE [copel_sysphera_dev]
GO
/****** Object:  StoredProcedure [dbo].[sp_limpa_fato_cons]    Script Date: 8/15/2024 7:05:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[sp_limpa_fato_cons]
AS
BEGIN

    ---Henrique Vianna
	---2024-08-14
	---Limpa os dados da fato

    declare @rownum1 int;
	declare @msg1 varchar(max);
	

	BEGIN TRY

	delete fto 
	from 
	f_app5 fto
	inner join f_app5_scenario sce on (sce.sk_cenario = (select distinct sk_cenario from DT_etl_tmp_get_movimentacao) and fto.sk_tempo = sce.sk_tempo)
	where fto.sk_tempo in (select distinct sk_tempo from DT_etl_tmp_get_movimentacao) and sce.value <> 2
	and hashData = 'CustoConstrucaoReal'

	set @rownum1 = @@ROWCOUNT
	
	set @msg1 = ''+ CAST(@rownum1 as varchar(max)) + ' Linhas Deletadas '

	exec sp_t6_etl_log_add @msg1, @grupo = 'sp_limpa_fato_cons', @tipo_processo = 2


	END TRY

    BEGIN CATCH
	    declare @errorCode int;
		declare @errorMessage nvarchar(max);
		declare @error nvarchar(max);
		declare @descricao_erro nvarchar(max);

		select @errorCode = ERROR_NUMBER(), @errorMessage = ERROR_MESSAGE();
		select @error = CAST(error_number() as VARCHAR(100)) + '::' + ERROR_MESSAGE();
		 set @descricao_erro = 'Erro na limpeza da fato ' + @error

        exec sp_t6_etl_log_add @descricao_erro, @grupo = 'sp_limpa_fato_cons', @tipo_processo = 2, @tipo = 'E';
	 
        THROW;
    END CATCH


END









