/*
6. Compruebe que las restricciones creadas funcionen correctamente generando 
juegos de prueba que no se admitan. Documente con un comentario el error de 
validación en cada caso. Asegúrese de probar con valores no admitidos siquiera una 
vez cada restricción. 
*/

RAISERROR('step by step', 25, 25) WITH LOG;
go

/* 
	Personas con DNI duplicado
	Violation of PRIMARY KEY constraint 'PK__persona__D87608A6E8C6E2BB'. Cannot insert duplicate key in object 'ddbba.persona'. The duplicate key value is (41039827).
*/
INSERT INTO ddbba.persona(dni, nombre, apellido, telefono, fecha_nacimiento, localidad_residencia, patente) VALUES (
	41039827,
	'Cosme',
	'Fulanito',
	'+541123138498',
	'1990-07-01',
	'Avellaneda',
	'A123BCD'
);

INSERT INTO ddbba.persona(dni, nombre, apellido, telefono, fecha_nacimiento, localidad_residencia, patente) VALUES (
	41039827,
	'Cosme',
	'Fulanito',
	'+541123138498',
	'1990-07-01',
	'Avellaneda',
	'A123BCD'
);

/*
	Formato de patente inválida
	The INSERT statement conflicted with the CHECK constraint "ck_patente". The conflict occurred in database "grupo10", table "ddbba.persona", column 'patente'.
*/
INSERT INTO ddbba.persona(dni, nombre, apellido, telefono, fecha_nacimiento, localidad_residencia, patente) VALUES (
	42395231,
	'Alberto',
	'Sanchez',
	'+541123138498',
	'1990-07-01',
	'Avellaneda',
	'ABCDEF'
);

/*
	Nombre de materia no puede ser null
	Cannot insert the value NULL into column 'nombre', table 'grupo10.ddbba.materia'; column does not allow nulls. INSERT fails.
*/
INSERT INTO ddbba.materia(nombre) VALUES(null);

/*
	Formato de curso inválido
	The INSERT statement conflicted with the CHECK constraint "CK__curso__comision__5CD6CB2B". The conflict occurred in database "grupo10", table "ddbba.curso", column 'comision'.
*/

INSERT INTO ddbba.curso VALUES ('AAAA',8);

/*
	Materia inexistente para asociar al curso
	The INSERT statement conflicted with the FOREIGN KEY constraint "FK_MATERIA". The conflict occurred in database "grupo10", table "ddbba.materia", column 'id'.
*/
INSERT INTO ddbba.curso VALUES ('5432',999);

/*
	Materia no puede ser null en curso
	Cannot insert the value NULL into column 'id_materia', table 'grupo10.ddbba.curso'; column does not allow nulls. INSERT fails.
*/
INSERT INTO ddbba.curso VALUES ('5432', null);

/* 
 Tipo asistente no puede ser null
 Cannot insert the value NULL into column 'nombre', table 'grupo10.ddbba.tipo_asistente'; column does not allow nulls. INSERT fails.
*/
INSERT INTO ddbba.tipo_asistente(nombre) VALUES(null);

/*
 Tipo asistente no puede ser vacio
 The INSERT statement conflicted with the CHECK constraint "CK__tipo_asis__nombr__619B8048". The conflict occurred in database "grupo10", table "ddbba.tipo_asistente", column 'nombre'.
*/
INSERT INTO ddbba.tipo_asistente(nombre) VALUES('');

/*
	Comision inexistente en curso persona
	The INSERT statement conflicted with the FOREIGN KEY constraint "FK_comision". The conflict occurred in database "grupo10", table "ddbba.curso", column 'comision'.
*/
INSERT INTO ddbba.curso_persona(comision, dni, tipo_asistente) VALUES('9999', 41039827, 11);

/*
	DNI inexistente en curso persona
	The INSERT statement conflicted withs the FOREIGN KEY constraint "FK_persona". The conflict occurred in database "grupo10", table "ddbba.persona", column 'dni'.
*/
INSERT INTO ddbba.curso_persona(comision, dni, tipo_asistente) VALUES('1234', 1, 11);


/*
	Tipo asistente inexistente en curso persona
	The INSERT statement conflicted with the FOREIGN KEY constraint "FK_tipo_asistente". The conflict occurred in database "grupo10", table "ddbba.tipo_asistente", column 'id'.
*/
INSERT INTO ddbba.curso_persona(comision, dni, tipo_asistente) VALUES('1234', 41039827, 99);


/*
	Misma persona dos veces en la misma comisión (Combinación de PK)

	The transaction ended in the trigger. The batch has been aborted. 
	"Una persona no puede estar inscripta dos veces en la misma materia"
*/
INSERT INTO ddbba.curso_persona(comision, dni, tipo_asistente) VALUES('1234', 41039827, 11);

/*
	Insertar persona en una comisión no inscripta pero que sea de misma materia que otra comisión

	The transaction ended in the trigger. The batch has been aborted. 
	"Una persona no puede estar inscripta dos veces en la misma materia"
*/
INSERT INTO ddbba.curso_persona(comision, dni, tipo_asistente) VALUES('5678', 41039827, 11);
