/* 17. Cree un SP que elimine las inscripciones superpuestas o duplicadas. */

CREATE OR ALTER PROCEDURE ddbba.del_inscripcion_superpuesta AS
BEGIN

	WITH CTE(dni, comision, ocurrencia) AS (
		SELECT s.dni, cp.comision, ROW_NUMBER() OVER(partition by s.dni, c.dia, c.turno_cursada ORDER BY c.comision DESC)  -- deja la comision mas alta
		FROM ddbba.v_superposiciones s
			INNER JOIN ddbba.curso_persona cp ON cp.dni = s.dni
			INNER JOIN ddbba.curso c ON c.comision = cp.comision
	)
	DELETE cp 
		FROM ddbba.curso_persona cp 
			INNER JOIN CTE c ON c.dni = cp.dni AND c.comision = cp.comision
	WHERE ocurrencia > 1

END

EXEC ddbba.del_inscripcion_superpuesta