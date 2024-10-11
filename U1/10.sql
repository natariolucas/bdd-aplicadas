/* 10. Cree otro SP para generar registros aleatorios de comisiones por materia. Cada
materia debe tener entre 1 y 5 comisiones, entre los distintos turnos */

CREATE OR ALTER PROCEDURE ddbba.proc_random_comisiones
AS
BEGIN
	PRINT('ACA');
	-- Se asume que los IDs de materias son correlativos
	DECLARE @materia int
	SELECT @materia = MAX(id) FROM ddbba.materia;
	
	PRINT('Materia max: '+ CAST(@materia as varchar));
	while @materia > 0
	BEGIN
		DECLARE @cantComisiones tinyint = RAND()*(5-1)+1
		
		PRINT('Materia: ' + CAST(@materia as varchar));
		WHILE @cantComisiones > 0
		BEGIN
			DECLARE @comision varchar(4) = CAST(ROUND(RAND()*9, 0) AS char(1)) + CAST(ROUND(RAND()*9,0) AS CHAR(1)) + CAST(ROUND(RAND()*9,0) AS CHAR(1)) + CAST(ROUND(RAND()*9,0) AS char(1));
			PRINT('Comision: '+ @comision);
			INSERT INTO ddbba.curso VALUES (@comision, @materia);
			PRINT('Se generaron' + CAST(@cantComisiones as VARCHAR) + ' comisiones para la materia ' + CAST(@materia AS VARCHAR));


			SET @cantComisiones = @cantComisiones-1;
		END

		SET @materia = @materia-1;
	END


END

-- EXEC ddbba.proc_random_comisiones;