/*
5. Modele la relación entre persona, curso, materia. Una materia tiene varios cursos. 
Un curso tiene varias personas. Una persona puede ser alumno o docente en cada 
materia (no ambos al mismo tiempo), pero puede ser docente en una y alumno en 
otra. Genere tablas para cada uno. Asegúrese de aplicar los siguientes conceptos: 

	a. Claves primarias en cada tabla 
	b. Claves foráneas (restricciones) para vincular cada tabla a las demás. 
	c. Las personas pueden opcionalmente tener un vehículo. Incluya la patente 
		como campo de carga opcional con las restricciones de verificación 
		correspondientes. 
	d. Los cursos (comisiones) tienen un número de comisión de cuatro dígitos.  
	e. Las personas tienen un DNI y un número de teléfono, también una localidad 
		de residencia y una fecha de nacimiento. Nombres y apellido se almacenan 
		por separado. 
	f. Las materias deben tener un campo ID autoincremental como PK. Ese 
		campo lo debe completar el DBMS en cada inserción.
	g. Los aspectos de diseño que no estén detallados se dejan a su criterio. 
		Documente las decisiones en la forma de comentarios en los scripts. 
*/

RAISERROR('step by step', 25, 25) WITH LOG;
go

CREATE TABLE ddbba.persona (
	dni INT PRIMARY KEY,
	nombre varchar(50) not null,
	apellido varchar(50) not null,
	telefono varchar(15), -- varchar para evitar malas conversiones de numeros (por ej: 0800 a 800) o codigos de areas de paises (por ejemplo +54...)
	fecha_nacimiento date not null,
	localidad_residencia varchar(100) not null,
	patente varchar(7),
	CONSTRAINT ck_patente CHECK (
		patente LIKE '[A-Z][A-Z][0-9][0-9][0-9][A-Z][A-Z]' OR --  autos mercosur
		patente LIKE '[A-Z][A-Z][A-Z][0-9][0-9][0-9]' OR --  autos vieja
		patente LIKE '[A-Z][0-9][0-9][0-9][A-Z][A-Z][A-Z]' OR -- motos mercosur
		patente like '[0-9][0-9][0-9][A-Z][A-Z][A-Z]' -- motos vieja
	)
);

CREATE TABLE ddbba.materia(
	id int PRIMARY KEY,
	nombre varchar(150) not null
);

CREATE TABLE ddbba.curso(
	comision char(4) PRIMARY KEY CHECK(comision like '[0-9][0-9][0-9][0-9]'),
	id_materia INT NOT NULL,
	CONSTRAINT FK_MATERIA FOREIGN KEY(id_materia) REFERENCES ddbba.materia(id)
);


CREATE TABLE ddbba.tipo_asistente(
	id tinyint identity PRIMARY KEY,
	nombre varchar(40) not null CHECK (nombre not like '')
);

CREATE TABLE ddbba.curso_persona(
	comision char(4) not null,
	dni int not null,
	tipo_asistente tinyint not null, -- Este modelado permite por ejemplo incorporar nuevas especializaciones como "Ayudante de catedra, JTP, etc" solo generando un nuevo registro en la relacion

	CONSTRAINT PK_comision_persona PRIMARY KEY(comision,dni),
	CONSTRAINT FK_comision FOREIGN KEY(comision) REFERENCES ddbba.curso(comision),
	CONSTRAINT FK_persona FOREIGN KEY(dni) REFERENCES ddbba.persona(dni)
);

ALTER TABLE ddbba.curso_persona
ADD CONSTRAINT FK_tipo_asistente FOREIGN KEY(tipo_asistente) REFERENCES ddbba.tipo_asistente(id);

go -- Separa transaccion para la creación del trigger


-- Este trigger se podría evitar si agregamos id_materia en ddbba.curso_persona como redundancia controlada y generar una key unique entre id_materia y dni
CREATE OR ALTER TRIGGER ddbba.validarPersonaMateria ON ddbba.curso_persona INSTEAD OF INSERT, UPDATE as
BEGIN
	declare @ya_existe_en_misma_materia int

	SELECT @ya_existe_en_misma_materia = COUNT(*) 
	FROM inserted i
	INNER JOIN curso ci ON ci.comision = i.comision
	INNER JOIN curso_persona cp ON cp.dni = i.dni
	INNER JOIN curso ccp ON ccp.comision = cp.comision AND ccp.id_materia = ci.id_materia;

	IF @ya_existe_en_misma_materia > 0 
	BEGIN
		ROLLBACK TRANSACTION;
		RAISERROR('Una persona no puede estar inscripta dos veces en la misma materia',1,1);
	END
	ELSE
	BEGIN
		
		DELETE cp FROM ddbba.curso_persona cp INNER JOIN deleted d ON d.comision = cp.comision AND cp.dni = d.dni;
		INSERT INTO ddbba.curso_persona
		SELECT * FROM inserted;
	END
END

go

CREATE OR ALTER TRIGGER ddbba.persona_log ON ddbba.persona AFTER INSERT, UPDATE, DELETE AS
BEGIN
	DECLARE @insertado int;
	DECLARE @borrado int;
	DECLARE @modulo varchar(10);
	DECLARE @texto varchar(50);
	DECLARE @dni int;
	SET @modulo = 'ddbba.persona';

	SELECT @insertado = COUNT(*) FROM inserted;
	SELECT @borrado = COUNT(*) FROM deleted

	IF @insertado > 0
	BEGIN
		SELECT @dni = dni FROM inserted

		SET @texto = 'insertado dni '+ STR(@dni);

		IF @borrado > 0
		BEGIN
			SET @texto = 'actualizado dni ' + STR(@dni);
		END
	END 
	ELSE 
	BEGIN
		SELECT @dni = dni FROM deleted
		SET @texto = 'eliminado dni ' + STR(@dni);
	END
		EXEC ddbba.insertarLog @modulo, @texto;
END

go

CREATE OR ALTER TRIGGER ddbba.materia_log ON ddbba.materia AFTER INSERT, UPDATE, DELETE AS -- TODO: Adaptar con joins para los inserts/deletes multiples
BEGIN
	DECLARE @insertado int;
	DECLARE @borrado int;
	DECLARE @modulo varchar(10);
	DECLARE @texto varchar(50);
	DECLARE @nombre varchar(150);
	DECLARE @id int;
	SET @modulo = 'ddbba.materia';

	SELECT @insertado = COUNT(*) FROM inserted;
	SELECT @borrado = COUNT(*) FROM deleted

	IF @insertado > 0
	BEGIN
		SELECT @id = id, @nombre = nombre FROM inserted

		SET @texto = 'insertado id '+ STR(@id) + ' - ' + @nombre;

		IF @borrado > 0
		BEGIN
			SET @texto = 'actualizado id '+ STR(@id) + ' - ' + @nombre;
		END
	END 
	ELSE 
	BEGIN
		SELECT @id = id, @nombre = nombre FROM deleted
		SET @texto = 'eliminado id '+ STR(@id) + ' - ' + @nombre;
	END
		EXEC ddbba.insertarLog @modulo, @texto;
END

go

CREATE OR ALTER TRIGGER ddbba.tipo_asistente_log ON ddbba.tipo_asistente AFTER INSERT, UPDATE, DELETE AS -- TODO: Adaptar con joins para los inserts/deletes multiples
BEGIN
	DECLARE @insertado int;
	DECLARE @borrado int;
	DECLARE @modulo varchar(10);
	DECLARE @texto varchar(50);
	DECLARE @nombre varchar(150);
	DECLARE @id int;
	SET @modulo = 'ddbba.tipo_asistente';

	SELECT @insertado = COUNT(*) FROM inserted;
	SELECT @borrado = COUNT(*) FROM deleted

	IF @insertado > 0
	BEGIN
		SELECT @id = id, @nombre = nombre FROM inserted

		SET @texto = 'insertado id '+ STR(@id) + ' - ' + @nombre;

		IF @borrado > 0
		BEGIN
			SET @texto = 'actualizado id '+ STR(@id) + ' - ' + @nombre;
		END
	END 
	ELSE 
	BEGIN
		SELECT @id = id, @nombre = nombre FROM deleted
		SET @texto = 'eliminado id '+ STR(@id) + ' - ' + @nombre;
	END
		EXEC ddbba.insertarLog @modulo, @texto;
END

go

CREATE OR ALTER TRIGGER ddbba.curso_log ON ddbba.curso AFTER INSERT, UPDATE, DELETE AS -- TODO: Adaptar con joins para los inserts/deletes multiples
BEGIN
	DECLARE @insertado int;
	DECLARE @borrado int;
	DECLARE @modulo varchar(10);
	DECLARE @texto varchar(50);
	DECLARE @comision char(4);
	DECLARE @materia int;
	SET @modulo = 'ddbba.curso';

	SELECT @insertado = COUNT(*) FROM inserted;
	SELECT @borrado = COUNT(*) FROM deleted

	IF @insertado > 0
	BEGIN
		SELECT @comision = comision, @materia = id_materia FROM inserted

		SET @texto = 'insertado comision '+ STR(@comision) + ' - ' + STR(@materia);

		IF @borrado > 0
		BEGIN
			SET @texto = 'actualizado comision '+ STR(@comision) + ' - ' + STR(@materia);
		END
	END 
	ELSE 
	BEGIN
		SELECT @comision = comision, @materia = id_materia FROM deleted
		SET @texto = 'eliminado id '+ STR(@comision) + ' - ' + STR(@materia);
	END
		EXEC ddbba.insertarLog @modulo, @texto;
END

go

CREATE OR ALTER TRIGGER ddbba.curso_persona_log ON ddbba.curso_persona AFTER INSERT, UPDATE, DELETE AS -- TODO: Adaptar con joins para los inserts/deletes multiples
BEGIN
	DECLARE @insertado int;
	DECLARE @borrado int;
	DECLARE @modulo varchar(10);
	DECLARE @texto varchar(50);
	DECLARE @comision char(4);
	DECLARE @dni int;
	DECLARE @tipo_asistente varchar(40);
	SET @modulo = 'ddbba.curso_persona';

	SELECT @insertado = COUNT(*) FROM inserted;
	SELECT @borrado = COUNT(*) FROM deleted

	IF @insertado > 0
	BEGIN
		SELECT @comision = comision, @dni = dni, @tipo_asistente = ta.nombre FROM inserted i INNER JOIN tipo_asistente ta ON ta.id = i.tipo_asistente

		SET @texto = 'insertado dni '+ STR(@dni) + ' a la comision ' + @comision + ' como ' + @tipo_asistente;

		IF @borrado > 0
		BEGIN
			SET @texto = 'actualizado dni '+ STR(@dni) + ' a la comision ' + @comision + ' como ' + @tipo_asistente;
		END
	END 
	ELSE 
	BEGIN
		SELECT @comision = comision, @dni = dni, @tipo_asistente = ta.nombre FROM deleted i INNER JOIN tipo_asistente ta ON ta.id = i.tipo_asistente
			SET @texto = 'eliminado dni '+ STR(@dni) + ' a la comision ' + @comision + ' como ' + @tipo_asistente;
	END
		EXEC ddbba.insertarLog @modulo, @texto;
END

go


-- Prueba de check de patente
INSERT INTO ddbba.persona(dni, nombre, apellido, telefono, fecha_nacimiento, localidad_residencia, patente) VALUES (
	16555928,
	'Juan',
	'Perez',
	'+541135123222',
	'1998-01-23',
	'Pilar',
	'AB12ZCD'
);

-- registros exitosos de persona
INSERT INTO ddbba.persona(dni, nombre, apellido, telefono, fecha_nacimiento, localidad_residencia, patente) VALUES (
	16555928,
	'Juan',
	'Perez',
	'+541135123222',
	'1998-01-23',
	'Pilar',
	'AB123CD'
);

INSERT INTO ddbba.persona(dni, nombre, apellido, telefono, fecha_nacimiento, localidad_residencia, patente) VALUES (
	16123726,
	'Jorge',
	'Gonzalez',
	'+541132833283',
	'1994-05-21',
	'Almagro',
	null
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

-- materia
INSERT INTO ddbba.materia(nombre) VALUES ('Bases de datos aplicadas');

-- alta del tipo alumno y docente
INSERT INTO ddbba.tipo_asistente(nombre) VALUES ('alumno');
INSERT INTO ddbba.tipo_asistente(nombre) VALUES ('docente');

-- curso
SELECT * FROM ddbba.curso;
INSERT INTO ddbba.curso(comision,id_materia) VALUES('5678', 8);

-- curso persona
-- personas: 41039827, 16123726, 16555928
SELECT * FROM ddbba.curso_persona;
INSERT INTO ddbba.curso_persona(comision, dni, tipo_asistente) VALUES('1234', 41039827, 12); -- docente
INSERT INTO ddbba.curso_persona(comision, dni, tipo_asistente) VALUES('1234', 16123726, 11); -- alumno
INSERT INTO ddbba.curso_persona(comision, dni, tipo_asistente) VALUES('5678', 16555928, 12); -- docente
DELETE FROM ddbba.curso_persona WHERE comision = '5678' AND dni = 16555928;