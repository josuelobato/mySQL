SHOW DATABASES;

USE tienda;

#USO DE LIKE

#EJEMPLOS 1

SELECT *
FROM empleado
WHERE nombre LIKE 'M%';

SELECT *
FROM empleado
WHERE nombre LIKE '%a';

SELECT *
FROM empleado
WHERE nombre LIKE 'M%a'; #%CAZA CUALQUIER CADENA

SELECT *
FROM empleado
WHERE nombre LIKE 'M_losa'; # _CAZA CON UNA LETRA	


#RETO 1

SELECT *
FROM articulo
WHERE nombre LIKE '%Pasta%'; #no es sensible a mayusculas o minusculas, se puede poner PASTA

SELECT *
FROM articulo
WHERE nombre LIKE '%Cannelloni%';

SELECT *
FROM articulo
WHERE nombre LIKE '% - %';

#EJEMPLOS 2

SELECT (1 + 7) * (10 / (6 - 4)); #realizar operaciones aritmeticas

#Una función de agrupamiento es aquella que reduce los registros de un campo en un valor

SELECT avg(precio)
FROM articulo;

SELECT max(precio)
FROM articulo;

#Número de registros de una columna
SELECT count(*)
FROM articulo;

SELECT sum(precio)/count(*) #Sacar promedio manualmente
FROM articulo;

#Suma de una columna
SELECT sum(precio)
FROM articulo;


#RETO 2
SELECT avg(salario)
FROM puesto;

SELECT count(*)
FROM articulo
WHERE nombre LIKE '%pasta%';

#Cual es el salario minimo y maximo 
SELECT max(salario),min(salario) 
FROM puesto;

SELECT sum(salario) AS 'Suma ultimos 5 salarios'
FROM puesto
ORDER BY id_puesto desc
LIMIT 5; 


#EJEMPLOS 3

#GROUP BY
#Recuerda que los campos antes de las funciones de agregación son los que deben 
#aparecer en la cláusula GROUP BY

SELECT nombre, sum(precio) AS total
FROM articulo
GROUP BY nombre;

#Ver los productos mas vendidos
SELECT nombre, count(*) AS cantidad
FROM articulo
GROUP BY nombre
ORDER BY cantidad DESC;

SELECT nombre, min(salario) AS menor, max(salario) AS mayor
FROM puesto
GROUP BY nombre;

#RETO 3
DESCRIBE venta;

SELECT nombre, count(*) AS registros
FROM puesto
GROUP BY nombre;

SELECT nombre, sum(salario) total #No es necesario el AS
FROM puesto
GROUP BY nombre;

SELECT id_empleado, count(*) AS ventas
FROM venta
GROUP BY id_empleado
ORDER BY ventas DESC;

SELECT id_articulo, count(*) AS ventas
FROM venta
GROUP BY id_articulo
ORDER BY ventas DESC;


#EJEMPLOS 4
#Puede crear sunconsultas en SQL y pueden aparecer en la cláusula WHERE, FROM o SELECT

#empleados cuyo puesto es Junior Executive
#Usando WHERE
SELECT id_puesto
FROM puesto
WHERE nombre = 'Junior Executive';

SELECT *
FROM empleado
WHERE id_puesto IN 
   (SELECT id_puesto
   FROM puesto
   WHERE nombre = 'Junior Executive');
   

#Usando FROM
SELECT clave, id_articulo, count(*) AS cantidad
FROM venta
GROUP BY clave, id_articulo
ORDER BY clave;

SELECT id_articulo, min(cantidad), max(cantidad)
FROM 
   (SELECT clave, id_articulo, count(*) AS cantidad #SE toma como una tabla
   FROM venta
   GROUP BY clave, id_articulo
   ORDER BY clave) AS subconsulta #toda tabla tiene un nombre
GROUP BY id_articulo;


#Usando SELECT

SELECT nombre, apellido_paterno, (SELECT salario FROM puesto WHERE id_puesto = e.id_puesto) AS sueldo
FROM empleado AS e;


#RETO 4

SELECT nombre
FROM empleado
WHERE id_puesto IN 
	(SELECT id_puesto
	FROM puesto 
	WHERE salario > 10000
    );
    

SELECT nombre, apellido_paterno, (SELECT nombre FROM puesto WHERE id_puesto = e.id_puesto) AS puesto
FROM empleado AS e;


#EJERCICIOS SESIÓN 2
USE classicmodels;

DESCRIBE orderdetails;

#10 Cliente que ha realizado el pago mas alto en total
SELECT customerNumber AS Cliente,checkNumber AS Cheque,amount AS Cantidad
FROM payments
WHERE customerNumber = 
	(SELECT customerNumber
	 FROM
		(SELECT customerNumber,sum(amount) pago
		FROM payments
		GROUP BY customerNumber
		ORDER BY pago Desc
		LIMIT 1
		) AS subconsulta
	);

#OTRA OPCION 10 el cliente que ha realizado el pago mas alto
SELECT customerNumber,checkNumber,sum(amount) pago
FROM payments
GROUP BY customerNumber,checkNumber
ORDER BY pago Desc
LIMIT 1;

