/*
	13. Agregue a la tabla de comisi�n soporte para d�a y turno de cursada. (Modifique la
	tabla). Los n�meros de comisi�n son �nicos para cada cuatrimestre
*/

ALTER TABLE ddbba.curso 
	ADD dia varchar(9);

ALTER TABLE ddbba.curso 
	ADD turno_cursada varchar(6);