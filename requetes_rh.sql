-- =============================================================
--  REQUÊTES RH / COMMERCIALES – Toys & Models
-- 
-- =============================================================

-- Nombre total d'employés
SELECT COUNT(DISTINCT e.employeeNumber) AS nb_employes
FROM employees e;

-- Répartition par poste
SELECT jobTitle, COUNT(*) AS repartition_poste
FROM employees
GROUP BY jobTitle
ORDER BY repartition_poste DESC;

-- Répartition des employés par pays
SELECT o.country, COUNT(e.employeeNumber) AS repartition_par_pays
FROM employees e
JOIN offices o ON o.officeCode = e.officeCode
GROUP BY o.country
ORDER BY repartition_par_pays DESC;

-- Chiffre d'affaires par employé (Top 5)
SELECT 
  e.employeeNumber,
  e.firstName,
  e.lastName,
  ROUND(SUM(od.priceEach * od.quantityOrdered), 2) AS ca_employee
FROM employees e 
JOIN customers c ON c.salesRepEmployeeNumber = e.employeeNumber
JOIN orders o ON o.customerNumber = c.customerNumber
JOIN orderdetails od ON od.orderNumber = o.orderNumber
GROUP BY e.employeeNumber, e.firstName, e.lastName
ORDER BY ca_employee DESC
LIMIT 5;

-- Nombre de clients par vendeur
SELECT 
  e.employeeNumber, e.firstName, e.lastName,
  COUNT(DISTINCT c.customerNumber) AS nb_client
FROM employees e 
LEFT JOIN customers c ON c.salesRepEmployeeNumber = e.employeeNumber
GROUP BY e.employeeNumber, e.firstName, e.lastName
ORDER BY nb_client DESC;

-- Vendeur associé aux meilleurs clients (Top 5 par CA)
SELECT 
  c.customerNumber,
  c.customerName,
  CONCAT(e.firstName, ' ', e.lastName) AS vendeur,
  ROUND(SUM(od.quantityOrdered * od.priceEach), 2) AS CA_total
FROM customers c
JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber
JOIN orders o ON o.customerNumber = c.customerNumber
JOIN orderdetails od ON od.orderNumber = o.orderNumber
GROUP BY c.customerNumber, c.customerName, vendeur
ORDER BY CA_total DESC
LIMIT 5;
