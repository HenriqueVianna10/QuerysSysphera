USE [Sysphera]
GO
/****** Object:  Trigger [dbo].[trg_DT_headcount_promocao_transferencia]    Script Date: 15/06/2021 11:45:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =================================================================================
-- Author:		Cristiano Leite
-- Create date: 2020-09-08
-- Description:	Valida se a transferência ou promoção pode ser efetivada.
-- =================================================================================
ALTER TRIGGER [dbo].[trg_DT_headcount_promocao_transferencia]
   ON  [dbo].[DT_headcount_promocao_transferencia]
   AFTER insert, update
AS 
BEGIN
	SET NOCOUNT ON;

	declare @acao			as int = 0;
	declare @id				as int = 0;
	declare @ok				as int = 0;
	declare @reldim			as int = 0;
	declare @entidadePara	as int = 0;
	declare @ccPara			as int = 0;
	declare @funcao			as int = 0;
	declare @funcaoNova		as int = 0;
	declare @ccOrigem       as int = 0;
	declare @status			as nvarchar(500) = 'ERRO: Ação Inexistente';

--  select * from DT_headcount_promocao_transferencia
  
	select	@id				= i.identificador,
			@acao			= i.acao,
			@entidadePara	= isNull(i.entidade_para,0),
			@ccPara			= isNull(i.centro_de_custos_para,0),
			@funcaoNova		= isNull(i.funcao_nova,0),
			@funcao			= isNull(i.funcao,0),
			@ccOrigem       = isNull(i.centro_de_custos,0)
	from   inserted as i

	-- Promoção
	IF (@acao = 3)
	BEGIN
		IF (@funcaoNova > 0)
		BEGIN
			select @reldim = count(*)
			from   VW_DT_aux_reldim_funcao_x_cc as v
			where   @funcaoNova in (v.funcao)
			--and   v.funcao <> @funcaoNova

			IF (isNull(@reldim,0) > 0)
			BEGIN
				set @status = 'Promoção OK'
				set @ok = 1
			END
			ELSE

			BEGIN
				set @status = 'ERRO: Não Existe Esse Cargo Nesse Setor'
			END
	END

	ELSE
		BEGIN
			set @status = 'ERRO: Entidade e CC Para são obrigatórios na Promoção.'
		END
	END

	-- Transferência
	IF (@acao = 4)
	BEGIN
		IF (@entidadePara > 0) and (@ccPara > 0)
		BEGIN
			select @reldim = count(*)
			from   VW_DT_aux_reldim_funcao_x_cc as v
			where  v.centro_de_custos = @ccPara
			and    v.funcao = @funcao

			IF (isNull(@reldim,0) > 0)
			BEGIN
				set @status = 'Transferência OK'
				set @ok = 1
			END
			ELSE
			BEGIN
				set @status = 'ERRO: Função Inexistente no CC Para.' --+ cast(@reldim as nvarchar(10)) + '|' + cast(@ccPara as nvarchar(10))+ '|' + cast(@funcao as nvarchar(10))
			END
		END
		ELSE
		BEGIN
			set @status = 'ERRO: Entidade e CC Para são obrigatórios na Transferência.'
		END
	END

	update	DT_headcount_promocao_transferencia
	set		resultado = @status,
			ok = @ok
	where	identificador = @id

END


