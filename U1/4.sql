/*

4. Cree un SP llamado “insertarLog” que reciba dos parámetros: modulo y texto. Si el 
modulo llega en blanco debe utilizar el texto “N/A”. Este SP insertará registros en la 
tabla de bitácora. A partir del siguiente punto, cada inserción, borrado, modificación, 
debe crear un registro en la mencionada tabla. En ningún caso debe realizar 
INSERTs por fuera del SP insertarLog. 

*/

CREATE OR ALTER PROCEDURE insertarLog @modulo varchar(10), @texto varchar(50)
AS
BEGIN
 IF @texto = ''
	SET @texto = 'N/A';

 INSERT INTO ddbba.registro(texto, modulo) VALUES(@texto, @modulo);

END;