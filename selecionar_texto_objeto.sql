-- consultar textos dentro de objetos (procedure, functions, etc)

SELECT
	ROUTINE_CATALOG,
	R.ROUTINE_SCHEMA,
	R.ROUTINE_NAME ,
	ROUTINE_TYPE,
	OBJECT_DEFINITION (OBJECT_ID(R.ROUTINE_NAME )) AS [codigo]
FROM
	INFORMATION_SCHEMA.ROUTINES R
WHERE
	OBJECT_DEFINITION (OBJECT_ID(R.ROUTINE_NAME )) LIKE '%NF_FATURAMENTO_DEVOLUCOES_TOTAIS%' 
ORDER BY
	R.ROUTINE_NAME
