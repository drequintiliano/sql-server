DECLARE   
	@EMPRESA_CONTABIL NUMERIC(10),  
	@MOVIMENTO_INICIAL DATE,  
	@MOVIMENTO_FINAL   DATE,  
	@SQL NVARCHAR(MAX), 
	@SQL_DESPESAS NVARCHAR(MAX),
	@SQL_LISTA_DESPESAS NVARCHAR(MAX),
	@SQLFILTRO  NVARCHAR(MAX) = '';
     

SET @EMPRESA_CONTABIL  = 106;  
SET @MOVIMENTO_INICIAL = '30/01/2019';                              
SET @MOVIMENTO_FINAL   = '30/01/2019';   
     
     
       
IF @MOVIMENTO_INICIAL  IS NOT NULL 
	SET  @SQLFILTRO = @SQLFILTRO +'(A.recdatmov  BETWEEN '''''+FARMAPONTE.UDF_FORMATA_DATA(@MOVIMENTO_INICIAL,1,'/')+''''' and '''''
									+FARMAPONTE.UDF_FORMATA_DATA(@MOVIMENTO_FINAL,1,'/') +''''')'


IF OBJECT_ID('TEMPDB..#TEMP_DESPESAS' ) 
IS NOT NULL DROP TABLE #TEMP_DESPESAS

IF OBJECT_ID('TEMPDB..#TEMP_LISTA_DESPESAS' ) 
IS NOT NULL DROP TABLE #TEMP_LISTA_DESPESAS
     
IF OBJECT_ID('TEMPDB..##TEMP') IS NOT NULL                                        
DROP TABLE ##TEMP  
     
IF OBJECT_ID('TEMPDB..#FECHAMENTO_CAIXA') IS NOT NULL  
DROP TABLE #FECHAMENTO_CAIXA  
     
IF OBJECT_ID('TEMPDB..#FECHAMENTO_CAIXA_RECEBIMENTOS') IS NOT NULL  
DROP TABLE #FECHAMENTO_CAIXA_RECEBIMENTOS  

IF OBJECT_ID('TEMPDB..#COMISSAO_OPERADORA') IS NOT NULL
DROP TABLE #COMISSAO_OPERADORA;
   
   /* COMO NA TABELA NAO TEM UMA IDENTIFICACAO POR CODIGO DE OPERADORA NAO CRIEI UMA TABELA */
   CREATE TABLE #COMISSAO_OPERADORA
   (
      OPERADORA NUMERIC,
      DESCRICAO VARCHAR(200),
      COMISSAO NUMERIC(9,2) 
   ) 
   
   INSERT INTO #COMISSAO_OPERADORA
   (
      OPERADORA,
      DESCRICAO,
      COMISSAO
   )
   SELECT 1,'VIVO',4 union all 
   SELECT 2,'TIM',4  union all 
   SELECT 3,'OI',4.5   UNION ALL
   SELECT 4,'CLARO',4.5   UNION ALL
   SELECT 5,'NEXTEL',6.5 

   SELECT   
      A.*,  
      B.ABERTURA,  
      C.EMPRESA_CONTABIL,  
      A.EMPRESA AS EMPRESA_ORIGINAL  
   INTO   
      #FECHAMENTO_CAIXA  
   FROM  
      FECHAMENTOS_CAIXAS A WITH(NOLOCK)  
   LEFT JOIN   
      ABERTURAS_CAIXAS   B WITH(NOLOCK)  ON B.ABERTURA_CAIXA  = A.ABERTURA_CAIXA     
   LEFT JOIN  
      EMPRESAS_USUARIAS  C WITH(NOLOCK)  ON C.EMPRESA_USUARIA = A.EMPRESA  
   WHERE   
      C.EMPRESA_CONTABIL = @EMPRESA_CONTABIL AND   
      A.MOVIMENTO BETWEEN (@MOVIMENTO_INICIAL) AND (@MOVIMENTO_FINAL)     
      --and a.fechamento_caixa  = 797460 --teste
     
   UNION ALL   
     
   SELECT   
      A.FECHAMENTO_CAIXA                 ,   
      A.FORMULARIO_ORIGEM                ,   
      A.TAB_MASTER_ORIGEM                ,   
      A.REG_MASTER_ORIGEM                ,   
      A.REG_LOG_INCLUSAO                 ,   
      A.DATA_HORA                        ,   
      A.USUARIO_LOGADO                   ,   
      CASE   
         WHEN (A.EMPRESA = 110) THEN 145  
         WHEN (A.EMPRESA = 121) THEN 138  
         WHEN (A.EMPRESA = 122) THEN 139  
         WHEN (A.EMPRESA = 124) THEN 146  
         WHEN (A.EMPRESA = 127) THEN 137  
         WHEN (A.EMPRESA = 116) THEN 141  
         WHEN (A.EMPRESA = 117) THEN 140  
         WHEN (A.EMPRESA = 123) THEN 142  
         WHEN (A.EMPRESA = 125) THEN 143  
         WHEN (A.EMPRESA = 129) THEN 144  
      END AS EMPRESA                     ,  
      A.CAIXA_LOJA                       ,   
      A.OPERADOR                         ,   
      A.MOVIMENTO                        ,   
      A.TROCO_INICIAL_CONTADO            ,   
      A.ENTRADA_TOTAL_VENDAS             ,   
      A.ENTRADA_TOTAL_RECEBIMENTOS       ,   
      A.ENTRADA_TOTAL                    ,   
      A.ENTRADA_ADIANTAMENTO             ,   
      A.ENTRADA_VALOR_VALE_PRESENTE      ,   
      A.ENTRADA_DINHEIRO                 ,   
      A.ENTRADA_CHEQUE                   ,   
      A.ENTRADA_CARTAO_DEBITO            ,   
      A.ENTRADA_PREDATADO                ,   
      A.ENTRADA_CARTAO_CREDITO           ,   
      A.ENTRADA_BOLETO                   ,   
      A.ENTRADA_FIADO                    ,   
      A.ENTRADA_FINANCIAMENTO            ,   
      A.ENTRADA_CONVENIO_EMPRESA         ,   
      A.ENTRADA_VALE_CREDITO             ,   
      A.ENTRADA_CANCELAMENTO             ,   
      A.SUPRIMENTO                       ,   
      A.VALOR_TOTAL_DEVOLUCAO            ,   
      A.DESPESA                          ,   
      A.SANGRIA_DINHEIRO                 ,   
      A.SANGRIA_CHEQUE                   ,   
      A.SANGRIA_PREDATADO            ,   
      A.TOTAL_CANCELAMENTO               ,   
      A.ASSALTO_DINHEIRO                 ,   
      A.ASSALTO_CHEQUE                   ,   
      A.ASSALTO_PREDATADO                ,   
      A.TROCO_PROXIMO_CAIXA              ,   
      A.FINAL_DINHEIRO                   ,   
      A.FINAL_CHEQUE                     ,   
      A.FINAL_PREDATADO                  ,   
      A.VALE_ETIQUETA                    ,   
      A.VALE_DIFERENCA                   ,   
      A.CONTAGEM_ADIANTAMENTO            ,   
      A.CONTAGEM_VALOR_VALE_PRESENTE     ,   
      A.CONTAGEM_DINHEIRO                ,   
      A.CONTAGEM_CHEQUE                  ,   
      A.CONTAGEM_CARTAO_DEBITO           ,   
      A.CONTAGEM_PREDATADO               ,   
      A.CONTAGEM_CARTAO_CREDITO          ,   
      A.CONTAGEM_BOLETO                  ,   
      A.CONTAGEM_FIADO                   ,   
      A.CONTAGEM_FINANCIAMENTO           ,   
      A.CONTAGEM_CONVENIO_EMPRESA        ,   
      A.CONTAGEM_VALE_ETIQUETA           ,   
      A.CONTAGEM_VALE_CREDITO            ,   
      A.DIFERENCA_ADIANTAMENTO           ,   
      A.DIFERENCA_VALOR_VALE_PRESENTE    ,   
      A.DIFERENCA_DINHEIRO               ,   
      A.DIFERENCA_CHEQUE                 ,   
      A.DIFERENCA_CARTAO_DEBITO          ,   
      A.DIFERENCA_PREDATADO              ,   
      A.DIFERENCA_CARTAO_CREDITO         ,   
      A.DIFERENCA_BOLETO                 ,   
      A.DIFERENCA_FIADO                  ,   
      A.DIFERENCA_FINANCIAMENTO          ,   
      A.DIFERENCA_CONVENIO_EMPRESA       ,   
      A.DIFERENCA_CANCELAMENTO           ,   
      A.DIFERENCA_VALE_ETIQUETA          ,   
      A.DIFERENCA_VALE_CREDITO           ,   
      A.ABERTURA_CAIXA                   ,   
      A.SOBRA_CAIXA                      ,   
      A.ENTRADA_TELEVENDA                ,   
      A.ENTRADA_TELEVENDA_SALDO          ,   
      A.TIPO                             ,   
      A.VALE_FUNCIONARIO                 ,   
      A.REPASSE_FPOPULAR                 ,   
      A.ADM_CONV_EXTERNO                 ,   
      B.ABERTURA                         ,  
      106 AS EMPRESA_CONTABIL            ,  
      A.EMPRESA AS EMPRESA_ORIGINAL  
   FROM  
      FECHAMENTOS_CAIXAS A WITH(NOLOCK)  
   LEFT JOIN   
      ABERTURAS_CAIXAS   B WITH(NOLOCK)  ON B.ABERTURA_CAIXA  = A.ABERTURA_CAIXA     
   LEFT JOIN  
      EMPRESAS_USUARIAS  C WITH(NOLOCK)  ON C.EMPRESA_USUARIA = A.EMPRESA  
   WHERE   
      @EMPRESA_CONTABIL = 106 and --- Se estiver contabilizando a empresa 106, que é a nova matriz incorporadora  
      (  
         ((@MOVIMENTO_INICIAL <= '19/10/2017' or (@MOVIMENTO_INICIAL > '19/10/2017' and @MOVIMENTO_INICIAL <= '31/10/2017')) AND (@MOVIMENTO_FINAL >= '19/10/2017') )  --- SE entre os períodos inicial e final da contabilizacao ocorrer o período indicado  
           
      ) and   
      C.EMPRESA_CONTABIL in (110,127,117)    AND  --- Se existir registro para esas matrizes  
      A.MOVIMENTO BETWEEN ('19/10/2017') AND ('31/10/2017') --- se os registros existentes forem dentro do período indicado   
       --and a.fechamento_caixa  = 797460 --teste 
     
   --- ALT.240118-001 - REMOVENDO REGISTROS DAS EMPRESAS ANTIGAS APÓS DATA DA INCORPORACAO  
   DELETE A FROM #FECHAMENTO_CAIXA A WHERE EMPRESA_CONTABIL IN (110,127,117) AND MOVIMENTO BETWEEN ('19/10/2017') AND ('31/10/2017');   
    
   SET @SQL = 'SELECT   
                  cartipcar,  
                  carnomcar,  
                  cartiplanc,  
                  recrec001,  
                  tipo_procfit,  
                  tipo_agrupamento_procfit  
                into ##temp  
               FROM   
                  OPENQUERY  
                  (     
                     PostgreSQL05,  
                      ''select * from public.tb_tippag''  
                  )';  
          
   EXECUTE sp_executesql @SQL;  
     
   SELECT  
      EMPRESA_CONTABIL,  
      MOVIMENTO,  
      RECREC001,  
      FORMULARIO_ORIGEM,  
      TAB_MASTER_ORIGEM,  
      REG_MASTER_ORIGEM,  
      FECHAMENTO_CAIXA,  
      EMPRESA,   
      CAIXA_LOJA,                                                       
      ABERTURA_CAIXA,  
      SUM(VALOR_RECARGA) AS VALOR_RECARGA,  
      SUM(VALOR_RECEBIMENTO) AS VALOR_RECEBIMENTO,  
      TIPO_AGRUPAMENTO_PROCFIT                    AS TIPO_AGRUPAMENTO_PROCFIT  
   INTO #FECHAMENTO_CAIXA_RECEBIMENTOS  
   FROM   
   (  
      SELECT   
         A.FORMULARIO_ORIGEM                           AS FORMULARIO_ORIGEM,  
         A.TAB_MASTER_ORIGEM                           AS TAB_MASTER_ORIGEM,  
         A.FECHAMENTO_CAIXA                            AS REG_MASTER_ORIGEM,  
         A.EMPRESA_CONTABIL                            AS EMPRESA_CONTABIL,  
         A.MOVIMENTO                                   AS MOVIMENTO,  
         ---b.RECEBIMENTO_FINALIZADORA                    AS REG_MASTER_ORIGEM,  
         ISNULL(ISNULL(B.CARTIPLANC,E.RECREC001),1)    AS RECREC001,  
         A.FECHAMENTO_CAIXA                            AS FECHAMENTO_CAIXA,  
         A.EMPRESA                                     AS EMPRESA,   
         A.CAIXA_LOJA                                  AS CAIXA_LOJA,  
         A.ABERTURA_CAIXA                              AS ABERTURA_CAIXA,  
         0                                             AS VALOR_RECARGA,  
         ISNULL(B.VALOR,0)-ISNULL(B.TROCO,0)           AS VALOR_RECEBIMENTO,  
         F.TIPO_AGRUPAMENTO_PROCFIT                    AS TIPO_AGRUPAMENTO_PROCFIT  
      FROM   
         #FECHAMENTO_CAIXA              A WITH(NOLOCK)    
      LEFT JOIN      
         PDV_RECEBIMENTOS_FINALIZADORAS B WITH(NOLOCK)  ON B.LOJA       =  A.EMPRESA     
                                                       AND B.CAIXA      =  A.CAIXA_LOJA   
                                                       ---AND A.MOVIMENTO  BETWEEN (B.MOVIMENTO) AND (  DATEADD( DAY,1, B.MOVIMENTO   ) )  
                                                       AND A.MOVIMENTO  = B.MOVIMENTO  
                                                       ---AND B.ABERTURA   =  ISNULL(A.ABERTURA ,A.ABERTURA_CAIXA)  
                                                       AND (B.ABERTURA = A.ABERTURA) OR (B.ABERTURA = A.ABERTURA_CAIXA)  
                                                       AND ISNULL(B.CANCELADO,'N') = 'N'   
      LEFT JOIN   
         BANDEIRAS_TEF                  E WITH(NOLOCK) ON E.BANDEIRA    = B.BANDEIRA  
                                                      AND E.CODBANDEIRA = B.CODBANDEIRA  
                                                      AND B.TIPO = 4   
      LEFT JOIN  
         ##TEMP                         F              ON F.RECREC001 = ISNULL(ISNULL(B.CARTIPLANC,E.RECREC001),1)--E.RECREC001  
           
    
      UNION ALL  
        
      ---- recargas de celular  
      SELECT   
         A.FORMULARIO_ORIGEM                           AS FORMULARIO_ORIGEM,  
         A.TAB_MASTER_ORIGEM                           AS TAB_MASTER_ORIGEM,  
         A.FECHAMENTO_CAIXA                            AS REG_MASTER_ORIGEM,  
         A.EMPRESA_CONTABIL                            AS EMPRESA_CONTABIL,  
         A.MOVIMENTO                                   AS MOVIMENTO,  
         1                                             AS RECREC001,   
         A.FECHAMENTO_CAIXA                            AS FECHAMENTO_CAIXA,  
         A.EMPRESA                                     AS EMPRESA,   
         A.CAIXA_LOJA                                  AS CAIXA_LOJA,  
         A.ABERTURA_CAIXA                              AS ABERTURA_CAIXA,  
         ISNULL(D.VALOR_RECARGA,0)                     AS VALOR_RECARGA,  
         0                                             AS VALOR_RECEBIMENTO,  
         'DH'                                           AS TIPO_AGRUPAMENTO_PROCFIT  
      FROM   
         #FECHAMENTO_CAIXA     A WITH(NOLOCK)    
      LEFT JOIN      
         PDV_RECARGAS          D WITH(NOLOCK)  ON D.LOJA       = A.EMPRESA_ORIGINAL     
                                              AND D.CAIXA      = A.CAIXA_LOJA   
                                              AND A.MOVIMENTO  = D.MOVIMENTO   
                                              AND ((D.ABERTURA   =  A.ABERTURA) OR (D.ABERTURA = A.ABERTURA_CAIXA))  
   )  A   
   WHERE   
      A.TIPO_AGRUPAMENTO_PROCFIT IS NOT NULL  
   GROUP BY   
      FORMULARIO_ORIGEM,  
      TAB_MASTER_ORIGEM,  
      REG_MASTER_ORIGEM,  
      EMPRESA_CONTABIL,  
      MOVIMENTO,  
      RECREC001,  
      FECHAMENTO_CAIXA,  
      EMPRESA,   
      CAIXA_LOJA,  
      ABERTURA_CAIXA,  
      TIPO_AGRUPAMENTO_PROCFIT              
     
   ORDER BY   
      FECHAMENTO_CAIXA  

	
CREATE TABLE #TEMP_DESPESAS
	(
		TIPO VARCHAR(10),
		VALOR NUMERIC (15,2),
		LOJA NUMERIC(15),
		CAIXA NUMERIC(15)
	)
            
	 SET @SQL_DESPESAS = '
        SELECT *  
        FROM OPENQUERY(  	
          PostgreSQL05,
          ''select     
				A.recrec001 as tipo,
				/*C.carnomcar as cartao,*/
				sum(A.recvalrec) as valor,
				/*A.recnumnot as cupom,
				A.id_tb_log,
				A.recnsu as nsu,
				A.finalizadora,
				A.recarga,
				A.recebimento_finalizadora,*/
				B.simples,
				A.recnumcai
			from public.stfil711_new A
			left join financeiro.tb_estabelecimento_filial B on 
				B.destcod = A.reccodfil 
				and B.ativa is true
			left join public.tb_tippag C on 
				C.recrec001 = A.recrec001
			left join financeiro.tb_scope_status D on 
				D.codresposta = A.reccodresposta
			left join publico.tb_login E on 
				E.id = A.recusuarioconf 
				and E.grupo = ''''CONCILIACAO_CARTOES''''
			left join financeiro.tb_stfil711_agrupamento F on 
				F.cupom = A.recnumnot
				and F.id_tb_log = A.id_tb_log
				and COALESCE(F.finalizadora,0) = COALESCE(A.finalizadora,0)
				and A.recctrllanc <> -2
            left join procfit.tb_empresas_usuarias G on
            	B.simples = G.entidade
			where
				'+@SQLFILTRO+' and 
				G.empresa_contabil = '+CAST(@EMPRESA_CONTABIL AS VARCHAR)+' and 
				C.cardetcar is true and
				F.id is null
			group by
				A.recrec001,
				C.carnomcar,    
				A.recnumnot,
				A.recnumpar,
				A.recqtdpar,
				A.id_tb_log,
				A.recnsu,
				D.descricao,
				A.recusuarioconf,
				E.usuario,
				A.recestorno,
				A.finalizadora,
				A.recarga,
				A.recebimento_finalizadora,
				B.simples,
				A.recnumcai
				 '' 	 
        )'

    INSERT INTO #TEMP_DESPESAS
    EXECUTE sp_executesql @SQL_DESPESAS;


	CREATE TABLE #TEMP_LISTA_DESPESAS
	(
		TIPO NUMERIC(15),
		DESCRICAO VARCHAR(36),
		CLASSIF_FINANCEIRA NUMERIC (15)
	)
            
    /*------------------------------------------------USAR CÓDIGO POSTGRESQL NO SQL-SERVER---------------------------------------------------*/

	SET @SQL_LISTA_DESPESAS = '
			SELECT *  
			FROM OPENQUERY(  	
			  PostgreSQL05,
			  ''select 
					A.recrec001 as TIPO,
					A.carnomcar as DESCRICAO,
					A.carclasse as CLASSIF_FINANCEIRA 
				from public.tb_tippag A
				where
					A.tipo_agrupamento_procfit = ''''DP''''
					 '' 	 
			)'
	INSERT INTO #TEMP_LISTA_DESPESAS
	EXECUTE sp_executesq


    /*------------------------------------------------CONVERTER COLUNA EM STRING COM COALISCE------------------------------------------------*/

    IF (OBJECT_ID('dbo.Teste_Group_Concat') IS NOT NULL) DROP TABLE dbo.Teste_Group_Concat
        CREATE TABLE dbo.Teste_Group_Concat(
        Categoria VARCHAR(100),
        Descricao VARCHAR(100)
    )

    INSERT INTO dbo.Teste_Group_Concat( Categoria, Descricao )
    VALUES  ('Brinquedo', 'Bola'),
            ('Brinquedo', 'Carrinho'),
            ('Brinquedo', 'Boneco'),
            ('Brinquedo', 'Jogo'),
            ('Cama e Mesa', 'Toalha'),
            ('Cama e Mesa', 'Edredom'),
            ('Informatica', 'Teclado'),
            ('Informatica', 'Mouse'),
            ('Informatica', 'HD'),
            ('Informatica', 'CPU'),
            ('Informatica', 'Memoria'),
            ('Informatica', 'Placa-Mae'),
            (NULL, 'TV')

    DECLARE @Nomes VARCHAR(MAX)
    
    SELECT 
        @Nomes = COALESCE(@Nomes + ', ', '') + Descricao
    FROM 
        dbo.Teste_XML
    
    SELECT @Nomes

    --DECLARE
	--	@EMPRESA NVARCHAR(MAX);
	----@CAIXA NVARCHAR(MAX);
 
	--SELECT 
	--	@CAIXA = COALESCE(@CAIXA + ', ', '') + CAST(X.CAIXA_LOJA AS VARCHAR(10))
	--FROM (SELECT DISTINCT CAIXA_LOJA
	--		FROM #FECHAMENTO_CAIXA) X

	--SELECT 
	--	@EMPRESA = COALESCE(@EMPRESA + ', ', '') + CAST(X.EMPRESA AS VARCHAR(10))
	--FROM (SELECT DISTINCT EMPRESA
	--		FROM #FECHAMENTO_CAIXA) X

    /*-----------------------------------------CONVERTER COLUNA EM STRING COM STUFF + FOR XML PATH---------------------------------------------*/

    SELECT  
    Categoria,
    STUFF((
        SELECT ', ' + B.Descricao 
        FROM dbo.Teste_Group_Concat B 
        WHERE ISNULL(B.Categoria, '') = ISNULL(A.Categoria, '')
        ORDER BY B.Descricao 
        FOR XML PATH('')), 1, 2, ''
    ) AS Descricao
    FROM
        dbo.Teste_Group_Concat A
    GROUP BY 
        Categoria
    ORDER BY 
        Categoria

    /*------------------------------------------------------------------------------------------------------------------------------------------*/