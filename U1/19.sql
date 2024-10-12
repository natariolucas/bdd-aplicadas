/*19. Utilizando Window Functions cree una vista que muestre los alumnos inscritos a una
materia y en una columna también muestre la cantidad total de materias a las que se
ha inscrito ese alumno (en un mismo cuatrimestre).*/

CREATE OR ALTER VIEW ddbba.v_alumnos_x_materia AS
SELECT c.id_materia, cp.dni, COUNT(*) OVER( PARTITION BY cp.dni) as cant
FROM ddbba.curso_persona cp
	INNER JOIN ddbba.curso c ON c.comision = cp.comision;


/* SELECT c.id_materia, cp.dni
FROM ddbba.curso_persona cp
	INNER JOIN ddbba.curso c ON c.comision = cp.comision
WHERE cp.dni = 30014621 */


