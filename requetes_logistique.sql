-- =============================================================
--  REQUÊTES LOGISTIQUE – Toys & Models
--  Auteur : Eric Raoelison
--  Objet : KPI + listes opérationnelles (expédition, retards, statuts)
--  Remarques :
--    - Utilise des guillemets simples pour les valeurs de statut.
--    - Adapte les clauses WHERE au besoin (dates, pays, etc.).
-- =============================================================


/*--------------------------------------------------------------
  1) CLASSIFICATION PAR COMMANDE (vue détaillée par ligne)
----------------------------------------------------------------*/
-- Statut de livraison par commande (liste)
SELECT
  orderNumber,
  orderDate,
  requiredDate,
  shippedDate,
  CASE
    WHEN shippedDate IS NULL THEN 'Non expédiée'
    WHEN shippedDate > requiredDate THEN 'En retard'
    ELSE 'À l’heure'
  END AS statut_livraison
FROM orders;


/*--------------------------------------------------------------
  2) KPI RÉCAPITULATIFS
----------------------------------------------------------------*/
-- 2.1 Répartition par statut (vue d’ensemble)
SELECT
  status,
  COUNT(*) AS nb_commandes
FROM orders
GROUP BY status
ORDER BY nb_commandes DESC;

-- 2.2 Nombre de commandes expédiées
SELECT COUNT(*) AS nb_expediees
FROM orders
WHERE status = 'Shipped';

-- 2.3 Nombre de commandes annulées
SELECT COUNT(*) AS nb_annulees
FROM orders
WHERE status = 'Cancelled';

-- 2.4 Nombre de commandes en attente
SELECT COUNT(*) AS nb_on_hold
FROM orders
WHERE status = 'On Hold';

-- 2.5 Nombre de commandes non expédiées (backlog)
--    Variante A (basée sur la date d’expédition manquante) : 
SELECT COUNT(*) AS nb_non_expediees
FROM orders
WHERE shippedDate IS NULL;
--    Variante B (basée sur le statut différent de 'Shipped') :
SELECT COUNT(*) AS nb_non_expediees_alt
FROM orders
WHERE status <> 'Shipped';

-- 2.6 Volume de commandes en retard (expédiées après requiredDate)
SELECT COUNT(*) AS nb_en_retard
FROM orders
WHERE shippedDate IS NOT NULL
  AND shippedDate > requiredDate;

-- 2.7 Taux de retard (%)
SELECT ROUND(
  SUM(CASE WHEN shippedDate > requiredDate THEN 1 ELSE 0 END) / COUNT(*) * 100, 2
) AS taux_retard_pct
FROM orders
WHERE shippedDate IS NOT NULL;

-- 2.8 Délai moyen d’expédition (jours entre commande et expédition)
SELECT ROUND(AVG(DATEDIFF(shippedDate, orderDate)), 2) AS delai_moyen_livraison_jours
FROM orders
WHERE shippedDate IS NOT NULL;

-- 2.9 Évolution mensuelle du taux de retard
SELECT
  DATE_FORMAT(orderDate, '%Y-%m') AS mois,
  SUM(CASE WHEN shippedDate > requiredDate THEN 1 ELSE 0 END) AS nb_en_retard,
  COUNT(*) AS nb_expediees,
  ROUND(SUM(CASE WHEN shippedDate > requiredDate THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS taux_retard_pct
FROM orders
WHERE shippedDate IS NOT NULL
GROUP BY mois
ORDER BY mois;


/*--------------------------------------------------------------
  3) LISTES OPÉRATIONNELLES
----------------------------------------------------------------*/
-- 3.1 Commandes en retard (liste détaillée)
SELECT
  orderNumber,
  orderDate,
  requiredDate,
  shippedDate
FROM orders
WHERE shippedDate IS NOT NULL
  AND shippedDate > requiredDate
ORDER BY shippedDate DESC;

-- 3.2 Commandes en attente (liste)
SELECT
  orderNumber,
  orderDate,
  requiredDate,
  status
FROM orders
WHERE status = 'On Hold'
ORDER BY orderDate DESC;

-- 3.3 Commandes avec statut “problématique” (comptage par statut)
SELECT
  status,
  COUNT(*) AS nb_commandes
FROM orders
WHERE status IN ('On Hold','Disputed','Cancelled','Resolved')
GROUP BY status
ORDER BY nb_commandes DESC;

-- 3.4 Âge des commandes non expédiées (priorisation du backlog)
SELECT
  orderNumber,
  orderDate,
  DATEDIFF(CURDATE(), orderDate) AS age_jours
FROM orders
WHERE shippedDate IS NULL
ORDER BY age_jours DESC;
