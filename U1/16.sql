/* 16. Cree una vista que utilice la función del punto anterior y muestre los alumnos con
superposición de inscripciones. */

CREATE VIEW ddbba.v_superposiciones AS
SELECT p.dni, ddbba.validaCursada(p.dni) as cant_materias_superpuestas
FROM ddbba.persona p
WHERE ddbba.validaCursada(p.dni) > 0;



/* SELECT cp.comision, c.id_materia, c.dia, c.turno_cursada
FROM ddbba.curso_persona cp
	INNER JOIN ddbba.curso c ON c.comision = cp.comision
where dni = 30452486
order by dia, turno_cursada */