/*

1. Tome nota de la intercalación (collate) de la base de datos creada en el TP1.

2. Genere tres bases de datos adicionales, para lograr obtener una combinación de
todas las variantes de sensibilidad a acentos y mayúsculas/minúsculas.

3. Cree un esquema denominado “ddbba” (por bases de datos aplicada). Todos los
objetos que cree a partir de aquí deberán pertenecer a este esquema o a otro según
corresponda. No debe usar el esquema default (dbo).

4. Recomendamos emplear la tabla y SP “registro” mencionados en el TP1 para
operaciones de debugging. 

*/ 

USE grupo10;

/* 1 */
SELECT name, collation_name FROM sys.databases where name = 'grupo10'; --SQL_Latin1_General_CP1_CI_AS

/* 2 */
CREATE DATABASE grupo10_CS_AS COLLATE Modern_Spanish_CS_AS;
ALTER DATABASE grupo10_CS_AS COLLATE SQL_Latin1_General_CP1_CS_AS;
USE grupo10_CS_AS;
SELECT * FROM sys.databases where name = 'grupo10_CS_AS'; --SQL_Latin1_General_CP1_CS_AS

CREATE DATABASE grupo10_CI_AI COLLATE Modern_Spanish_CI_AI;
ALTER DATABASE grupo10_CI_AI COLLATE SQL_Latin1_General_CP1_CI_AI;
USE grupo10_CI_AI;
SELECT * FROM sys.databases where name = 'grupo10_CI_AI'; --SQL_Latin1_General_CP1_CI_AI

CREATE DATABASE grupo10_CI_AS COLLATE Modern_Spanish_CI_AS;
ALTER DATABASE grupo10_CI_AS COLLATE SQL_Latin1_General_CP1_CI_AS;
USE grupo10_CI_AS;
SELECT * FROM sys.databases where name = 'grupo10_CI_AS'; --SQL_Latin1_General_CP1_CI_AS

/* 3 */

USE grupo10_CI_AI;
CREATE SCHEMA ddbba;

USE grupo10_CI_AS;
CREATE SCHEMA ddbba;

USE grupo10_CS_AS;
CREATE SCHEMA ddbba;

/* 4 N/A*/