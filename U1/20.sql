/* 20. Utilizando Window Functions presente el 5% más joven y el 5% menos joven del
alumnado. */

-- 5% mas joven
WITH CTE(dni, nacimiento, escala) AS (
	SELECT dni, fecha_nacimiento, NTILE(20) OVER(order by fecha_nacimiento DESC)
	FROM ddbba.persona
)
SELECT dni, nacimiento, escala
FROM CTE
WHERE escala = 1;


-- 5% menos joven
WITH CTE(dni, nacimiento, escala) AS (
	SELECT dni, fecha_nacimiento, NTILE(20) OVER(order by fecha_nacimiento DESC)
	FROM ddbba.persona
)
SELECT dni, nacimiento, escala
FROM CTE
WHERE escala = 20;