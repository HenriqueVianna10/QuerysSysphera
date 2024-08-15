USE [copel_sysphera_dev]
GO
/****** Object:  StoredProcedure [dbo].[sp_t6_etl_log_add]    Script Date: 8/15/2024 6:33:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_t6_etl_log_add]
	@mensagem_erro	nvarchar(max) = NULL,   ---@mensagem_erro: a mensagem principal
	@grupo			nvarchar(500) = 'LOG',  ---@grupo: agrupa as mensagens. Quando não informado, fica fixo LOG
	@tipo			nvarchar(500) = 'I',    ---@tipo: o default é 'I' de Informação. Pode ser alterado para 'A' de Alerta, com fundo amarelo ou 'E' de Erro com o fundo vermelho.
	@usuario		nvarchar(500) = 'hvianna',  ---@usuario: inclui o usuário que adicionou o registro. Por default entra o usuario geral chamado 'etl'
	@tipo_processo	int  = NULL,			---@tipo_processo: é o ID da tabela auxiliar do Tipo Processo.
	@acao			nvarchar(500) = '',		---@acao: é uma URL que vai ficar sobre o status. Pode ser adicionado em qualquer um dos tipos (I, A ou E).
	@id_instancia	int = 0					---@id_instancia: usado para armazenar o ID da instância do processo para algum vínculo futuro.
AS
BEGIN
  SET NOCOUNT ON;

	insert into DT_t6_etl_log (cod_user, dat_update, data_e_hora, grupo, descricao_, tipo, usuario, acao, id_tipo_processo)
	values (@usuario,
		DATEADD(hour,-3,getdate()),
		convert(varchar(50),DATEADD(hour,-3,getdate()),120),
		@grupo,
		@mensagem_erro,
		@tipo,
		@usuario,
		@acao,
		@tipo_processo)

  -- select * from DT_t6_etl_log
  -- truncate table DT_t6_etl_log
  -- exec sp_t6_etl_log_add 'Mensagem', @tipo_processo = 1
  -- exec sp_t6_etl_log_add @id_instancia = 356565, @tipo = 'I', @grupo = 'Atualiza Stages',  @mensagem_erro = 'Violated Primary Key'
END

