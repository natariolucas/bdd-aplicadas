/*18. Cree una vista que presente una vista PIVOT de cantidad de inscripciones para las
materias por cada turno. Utilice su criterio para presentarlo de la manera que
considere más clara. */

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
	PIVOT(SUM(cantidad) for turno IN ([Lunes-Mañana], [Lunes-Tarde], [Lunes-Noche],
										[Martes-Mañana], [Martes-Tarde], [Martes-Noche],
										[Miercoles-Mañana], [Miercoles-Tarde], [Miercoles-Noche],
										[Jueves-Mañana], [Jueves-Tarde], [Jueves-Noche],
										[Viernes-Mañana], [Viernes-Tarde], [Viernes-Noche])) cruzado;

-- SELECT Materia, [Martes-Mañana] FROM ddbba.v_cantidad_inscripciones