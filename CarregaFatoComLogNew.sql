USE [copel_sysphera_dev]
GO
/****** Object:  StoredProcedure [dbo].[sp_carrega_fato_cons]    Script Date: 8/15/2024 7:07:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_carrega_fato_cons]
AS
BEGIN

    ---Henrique Vianna
	---2024-08-14
	---Limpa os dados da fato

    declare @rownum1 int;
	declare @msg1 varchar(max);
	

	BEGIN TRY

	insert into f_app5(sk_conta, sk_tempo, sk_cenario, sk_entidade, [value], cod_user, dat_update, type_update, hashData, sk_contrato, sk_operacao)

	select 176 as sk_conta,
		   sk_tempo,
		   2 as sk_cenario,
		   sk_entidade,
		   sum(valor_moeda_transacao) as [value],
		   'admin',
		   GETDATE(),
		   '6',
		   'CustoConstrucaoReal',
		   sk_contrato,
		   sk_operacao
		   from DT_get_movimentacao
	where sk_tempo = 142 and sk_contrato is not null
	group by sk_conta, sk_tempo, sk_cenario, sk_entidade, sk_contrato, sk_operacao

	set @rownum1 = @@ROWCOUNT
	
	set @msg1 = ''+ CAST(@rownum1 as varchar(max)) + ' Linhas Incluidas'

	exec sp_t6_etl_log_add @msg1, @grupo = 'sp_carrega_fato_cons', @tipo_processo = 2


	END TRY

    BEGIN CATCH
	    declare @errorCode int;
		declare @errorMessage nvarchar(max);
		select @errorCode = ERROR_NUMBER(), @errorMessage = ERROR_MESSAGE();
		declare @error nvarchar(max);
		declare @descricao_erro nvarchar(max);
		select @error = CAST(error_number() as VARCHAR(100)) + '::' + ERROR_MESSAGE();
		 set @descricao_erro = 'Erro no carregamento da fato ' + @error

        exec sp_t6_etl_log_add @descricao_erro, @grupo = 'sp_carrega_fato_cons', @tipo_processo = 2, @tipo = 'A';
	 
        THROW;
    END CATCH


END