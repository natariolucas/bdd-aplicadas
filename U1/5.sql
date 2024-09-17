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

go -- Separa transaccion para la creación del trigger


-- Este trigger se podría evitar si agregamos id_materia en ddbba.curso_persona como redundancia controlada y generar una key unique entre id_materia y dni
CREATE OR ALTER TRIGGER ddbba.validarPersonaMateria ON ddbba.curso_persona AFTER INSERT, UPDATE as
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
		RAISERROR('Una persona no puede estar inscripta dos veces en la misma materia');
	END
END

-- TODO: Triggers de insertar log como indica el punto 4