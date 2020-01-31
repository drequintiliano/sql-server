//Para selecionar tabelas que contenham uma coluna com determinado texto

SELECT
O.name as Tabelas
FROM
syscolumns C
INNER JOIN sysobjects O ON
C.id = O.id
WHERE
c.name like '%Texto_Desejado%' 

