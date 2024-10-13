/*
5. Descargue de la web https://datos.gob.ar/dataset/otros-nombres-personasfisicas/archivo/otros_2.1 todos los CSV de distintos períodos.

6. Genere la estructura de tabla para almacenar los datos descargados. Haga esto en
las cuatro DB.

7. Importe los CSV descargados repartiéndolos en las cuatro DB. A los fines de esta
práctica no es vital que lo reparta en cantidades precisamente iguales.

8. Es muy probable que algunos caracteres de acentos se hayan importado
incorrectamente. Verifique y corrija lo necesario. Es importante que mantenga las
letras acentuadas.
	a. Hay muchas formas de lograr lo mismo. Puede por ejemplo buscar patrones
		de letras con el operador LIKE, o bien buscar valores específicos de
		caracteres. Preste atención al comportamiento en cada DB a la misma
		cláusula WHERE (por ejemplo) que utilice en el reemplazo.

9. Determine el primer y el último percentil de nombres más empleados (el 1% más
empleado y el 1% menos empleado) para cada base de datos. Genere una vista en
cada DB para dicha consulta.

10. Obtenga una lista de coincidencias entre el primer percentil entre las cuatro DB.
Genere una vista para dicha consulta. 
*/

-- 6
USE grupo10;
CREATE TABLE ddbba.nombres(
	nombre varchar(100),
	cantidad int,
	anio smallint);

USE grupo10_CI_AI;
CREATE TABLE ddbba.nombres(
	nombre varchar(100),
	cantidad int,
	anio smallint);

USE grupo10_CI_AS;
CREATE TABLE ddbba.nombres(
	nombre varchar(100),
	cantidad int,
	anio smallint);

USE grupo10_CS_AS;
CREATE TABLE ddbba.nombres(
	nombre varchar(100),
	cantidad int,
	anio smallint);

-- 7 
use grupo10;
BULK INSERT grupo10.ddbba.nombres
FROM 'C:\Users\lucas\Downloads\nombres-1920-1924.csv'
WITH
(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
	CODEPAGE = 'ACP',
	FIRSTROW = 1
);

use grupo10_CI_AI;
BULK INSERT grupo10_CI_AI.ddbba.nombres
FROM 'C:\Users\lucas\Downloads\nombres-2015.csv'
WITH
(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
	CODEPAGE = 'ACP',
	FIRSTROW = 2
);

use grupo10_CI_AS;
BULK INSERT grupo10_CI_AS.ddbba.nombres
FROM 'C:\Users\lucas\Downloads\nombres-2005-2009.csv'
WITH
(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
	CODEPAGE = 'ACP',
	FIRSTROW = 2
);

use grupo10_CS_AS;
BULK INSERT grupo10_CS_AS.ddbba.nombres
FROM 'C:\Users\lucas\Downloads\nombres-2010-2014.csv'
WITH
(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
	CODEPAGE = 'ACP',
	FIRSTROW = 2
);

-- 9
use grupo10;
CREATE OR ALTER VIEW ddbba.percentil_nombres AS
WITH CTE(nombre,escala) AS 
(
	SELECT t1.nombre, NTILE(100) OVER(ORDER BY t1.cant DESC)
	FROM ( SELECT nombre, SUM(cantidad) as cant FROM ddbba.nombres GROUP BY nombre) t1
)
SELECT * FROM CTE WHERE escala IN (1,100)

use grupo10_CI_AI;
CREATE OR ALTER VIEW ddbba.percentil_nombres AS
WITH CTE(nombre,escala) AS 
(
	SELECT t1.nombre, NTILE(100) OVER(ORDER BY t1.cant DESC)
	FROM ( SELECT nombre, SUM(cantidad) as cant FROM ddbba.nombres GROUP BY nombre) t1
)
SELECT * FROM CTE WHERE escala IN (1,100)

use grupo10_CI_AS;
CREATE OR ALTER VIEW ddbba.percentil_nombres AS
WITH CTE(nombre,escala) AS 
(
	SELECT t1.nombre, NTILE(100) OVER(ORDER BY t1.cant DESC)
	FROM ( SELECT nombre, SUM(cantidad) as cant FROM ddbba.nombres GROUP BY nombre) t1
)
SELECT * FROM CTE WHERE escala IN (1,100)

use grupo10_CS_AS;
CREATE OR ALTER VIEW ddbba.percentil_nombres AS
WITH CTE(nombre,escala) AS 
(
	SELECT t1.nombre, NTILE(100) OVER(ORDER BY t1.cant DESC)
	FROM ( SELECT nombre, SUM(cantidad) as cant FROM ddbba.nombres GROUP BY nombre) t1
)
SELECT * FROM CTE WHERE escala IN (1,100)

-- 10
USE grupo10;
CREATE OR ALTER VIEW ddbba.percentil_nombres_cruzado AS
SELECT p1.nombre
FROM grupo10.ddbba.percentil_nombres p1
	INNER JOIN grupo10_CI_AI.ddbba.percentil_nombres p2 ON p1.escala = 1 AND p2.escala = 1 AND p1.nombre COLLATE SQL_Latin1_General_CP1_CI_AI = p2.nombre
	INNER JOIN grupo10_CI_AS.ddbba.percentil_nombres p3 ON p3.escala = 1 AND p2.nombre = p3.nombre COLLATE SQL_Latin1_General_CP1_CI_AI
	INNER JOIN grupo10_CS_AS.ddbba.percentil_nombres p4 ON p4.escala = 1 AND p3.nombre  = p4.nombre COLLATE SQL_Latin1_General_CP1_CI_AS;

