/*18. Cree una vista que presente una vista PIVOT de cantidad de inscripciones para las
materias por cada turno. Utilice su criterio para presentarlo de la manera que
considere m�s clara. */

CREATE OR ALTER VIEW ddbba.v_cantidad_inscripciones AS
	WITH CTE(materia,turno,cantidad) AS
		(
			SELECT c.id_materia,CONCAT(c.dia,'-',c.turno_cursada), COUNT(*)
			FROM ddbba.curso_persona cp
				INNER JOIN ddbba.curso c ON c.comision = cp.comision AND cp.tipo_asistente = 11
			GROUP BY c.id_materia, CONCAT(c.dia,'-',c.turno_cursada)

		)
	SELECT *
	FROM CTE
	PIVOT(SUM(cantidad) for turno IN ([Lunes-Ma�ana], [Lunes-Tarde], [Lunes-Noche],
										[Martes-Ma�ana], [Martes-Tarde], [Martes-Noche],
										[Miercoles-Ma�ana], [Miercoles-Tarde], [Miercoles-Noche],
										[Jueves-Ma�ana], [Jueves-Tarde], [Jueves-Noche],
										[Viernes-Ma�ana], [Viernes-Tarde], [Viernes-Noche])) cruzado;

-- SELECT Materia, [Martes-Ma�ana] FROM ddbba.v_cantidad_inscripciones