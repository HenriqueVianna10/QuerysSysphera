USE [copel_sysphera_dev]
GO
/****** Object:  StoredProcedure [dbo].[sp_carrega_fato_cons]    Script Date: 8/15/2024 7:07:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_carrega_fato_cons]
(@id_instancia int)
AS
BEGIN

    ---Henrique Vianna
	---2024-08-14
	---Limpa os dados da fato

    declare @rownum1 int;
	declare @msg1 varchar(max);
	  declare @usuario nvarchar(40);


    select @usuario = usuario from VW_DT_wkf_aux_user_instance_start
	where identificador = @id_instancia

	select @usuario = ISNULL(@usuario,'admin')

	

	BEGIN TRY

	insert into f_app5(sk_conta, sk_tempo, sk_cenario, sk_entidade, [value], cod_user, dat_update, type_update, hashData, sk_contrato, sk_operacao)

	select 176 as sk_conta,
		   sk_tempo,
		   2 as sk_cenario,
		   sk_entidade,
		   sum(valor_moeda_transacao) as [value],
		   @usuario,
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
	     
	    SELECT @erro = CAST(ERROR_NUMBER() AS VARCHAR(100)) + '::' + ERRO_MESSAGE()
        set @descricao_erro = @ERRO 
        exec sp_t6_etl_log_add  @descricao_erro, @grupo = 'Carregamento Tabela de Construção', @tipo_processo = 2, @tipo = 'E';
        RAISERROR(@ERRO,18,2)
    END CATCH
	
END