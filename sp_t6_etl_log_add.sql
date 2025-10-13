
ALTER PROCEDURE [dbo].[sp_t6_etl_log_add]
	@mensagem_erro	nvarchar(max) = NULL,   ---@mensagem_erro: a mensagem principal
	@grupo			nvarchar(500) = 'LOG',  ---@grupo: agrupa as mensagens. Quando não informado, fica fixo LOG
	@tipo			nvarchar(500) = 'I',    ---@tipo: o default é 'I' de Informação. Pode ser alterado para 'A' de Alerta, com fundo amarelo ou 'E' de Erro com o fundo vermelho.
	@usuario		nvarchar(500) = 'admin',  ---@usuario: inclui o usuário que adicionou o registro. Por default entra o usuario geral chamado 'etl'
	@tipo_processo	int  = NULL,			---@tipo_processo: é o ID da tabela auxiliar do Tipo Processo.
	@acao			nvarchar(500) = '',		---@acao: é uma URL que vai ficar sobre o status. Pode ser adicionado em qualquer um dos tipos (I, A ou E).
	@id_instancia	int = 0,				---@id_instancia: usado para armazenar o ID da instância do processo para algum vínculo futuro.
	@tipoLink	nvarchar(1) = ''
AS
BEGIN
  SET NOCOUNT ON;

	insert into DT_t6_etl_log (cod_user, dat_update, data_e_hora, grupo, descricao_, tipo, usuario, acao, id_tipo_processo, tipo_link)
	values (@usuario,
		DATEADD(hour,-3,getdate()),
		convert(varchar(50),DATEADD(hour,-3,getdate()),120),
		@grupo,
		@mensagem_erro,
		@tipo,
		@usuario,
		@acao,
		@tipo_processo,
		@tipoLink)


END

