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
		SELECT @maxAlumnosPosibles = COUNT(*)
		FROM ddbba.persona p 
			LEFT JOIN ddbba.curso c ON c.id_materia = @materia
			LEFT JOIN ddbba.curso_persona cp ON cp.dni = p.dni and cp.comision = c.comision -- excluyo las personas que esten en cualquier comision de la misma materia de la comision a insertar
		WHERE cp.dni is null;

		IF @maxAlumnosPosibles > 10 BEGIN SET @maxAlumnosPosibles = 10 END -- para facilitar debug

		DECLARE @cantAlumnosAsignar int = ROUND(RAND()*(@maxAlumnosPosibles-1)+1,0);


		PRINT('Se generaran ' + CAST(@cantAlumnosAsignar AS VARCHAR(10))+ ' alumnos para la comision ' + @comision);

		WHILE @cantAlumnosAsignar > 0
		BEGIN
			DECLARE @dni int
			SELECT @dni = t1.dni FROM (
				SELECT p.dni, ROW_NUMBER() OVER(order by p.dni) as orden
				FROM ddbba.persona p 
					LEFT JOIN ddbba.curso c ON c.id_materia = @materia
					LEFT JOIN ddbba.curso_persona cp ON cp.dni = p.dni and cp.comision = c.comision -- excluyo las personas que esten en cualquier comision de la misma materia de la comision a insertar
				WHERE cp.dni is null ) as t1 -- TODO: Fix, se esta agarrando cuando estan en al menos un curso de la materia no igual
			WHERE t1.orden = @cantAlumnosAsignar

			INSERT INTO ddbba.curso_persona VALUES (@comision, @dni, 11)

			SET @cantAlumnosAsignar = @cantAlumnosAsignar-1;
		END

		SET @curso = @curso-1;
	END

END
;

EXEC proc_alumnos_comisiones