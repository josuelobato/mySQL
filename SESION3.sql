USE tienda;

#EJEMPLOS

#Para poder relacionar tablas, necesitamos conocer las llaves primarias y foráneas presentes en una tabla.
SHOW KEYS FROM venta;

#Por ejemplo, podemos relacionar la tabla empleado con puesto.
SELECT *
FROM empleado AS e
JOIN puesto AS p
  ON e.id_puesto = p.id_puesto;

#Left join  
SELECT *
FROM puesto AS p
LEFT JOIN empleado e
ON p.id_puesto = e.id_puesto;
  
#Rigth JOIN
SELECT *
FROM empleado AS e
RIGHT JOIN puesto AS p
ON e.id_puesto = p.id_puesto;

#RETO 1
DESCRIBE empleado;
DESCRIBE venta;

#¿Cuál es el nombre de los empleados que realizaron cada venta?
SELECT e.id_empleado,v.clave,e.nombre,e.apellido_paterno
FROM venta AS v
JOIN empleado AS e
ON v.id_empleado = e.id_empleado;

#¿Cuál es el nombre de los artículos que se han vendido?
SHOW KEYS FROM articulo;

SELECT clave,nombre
FROM venta AS v
JOIN articulo AS a
ON v.id_articulo = a.id_articulo
ORDER BY clave;

#¿Cuál es el total de cada venta?
SELECT clave,round(sum(precio),2) AS total
FROM articulo AS a
JOIN venta AS v
ON a.id_articulo = v.id_articulo
GROUP BY clave;

#EJEMPLOS 2
SELECT v.clave, v.fecha, a.nombre producto, a.precio, concat(e.nombre, ' ', e.apellido_paterno) empleado 
FROM venta v
JOIN empleado e
  ON v.id_empleado = e.id_empleado
JOIN articulo a
  ON v.id_articulo = a.id_articulo;
  
#crear la vista
CREATE VIEW tickets_189 AS
(SELECT v.clave, v.fecha, a.nombre producto, a.precio, concat(e.nombre, ' ', e.apellido_paterno) empleado 
FROM venta v
JOIN empleado e
  ON v.id_empleado = e.id_empleado
JOIN articulo a
  ON v.id_articulo = a.id_articulo);

#CONSULTAR LA VISTA
SELECT *
FROM tickets_189;

#SE PUEDEN CREAR CONSULTAS A LA VISTA
SELECT clave, round(sum(precio),2) total
FROM tickets_189
GROUP BY clave;	

#RETO 2
#Obtener el puesto de un empleado.
CREATE VIEW puestos_189 AS
(SELECT e.nombre,e.apellido_paterno,p.nombre AS nombre_puesto2
FROM empleado e
JOIN puesto p
ON e.id_puesto = p.id_puesto
);

SELECT *
FROM puestos_189;

#Saber qué artículos ha vendido cada empleado.
CREATE VIEW articulo_vendido_189 AS
(SELECT e.nombre,e.apellido_paterno,a.nombre AS nombre_articulo
FROM venta v
LEFT JOIN empleado e
ON v.id_empleado = e.id_empleado
JOIN articulo a
ON v.id_articulo = a.id_articulo
ORDER BY e.nombre
);

SELECT * 
FROM articulo_vendido_189;

#Saber qué puesto ha tenido más ventas.
CREATE VIEW puesto_ventas_189 AS
(SELECT p.nombre, count(v.clave) total
FROM venta v
JOIN empleado e
ON v.id_empleado = e.id_empleado
JOIN puesto p
ON e.id_puesto = p.id_puesto
GROUP BY p.nombre);

SELECT * 
FROM puesto_ventas_189;

SELECT *
FROM puesto_ventas_189
ORDER BY total DESC
LIMIT 1;

#EJERCICIOS
USE classicmodels;

SHOW KEYS FROM customers;
SHOW KEYS FROM orders;

#1
#Obtén la cantidad de productos de cada orden.
SELECT o.orderNumber, sum(quantityOrdered)
FROM orderdetails d
JOIN orders o
ON d.orderNumber=o.orderNumber
GROUP BY orderNumber;

#2 Obten el número de orden, estado y costo total de cada orden.
SELECT o.orderNumber, o.status, SUM(od.priceEach) Costo_Total
FROM orders AS o
JOIN orderdetails AS od
ON od.orderNumber = o.orderNumber
GROUP BY orderNumber;

#3 Obten el número de orden, fecha de orden, línea de orden, nombre del producto, cantidad ordenada y precio de cada pieza.
select o.orderNumber,o.orderDate,od.orderLineNumber,p.productName,od.quantityOrdered,od.priceEach
from orders as o join orderdetails as od
on o.orderNumber = od.orderNumber
join products as p
on od.productCode = p.productCode;

#4 Obtén el número de orden, nombre del producto, el precio sugerido de fábrica (msrp) y precio de cada pieza.
SELECT o.orderNumber, p.productName, MSRP, priceEach
FROM orders o
JOIN orderdetails d
ON o.orderNumber = d.orderNumber
JOIN products p
ON od.productCode = p.productCode;

#5 Obtén el número de cliente, nombre de cliente, número de orden y estado de cada orden hecha por cada cliente. ¿De qué nos sirve hacer LEFT JOIN en lugar de JOIN?
#Nos sirve para saber si algun cliente no tiene ordenes
SELECT c.customerNumber, c.customerName, o.orderNumber,o.status
FROM customers c
LEFT JOIN orders o
ON c.customerNumber = o.customerNumber;

#6 Obtén los clientes que no tienen una orden asociada.
SELECT c.customerName, o.orderNumber
FROM customers c
LEFT JOIN orders o
ON c.customerNumber = o.customerNumber
WHERE o.orderNumber is null;


#7 Obtén el apellido de empleado, nombre de empleado, nombre de cliente, número de cheque y total, es decir, los clientes asociados a cada empleado.
SELECT  e.lastName ,e.firstName, c.customerName, p.checkNumber, p.amount 
FROM employees e
LEFT JOIN customers c
ON c.salesRepEmployeeNumber = e.employeeNumber
LEFT JOIN payments p
ON p.customerNumber=c.customerNumber;

#8 Repite los ejercicios 5 a 7 usando RIGHT JOIN. ¿Representan lo mismo? Explica las diferencias en un comentario. Para poner comentarios usa
#EJERCICIO 5 CON RIGHT JOIN
SELECT c.customerNumber, c.customerName, o.orderNumber,o.status
FROM customers c
RIGHT JOIN orders o
ON c.customerNumber = o.customerNumber;
#No representa los mismo, ya que no muestra las empresas que no tienen ordenes

#EJERCICIO 6 CON RIGHT JOIN
SELECT c.customerName, o.orderNumber
FROM customers c
RIGHT JOIN orders o
ON c.customerNumber = o.customerNumber
WHERE o.orderNumber is null;
#No representan lo mismo, porque la tabla de la derecha no tiene la columna donde
#esten los nombres de los clientes que no tienen ordenes por lo tanto no nos arroja una tabla
#a diferencia del LEFT JOIN.

#EJERCICIO 7 CON RIGHT JOIN
SELECT  e.lastName ,e.firstName, c.customerName, p.checkNumber, p.amount 
FROM employees e
RIGHT JOIN customers c
ON c.salesRepEmployeeNumber = e.employeeNumber
LEFT JOIN payments p
ON p.customerNumber=c.customerNumber;
#Con left se encuentran hasta los empleados que no tienen asociado un cliente, y con right se eliminan

#Crear 3 vistas
CREATE VIEW ejercicio1_189 AS
(SELECT o.orderNumber, sum(quantityOrdered) AS total
FROM orderdetails d
JOIN orders o
ON d.orderNumber=o.orderNumber
GROUP BY orderNumber);

#CONSULTA
SELECT *
FROM ejercicio1_189
WHERE total > 100;


CREATE VIEW ejercicio4_189 AS
(SELECT o.orderNumber, p.productName, MSRP, priceEach
FROM orders o
JOIN orderdetails d
ON o.orderNumber = d.orderNumber
JOIN products p
ON od.productCode = p.productCode);

#CONSULTA
SELECT *
FROM ejercicio4_189
ORDER BY priceEach;

CREATE VIEW ejercicio5_189 AS
(SELECT c.customerNumber, c.customerName, o.orderNumber,o.status
FROM customers c
LEFT JOIN orders o
ON c.customerNumber = o.customerNumber);

#CONSULTA
SELECT customerNumber,count(*) AS ordenes
FROM ejercicio5_189
GROUP BY customerNumber;