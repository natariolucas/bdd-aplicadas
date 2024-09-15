/*
3. Cree una tabla llamada “registro” que tenga los siguientes campos: id entero 
autoincremental como primary key; fecha y hora con valor default del momento de 
inserción, texto con un tamaño máximo de 50 caracteres, modulo con un tamaño 
máximo de 10 caracteres. Esta tabla la empleará como bitácora (log) de las 
operaciones de los puntos siguientes.
*/

CREATE TABLE ddbba.registro (
	id INT IDENTITY PRIMARY KEY,
	fecha_y_hora DATETIME DEFAULT GETDATE(),
	texto VARCHAR(50),
	modulo VARCHAR(10)
)