/* 15. Genere una función validaCursada que devuelva la cantidad de materias
superpuestas a las que está inscripto un alumno, recibiendo el DNI por parámetro. */

CREATE OR ALTER FUNCTION ddbba.validaCursada(@dni int)
RETURNS int
BEGIN
	DECLARE @cant int;

	WITH CTE(dia, turno_cursada, cant_materias) AS (
		SELECT c.dia, c.turno_cursada, COUNT(*)
		FROM ddbba.persona p
			INNER JOIN ddbba.curso_persona cp ON cp.dni = p.dni
			INNER JOIN ddbba.curso c ON c.comision = cp.comision
		WHERE p.dni = @dni
		GROUP BY c.dia, c.turno_cursada
	)
	SELECT @cant = SUM(cant_materias)
	FROM CTE
	WHERE cant_materias > 1

	RETURN ISNULL(@cant,0)

END
