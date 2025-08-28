-- =============================================================
--  REQUÊTES CLIENTS – Toys & Models
-- =============================================================

-- Nombre de clients total
SELECT COUNT(DISTINCT customerNumber) AS nb_client
FROM customers;

-- Nombre de clients par pays
SELECT country, COUNT(DISTINCT customerNumber) AS nb_client
FROM customers
GROUP BY country
ORDER BY nb_client DESC;

-- Nombre de commandes par client (Top 5)
SELECT c.customerNumber, c.customerName, c.country,
       COUNT(o.orderNumber) AS nb_commande
FROM customers c
JOIN orders o ON o.customerNumber = c.customerNumber
GROUP BY c.customerNumber, c.customerName, c.country
ORDER BY nb_commande DESC
LIMIT 5;

-- Panier moyen par client (Top 5)
SELECT 
  c.customerNumber, c.customerName, c.country,
  ROUND(SUM(od.priceEach * od.quantityOrdered) / COUNT(DISTINCT o.orderNumber), 2) AS panier_moyen
FROM customers c
JOIN orders o ON o.customerNumber = c.customerNumber
JOIN orderdetails od ON od.orderNumber = o.orderNumber
GROUP BY c.customerNumber, c.customerName, c.country
ORDER BY panier_moyen DESC
LIMIT 5;

-- CA par client (Top 5)
SELECT 
  c.customerNumber, c.customerName, c.country,
  ROUND(SUM(od.priceEach * od.quantityOrdered), 2) AS CA_total
FROM customers c
JOIN orders o ON o.customerNumber = c.customerNumber
JOIN orderdetails od ON od.orderNumber = o.orderNumber
GROUP BY c.customerNumber, c.customerName, c.country
ORDER BY CA_total DESC
LIMIT 5;

-- Bénéfice par client (Top 5)
SELECT 
  c.customerNumber, c.customerName, c.country,
  ROUND(SUM((od.priceEach - p.buyPrice) * od.quantityOrdered), 2) AS benefice_total
FROM customers c
JOIN orders o ON o.customerNumber = c.customerNumber
JOIN orderdetails od ON od.orderNumber = o.orderNumber
JOIN products p ON p.productCode = od.productCode
GROUP BY c.customerNumber, c.customerName, c.country
ORDER BY benefice_total DESC
LIMIT 5;

-- Clients n'ayant jamais commandé
SELECT c.customerNumber, c.customerName
FROM customers c
WHERE c.customerNumber NOT IN (SELECT o.customerNumber FROM orders o);

-- Clients ayant commandé mais n'ayant jamais payé
SELECT c.customerNumber, c.customerName
FROM customers c
WHERE c.customerNumber IN (SELECT o.customerNumber FROM orders o)
  AND c.customerNumber NOT IN (SELECT p.customerNumber FROM payments p);

-- Délai moyen de paiement (en jours)
SELECT 
  ROUND(AVG(DATEDIFF(p.paymentDate, o.orderDate)), 2) AS retard_paiement_moyen_jours
FROM orders o
JOIN payments p ON o.customerNumber = p.customerNumber
WHERE p.paymentDate IS NOT NULL
  AND o.orderDate IS NOT NULL;

-- Clients ayant mis plus de 10 jours à payer (basé sur dernières dates)
SELECT 
  c.customerNumber,
  c.customerName,
  c.country,
  MAX(o.orderDate) AS derniere_commande,
  MAX(p.paymentDate) AS dernier_paiement,
  DATEDIFF(MAX(p.paymentDate), MAX(o.orderDate)) AS delai_jours
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN payments p ON c.customerNumber = p.customerNumber
GROUP BY c.customerNumber, c.customerName, c.country
HAVING DATEDIFF(MAX(p.paymentDate), MAX(o.orderDate)) > 10
ORDER BY delai_jours DESC;

-- Top 5 clients par CA + vendeur associé
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

-- Top 5 clients par bénéfice + vendeur associé
SELECT 
  c.customerNumber,
  c.customerName,
  CONCAT(e.firstName, ' ', e.lastName) AS vendeur,
  ROUND(SUM((od.priceEach - p.buyPrice) * od.quantityOrdered), 2) AS benefice_total
FROM customers c
JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber
JOIN orders o ON o.customerNumber = c.customerNumber
JOIN orderdetails od ON od.orderNumber = o.orderNumber
JOIN products p ON p.productCode = od.productCode
GROUP BY c.customerNumber, c.customerName, vendeur
ORDER BY benefice_total DESC
LIMIT 5;


-- =============================================================
--  Solde dû par client vs limite de crédit (version robuste)
--  Evite la double-comptabilisation des paiements due aux jointures.
--  Astuce : on pré-agrège ventes et paiements par client puis on joint.
-- =============================================================
SELECT 
  c.customerNumber,
  c.customerName,
  c.creditLimit,
  IFNULL(v.total_commandes, 0) AS total_commandes,
  IFNULL(p.total_paye, 0) AS total_paye,
  ROUND(IFNULL(v.total_commandes, 0) - IFNULL(p.total_paye, 0), 2) AS solde_du
FROM customers c
LEFT JOIN (
  SELECT o.customerNumber,
         ROUND(SUM(od.priceEach * od.quantityOrdered), 2) AS total_commandes
  FROM orders o
  JOIN orderdetails od ON od.orderNumber = o.orderNumber
  GROUP BY o.customerNumber
) v ON v.customerNumber = c.customerNumber
LEFT JOIN (
  SELECT customerNumber,
         ROUND(SUM(amount), 2) AS total_paye
  FROM payments
  GROUP BY customerNumber
) p ON p.customerNumber = c.customerNumber
-- Pour n'afficher que les clients qui dépassent la limite de crédit :
-- HAVING solde_du > c.creditLimit
ORDER BY solde_du DESC;
