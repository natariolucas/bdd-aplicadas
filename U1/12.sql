/*

12. Cree una vista empleando la opción “SCHEMABINDING” para visualizar las
comisiones (nro de comisión, código de materia, nombre de materia, apellido y
nombre de los alumnos). El apellido y nombre debe mostrarse con el formato
“Apellido, Nombres” (observe la coma intermedia).

a. Verifique qué ocurre si intenta modificar el tamaño de uno de los campos de
texto de la tabla de alumnos.

b. Verifique qué ocurre si intenta agregar un campo a la tabla de alumno.

c. Verifique qué ocurre si intenta agregar un campo que admita nulos a la tabla
de alumno. ¿Hay diferencia entre agregarlo si la tabla está vacía o tiene
registros?

d. ¿Puede usar SCHEMABINDING con una vista del tipo “Select * From..”?

*/

CREATE VIEW v_comisiones WITH SCHEMABINDING AS
SELECT c.comision, c.id_materia, m.nombre, CONCAT(p.nombre,', ',p.apellido) as ApyNom
from ddbba.curso c
	INNER JOIN ddbba.materia m ON m.id = c.id_materia
	INNER JOIN ddbba.curso_persona cp ON cp.comision = c.comision and tipo_asistente = 11
	INNER JOIN ddbba.persona p ON p.dni = cp.dni;
GO;

/* a) */ -- ALTER TABLE ddbba.persona ALTER COLUMN nombre varchar(100); -- fail
/* b) */ -- ALTER TABLE ddbba.persona ADD segundo_nombre varchar(100); -- ok
/* c) */ -- ALTER TABLE ddbba.persona ADD segundo_nombre_v2  varchar(100) not null; -- fail
/* d) */
			/*
				CREATE VIEW v_comisiones_v2 WITH SCHEMABINDING AS -- fail
				SELECT *
				from ddbba.curso c
			*/