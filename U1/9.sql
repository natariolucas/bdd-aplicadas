/* 9. Elimine los registros duplicados utilizando common table expressions */
WITH CTE (nombre, apellido, ocurrencia) AS
(
	SELECT  nombre, apellido, ROW_NUMBER() OVER(PARTITION BY nombre, apellido order by dni) as ocurrencia
	from ddbba.persona
)
-- SELECT * FROM CTE where ocurrencia > 1
DELETE FROM CTE where ocurrencia > 1