CREATE DATABASE prueba_autoev;

INSERT INTO ddbba.CuentaCorriente VALUES
(1,10000,'D','2011-06-26'),
(2,10000,'D','2013-06-15'),
(3, 10000, 'D', '2023-01-02'),
(4,10000,'D','2023-01-05'),
(5,10000,'D','2023-01-09'),
(6,10000,'D','2023-01-10'),
(7,10000,'D','2023-02-02'),
(8,10000,'D','2023-02-03'),
(9,90000,'H','2023-05-02'),
(10,10000,'D','2023-05-09'),
(11,30000,'H','2023-06-02');


select 
	id,
	monto, 
	debeHaber, 
	fechaHora, 
	SUM(
		case debeHaber 
			when 'D' then monto*-1 
			else monto 
		end) over (partition by fechaHora order by fechaHora) Saldo 
		
from ddbba.CuentaCorriente