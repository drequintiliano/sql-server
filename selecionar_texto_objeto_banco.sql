/*
U => Tabela Usuário
S => Tabela de sistema
P => Procedure
V => View
F => Function
*/

USE [PBS_FARMAPONTE_DADOS]
GO
 
-- Iniciando a pesquisa nas tabelas de sistemas
 
SELECT A.NAME, A.TYPE, B.TEXT
  FROM SYSOBJECTS  A (nolock)
  JOIN SYSCOMMENTS B (nolock) 
    ON A.ID = B.ID
WHERE B.TEXT LIKE '%CONTEUDO%'  --- Informação a ser procurada no corpo da procedure, funcao ou view
  AND A.TYPE = 'P'                     --- Tipo de objeto a ser localizado no caso procedure
 ORDER BY A.NAME
 
GO


SELECT
	T.name AS Tabela,
	C.name AS Coluna
	
from	sys.sysobjects    AS T (NOLOCK)
INNER JOIN sys.all_columns AS C (NOLOCK) 
	ON T.id = C.object_id AND T.XTYPE = 'U'
WHERE
	C.NAME LIKE '%CONTEUDO%'
ORDER BY
	T.name ASC


select
	t.name as tabela,
	c.name as coluna,
	tipos.name as tipo,
	c.length as tamanho
from
	sysobjects as t, syscolumns as c, systypes as tipos

where
	t.id = c.id and
	c.usertype = tipos.usertype and
	tipos.name = 'varchar' and
	C.NAME LIKE '%CONTEUDO%'



-- consultar textos dentro de objetos (procedure, functions, etc)

SELECT
	c.TABLE_SCHEMA,
	c.TABLE_NAME,
	C.COLUMN_NAME
FROM information_schema.COLUMNS C
WHERE
	c.COLUMN_NAME like '%CONTEUDO%' and
	c.table_name like '%NF%' 
ORDER BY
	c.TABLE_NAME
	