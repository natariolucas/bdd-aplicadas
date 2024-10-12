/*
	13. Agregue a la tabla de comisión soporte para día y turno de cursada. (Modifique la
	tabla). Los números de comisión son únicos para cada cuatrimestre
*/

ALTER TABLE ddbba.curso 
	ADD dia varchar(9);

ALTER TABLE ddbba.curso 
	ADD turno_cursada varchar(6);