/*
7. Cree un stored procedure para generar registros aleatorios en la tabla de alumnos. 
Para ello genere una tabla de nombres que tenga valores de nombres y apellidos 
que podrá combinar de forma aleatoria. Al generarse cada registro de alumno tome 
al azar dos valores de nombre y uno de apellido. El resto de los valores (localidad, 
fecha de nacimiento, DNI, etc.) genérelos en forma aleatoria también. El SP debe 
admitir un parámetro para indicar la cantidad de registros a generar. 
*/

CREATE TABLE ddbba.nombre(
	id tinyint identity PRIMARY KEY,
	nombre varchar(50)
);

INSERT INTO ddbba.nombre (nombre) VALUES
('Juan'), ('José'), ('Matías'), ('Lucas'), ('Santiago'), 
('Nicolás'), ('Gabriel'), ('Diego'), ('Andrés'), ('Javier'),
('Alejandro'), ('Fernando'), ('Ricardo'), ('Pablo'), ('David'), 
('Martín'), ('Leonardo'), ('Facundo'), ('Emiliano'), ('Maximiliano'),
('Diego'), ('Gonzalo'), ('Tomás'), ('Ramiro'), ('Agustín'),

('María'), ('Lucía'), ('Valentina'), ('Sofía'), ('Camila'), 
('Victoria'), ('Julieta'), ('Antonella'), ('Florencia'), ('Gabriela'), 
('Marta'), ('Ana'), ('Carla'), ('Patricia'), ('Elena'), 
('Verónica'), ('Laura'), ('Cecilia'), ('Inés'), ('Silvia'), 
('Teresa'), ('Mariana'), ('Juliana'), ('Natalia'), ('Claudia');

CREATE TABLE ddbba.apellido(
	id tinyint identity PRIMARY KEY,
	apellido varchar(50)
);

INSERT INTO ddbba.apellido (apellido) VALUES
('González'), ('Rodríguez'), ('Fernández'), ('López'), ('Pérez'),
('García'), ('Sánchez'), ('Martínez'), ('Díaz'), ('Ramírez'),
('Cruz'), ('Morales'), ('Torres'), ('Mendoza'), ('Vázquez'),
('Jiménez'), ('Hernández'), ('Gutiérrez'), ('Castro'), ('Rojas'),
('Núñez'), ('Silva'), ('Salazar'), ('Alvarez'), ('Córdoba'),
('Cano'), ('Bermúdez'), ('Valdez'), ('Medina'), ('Lara'),
('Ponce'), ('Bravo'), ('Rivas'), ('Marín'), ('Soto'),
('Cárdenas'), ('Cortez'), ('Galarza'), ('Escobar'), ('Quintero'),
('Salinas'), ('Reyes'), ('Márquez'), ('Villalba'), ('Patiño'),
('Vera'), ('Peña'), ('Ocampo'), ('Delgado'), ('Salas');

CREATE TABLE ddbba.localidad(
	id tinyint identity PRIMARY KEY,
	nombre varchar(50)
);

INSERT INTO ddbba.localidad (nombre) VALUES
('Buenos Aires'), ('La Plata'), ('Mar del Plata'), ('Quilmes'), ('Lomas de Zamora'),
('Avellaneda'), ('San Isidro'), ('Tigre'), ('Lanús'), ('Bahía Blanca'),
('Merlo'), ('Morón'), ('San Martín'), ('Trembal'), ('Córdoba'),
('Necochea'), ('Tandil'), ('Campana'), ('San Fernando'), ('Ezeiza'),
('Ramos Mejía'), ('San Vicente'), ('Pilar'), ('Escobar'), ('Ituzaingó'),
('Villa Gesell'), ('José C. Paz'), ('Zárate'), ('Las Heras'), ('Olavarría'),
('San Nicolás'), ('Baradero'), ('San Pedro'), ('Saladillo'), ('Santo Tomé'),
('Chivilcoy'), ('Pergamino'), ('Río Cuarto'), ('9 de Julio'), ('General Rodríguez'),
('San Andrés de Giles'), ('Marcos Paz'), ('Junín'), ('Pehuajó'), ('Olavarría'),
('General Las Heras'), ('Luján'), ('Pilar'), ('Las Flores'), ('San Martín');

CREATE TABLE ddbba.patente(
	patente varchar(7)
	CONSTRAINT ck_patente_src CHECK (
		patente LIKE '[A-Z][A-Z][0-9][0-9][0-9][A-Z][A-Z]' OR --  autos mercosur
		patente LIKE '[A-Z][A-Z][A-Z][0-9][0-9][0-9]' OR --  autos vieja
		patente LIKE '[A-Z][0-9][0-9][0-9][A-Z][A-Z][A-Z]' OR -- motos mercosur
		patente like '[0-9][0-9][0-9][A-Z][A-Z][A-Z]' -- motos vieja
	)
);
INSERT INTO ddbba.patente (patente) VALUES
('AB123CD'), ('XY456GH'), ('JKL789'), ('MN123OP'), ('QR456ST'),
('UV789WX'), ('AB123EF'), ('GH456IJ'), ('KL789MN'), ('OP123QR'),
('ST456UV'), ('WX789YZ'), ('ZA123BC'), ('DE456FG'), ('HI789JK'),
('LM123NO'), ('PQ456RS'), ('TU789VW'), ('XY123ZA'), ('BC456DE'),
('FG789HI'), ('JK123LM'), ('NO456PQ'), ('RS789TU'), ('VW123XY'),
('A123BCD'), ('E456FGH'), ('I789JKL'), ('M123NOP'), ('Q456RST'),
('U789VWX'), ('Y123ZAB'), ('C456DEF'), ('G789HIJ'), ('K123LMN'),
('O456PQR'), ('S789TUV'), ('X123YZA'), ('B456CDE'), ('F789GHI'),
('J123KLM'), ('N456OPQ'), ('R789STU'), ('V123WXY'), ('Z456ABC'),
('D789EFG'), ('H123IJK'), ('L456MNO'), ('P789QRS'), ('T123UVW');

ALTER TABLE ddbba.patente ADD id tinyint identity PRIMARY KEY;

go

CREATE OR ALTER PROCEDURE ddbba.proc_random_personas @cantPersonas int
AS
BEGIN
	DECLARE @minDNI int = 30000000;
	DECLARE @maxDNI int = 42300000;
	DECLARE @dni int;

	DECLARE @primerNombre varchar(50);
	DECLARE @segundoNombre varchar(50);

	DECLARE @apellido varchar(50);

	DECLARE @telefono varchar(15);

	DECLARE @diaNac tinyint;
	DECLARE @mesNac tinyint;
	DECLARE @anioNac smallint;
	DECLARE @minAnioNac smallint = 1990;
	DECLARE @maxAnioNac smallint = 2005;
	DECLARE @fechaNac date;

	DECLARE @localidad varchar(100);

	DECLARE @patente varchar(7);

	-- Las tablas de origen deben tener ids correlativos
	DECLARE @cantNombres tinyint  = 50;
	DECLARE @cantApellidos tinyint = 50;
	DECLARE @cantLocalidades tinyint = 50;
	DECLARE @cantPatentes tinyint = 50;

	WHILE @cantPersonas > 0
	BEGIN
	SET @dni = RAND()*(@maxDNI-@minDNI)+@minDNI;

	SELECT @primerNombre = nombre FROM ddbba.nombre WHERE id = CAST(RAND()*(@cantNombres-1)+1 AS tinyint);
	SELECT @segundoNombre = nombre FROM ddbba.nombre WHERE id = CAST(RAND()*(@cantNombres-1)+1 AS tinyint);

	SELECT @apellido = apellido FROM ddbba.apellido WHERE id = CAST(RAND()*(@cantApellidos-1)+1 AS tinyint);

	SET @telefono = CONCAT('+5411',CAST(CAST(RAND()*(35000000-90000000)+90000000 AS INT) AS varchar(13)));

	SET @diaNac = CAST(RAND()*(28-1)+1 AS tinyint);
	SET @mesNac = CAST(RAND()*(12-1)+1 AS tinyint);
	SET @anioNac = CAST(RAND()*(@maxAnioNac-@minAnioNac)+@minAnioNac AS smallint);

	SET @fechaNac = DATEFROMPARTS(@anioNac,@mesNac,@diaNac);

	SELECT @localidad = nombre FROM ddbba.localidad WHERE id = CAST(RAND()*(@cantLocalidades-1)+1 AS tinyint);

	SELECT @patente = patente FROM ddbba.patente WHERE id = CAST(RAND()*(@cantPatentes-1)+1 AS tinyint);

	INSERT INTO ddbba.persona(dni, nombre, apellido, telefono, fecha_nacimiento, localidad_residencia, patente)
	VALUES (
		@dni,
		CONCAT(@primerNombre,' ', @segundoNombre),
		@apellido,
		@telefono,
		@fechaNac,
		@localidad,
		@patente
	);

	SET @cantPersonas = @cantPersonas-1;
	END
END

SELECT * FROM ddbba.persona;

EXEC ddbba.proc_random_personas 30;