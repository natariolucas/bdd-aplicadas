/* 14. Complete los datos de día y curso con valores aleatorios */
DECLARE @ordenCurso int;

SELECT @ordenCurso = COUNT(*) FROM ddbba.curso;

WHILE @ordenCurso > 0 
BEGIN

	DECLARE @comision char(4);

	WITH CTE(comision, orden) AS (
		SELECT comision, ROW_NUMBER() OVER (order by comision)
		FROM ddbba.curso
	) SELECT @comision = comision FROM CTE where orden = @ordenCurso

	UPDATE  ddbba.curso
		SET dia = CASE ROUND(RAND()*(5-1)+1,0)
				WHEN 1 THEN 'Lunes'
				WHEN 2 THEN 'Martes'
				WHEN 3 THEN 'Miercoles'
				WHEN 4 THEN 'Jueves'
				ELSE 'Viernes'
				END,
			turno_cursada = CASE ROUND(RAND()*(3-1)+1,0)
						WHEN 1 THEN 'Mañana'
						WHEN 2 THEN 'Tarde'
						ELSE 'Noche'
						END
	WHERE comision = @comision

	SET @ordenCurso = @ordenCurso-1;
END