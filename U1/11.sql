/* 11. Genere un SP para crear inscripciones a materias asignando alumnos a comisiones. */

CREATE OR ALTER PROCEDURE proc_alumnos_comisiones AS
BEGIN
	DECLARE @cantAlumnos int

	DECLARE @curso int
	SELECT @curso = COUNT(*) FROM ddbba.curso; -- obtengo el mayor orden de curso

	WHILE @curso > 0
	BEGIN
		DECLARE @comision char(4)
		DECLARE @materia int;
		SELECT @comision = t1.comision, @materia = t1.id_materia FROM (
			SELECT comision, id_materia, ROW_NUMBER() OVER(ORDER BY comision) as orden FROM ddbba.curso
		) as t1
		WHERE orden = @curso;

		DECLARE @maxAlumnosPosibles int;
		WITH CTE(dni) AS (
			SELECT cp.dni 
			FROM ddbba.curso_persona cp
				INNER JOIN ddbba.curso c ON c.comision = cp.comision AND c.id_materia = @materia
			GROUP BY cp.dni
		)
		SELECT @maxAlumnosPosibles = COUNT(*)
		FROM ddbba.persona p
			LEFT JOIN CTE c on c.dni = p.dni
		WHERE c.dni IS NULL

		IF @maxAlumnosPosibles > 10 BEGIN SET @maxAlumnosPosibles = 10 END -- para facilitar debug

		DECLARE @cantAlumnosAsignar int = ROUND(RAND()*(@maxAlumnosPosibles-1)+1,0);


		PRINT('Se generaran ' + CAST(@cantAlumnosAsignar AS VARCHAR(10))+ ' alumnos para la comision ' + @comision);

		WHILE @cantAlumnosAsignar > 0
		BEGIN
			DECLARE @dni int


			WITH CTE(dni) AS (
				SELECT cp.dni 
				FROM ddbba.curso_persona cp
					INNER JOIN ddbba.curso c ON c.comision = cp.comision AND c.id_materia = @materia
				GROUP BY cp.dni
			)
			SELECT @dni = t1.dni FROM (
				SELECT p.dni, ROW_NUMBER() OVER(order by p.dni) as orden
				FROM ddbba.persona p 
					LEFT JOIN CTE c on c.dni = p.dni
				WHERE c.dni IS NULL ) as t1
			WHERE t1.orden = @cantAlumnosAsignar

			INSERT INTO ddbba.curso_persona VALUES (@comision, @dni, 11)

			SET @cantAlumnosAsignar = @cantAlumnosAsignar-1;
		END

		SET @curso = @curso-1;
	END

END
;

EXEC proc_alumnos_comisiones