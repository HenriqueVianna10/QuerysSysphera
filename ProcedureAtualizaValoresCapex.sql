Create Procedure [dbo].[SP_Capex_Revisao_Atualiza_Valores]

--Variavéis de entrada 
(
  @ID_Investimento int,
  @ID_instancia int,
  @ID_cenario int
)
as
begin

declare 
	@l_i_dimensao_projeto int,
    @instancia int, 
    @l_i_cenario int,
	@instance_responsavel varchar(30)
	
 --carrega variavéis
  set @l_i_dimensao_projeto = @ID_Investimento
  set @instancia = @ID_instancia
  set @l_i_cenario = @ID_cenario 

 --Traz Código da instância e nome do responsável
   select @instance_responsavel=codUserStart from REP_WORKFLOW_INSTANCE_HISTORY where codInstance = @instancia and flgAction = 1


-- Apaga os valores concluidos(não utilizado)
            DELETE dbo.f_app10
            WHERE sk_cenario=@l_i_cenario
            AND sk_conta=1
            AND sk_projeto=@l_i_dimensao_projeto
            AND sk_consolidacao=19 -- Concluído(Não Utilizado)
           
            -- Insere os valores não utilizados
            INSERT dbo.f_app10(sk_conta, sk_tempo, sk_cenario, sk_entidade, sk_projeto, sk_categoria,sk_consolidacao,value,cod_user,dat_update,type_update)
            SELECT sk_conta, sk_tempo, sk_cenario, sk_entidade, sk_projeto, sk_categoria, 19 AS sk_consolidacao, value, @instance_responsavel AS  cod_user, GETDATE() AS dat_update,'1' AS type_update
            FROM  dbo.f_app10 WITH(NOLOCK)
            WHERE sk_cenario=@l_i_cenario
            AND sk_conta=1
            AND sk_projeto=@l_i_dimensao_projeto
            AND sk_consolidacao=4 -- Projetado
           
            -- Apaga os valores projetados não utilizado
            DELETE dbo.f_app10
            WHERE sk_cenario=@l_i_cenario
            AND sk_conta=1
            AND sk_projeto=@l_i_dimensao_projeto
            AND sk_consolidacao=4 -- Projetado
End
GO