-- =============================================================
--  REQUÊTES VENTES – Toys & Models
-- =============================================================

-- CA Global
SELECT ROUND(SUM(quantityOrdered * priceEach), 2) AS CA_total
FROM orderdetails;

-- Chiffre d’affaires par mois – 2021
SELECT EXTRACT(MONTH FROM o.orderDate) AS mois,
       ROUND(SUM(od.quantityOrdered * od.priceEach), 2) AS CA_total
FROM orders o
JOIN orderdetails od ON od.orderNumber = o.orderNumber
WHERE EXTRACT(YEAR FROM o.orderDate) = 2021
GROUP BY mois
ORDER BY mois;

-- Chiffre d’affaires par mois – 2022
SELECT EXTRACT(MONTH FROM o.orderDate) AS mois,
       ROUND(SUM(od.quantityOrdered * od.priceEach), 2) AS CA_total
FROM orders o
JOIN orderdetails od ON od.orderNumber = o.orderNumber
WHERE EXTRACT(YEAR FROM o.orderDate) = 2022
GROUP BY mois
ORDER BY CA_total DESC;

-- Chiffre d’affaires par mois – 2023
SELECT EXTRACT(MONTH FROM o.orderDate) AS mois,
       ROUND(SUM(od.quantityOrdered * od.priceEach), 2) AS CA_total
FROM orders o
JOIN orderdetails od ON od.orderNumber = o.orderNumber
WHERE EXTRACT(YEAR FROM o.orderDate) = 2023
GROUP BY mois
ORDER BY CA_total DESC;

-- Top 5 produits les plus vendus (en quantité)
SELECT p.productCode, p.productName,
       SUM(od.quantityOrdered) AS quantity,
       pl.productLine
FROM products p
JOIN orderdetails od ON od.productCode = p.productCode
JOIN productlines pl ON pl.productLine = p.productLine
GROUP BY p.productCode, p.productName, pl.productLine
ORDER BY quantity DESC
LIMIT 5;

-- Top 5 produits les plus vendus (en valeur)
SELECT p.productCode, p.productLine, p.productName,
       ROUND(SUM(od.priceEach * od.quantityOrdered), 2) AS revenu_$
FROM products p
JOIN orderdetails od ON od.productCode = p.productCode
GROUP BY p.productCode, p.productLine, p.productName
ORDER BY revenu_$ DESC
LIMIT 5;

-- Top 5 des produits qui rapportent le plus de bénéfice
SELECT p.productCode, p.productLine, p.productName,
       ROUND(SUM(od.priceEach * od.quantityOrdered), 2) AS revenu_$,
       ROUND(SUM((od.priceEach - p.buyPrice) * od.quantityOrdered), 2) AS benefice_$
FROM products p
JOIN orderdetails od ON od.productCode = p.productCode
GROUP BY p.productCode, p.productLine, p.productName
ORDER BY benefice_$ DESC
LIMIT 5;

-- Top 5 catégories les plus vendues (en quantité)
SELECT pl.productLine,
       SUM(od.quantityOrdered) AS total_quantity
FROM productlines pl
JOIN products p ON p.productLine = pl.productLine
JOIN orderdetails od ON od.productCode = p.productCode
GROUP BY pl.productLine
ORDER BY total_quantity DESC
LIMIT 5;

-- Top 5 catégories les plus vendues (en valeur)
SELECT p.productLine,
       ROUND(SUM(od.priceEach * od.quantityOrdered), 2) AS revenu_$
FROM products p
JOIN orderdetails od ON od.productCode = p.productCode
GROUP BY p.productLine
ORDER BY revenu_$ DESC
LIMIT 5;

-- Panier moyen (CA par commande)
SELECT ROUND(SUM(od.quantityOrdered * od.priceEach) / COUNT(DISTINCT o.orderNumber), 2) AS panier_moyen
FROM orderdetails od
JOIN orders o ON o.orderNumber = od.orderNumber;

-- Panier moyen (CA par commande) – par année
SELECT EXTRACT(YEAR FROM o.orderDate) AS annee,
       ROUND(SUM(od.quantityOrdered * od.priceEach) / COUNT(DISTINCT o.orderNumber), 2) AS panier_moyen
FROM orderdetails od
JOIN orders o ON o.orderNumber = od.orderNumber
GROUP BY annee
ORDER BY annee;

-- TOP 10 des produits avec la plus grande marge (%)
-- formule marge : ((CA - Coût) / CA) × 100
SELECT 
  p.productCode, 
  p.productLine, 
  p.productName,
  ROUND(SUM(od.priceEach * od.quantityOrdered), 2) AS revenu_$,
  ROUND(SUM(p.buyPrice * od.quantityOrdered), 2) AS cout_achat_$,
  ROUND(
    (SUM(od.priceEach * od.quantityOrdered) - SUM(p.buyPrice * od.quantityOrdered)) 
    / NULLIF(SUM(od.priceEach * od.quantityOrdered), 0) * 100, 2
  ) AS marge
FROM products p
JOIN orderdetails od ON od.productCode = p.productCode
GROUP BY p.productCode, p.productLine, p.productName
ORDER BY marge DESC
LIMIT 10;
