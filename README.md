# 📊 Projet SQL – Toys & Models

---

## 🎯 Objectif
Analyser la base de données **Toys & Models** afin de mesurer la performance commerciale, la rentabilité des produits, le comportement des clients, l’efficacité des vendeurs et la qualité logistique.  
Ce projet est une première étape avant la construction d’un **dashboard interactif dans Tableau**.

---

## 🗂️ Jeu de données
Base relationnelle composée de 8 tables principales :
- **customers** : informations clients
- **orders** & **orderdetails** : commandes et détails de commandes
- **products** & **productlines** : produits et catégories
- **payments** : paiements clients
- **employees** & **offices** : structure RH et commerciale
---

## 🗺️ Schéma relationnel

Voici la structure de la base de données **Toys & Models** :  

![Schéma de la base Toys & Models](diagram_toys_models.png)

---

## 🔍 Analyses réalisées

### 1️⃣ Analyse Ventes
- Chiffre d’affaires global et par mois/année
- Top 5 produits et catégories (quantité, valeur, bénéfice)
- Panier moyen global et par année
- Produits avec les meilleures marges

### 2️⃣ Analyse Clients
- Nombre total de clients et répartition par pays
- CA et bénéfice par client
- Panier moyen par client
- Identification des clients inactifs ou mauvais payeurs
- Retards et délais de paiement

### 3️⃣ Analyse RH
- Nombre total d’employés
- Répartition par poste et par pays
- CA généré par vendeur
- Nombre de clients par vendeur
- Association des meilleurs clients avec leur vendeur

### 4️⃣ Analyse Logistique
- Statut des commandes (livrées, en retard, annulées, en attente…)
- Délai moyen de livraison
- Suivi du solde dû par client vs limite de crédit

---

## 🛠️ Compétences SQL mobilisées
- Agrégations et KPI : `SUM`, `COUNT`, `AVG`, `ROUND`, `GROUP BY`, `HAVING`
- Analyse temporelle : `EXTRACT`, `DATEDIFF`
- Jointures multi-tables : `INNER JOIN`, `LEFT JOIN`
- Fonctions conditionnelles : `CASE WHEN`, `IFNULL`, `NULLIF`
- Sous-requêtes : clients sans commandes, clients sans paiements
- Calculs métiers : CA, bénéfices, marges, solde dû

---

---

## 📈 Dashboard interactif (Tableau)

Un dashboard réalisé avec Tableau pour visualiser les KPI commerciaux et clients :  
🔗 https://public.tableau.com/app/profile/eric.raoelison/viz/ToysModels_17583024820730/SalesDashboard

---

### Points clés :
- Vue consolidée des performances 2022 vs 2023
- Top clients par profit avec exploration dynamique
- Filtres interactifs (par année, client, pays,produit et catégorie)

---

## 📊 Analyse Vente et Client – Toys & Models (2022–2023)

---

### 📈 Analyse globale des ventes

<img width="900" src="https://github.com/user-attachments/assets/f2030ae8-b9d3-4b84-ab26-233f4ab3fc24" alt="Catégories" />

- **Chiffre d’affaires** : $4 225K → +13,7%  
- **Profit** : $1 692K → +14,5%  
- **Quantités vendues** : 46K → +13%

👉 Cette croissance est principalement due à une **hausse des quantités vendues**, car les prix sont restés constants. L’augmentation du CA n’est donc **pas liée à une stratégie tarifaire**, mais bien à l’**accroissement du volume des ventes**.

---

### 🧩 Analyse des catégories de produits

<img width="900" src="https://github.com/user-attachments/assets/4ce1e329-9a67-4252-947c-ec10373f84f5" alt="Marges" />

- **Classic Cars** domine les ventes, suivie de **Motorcycles** et **Planes**.  
- **Classic Cars = 40%** du chiffre d’affaires et du profit global :  
  - CA : $1 704K → +12,5%  
  - Profit : $681K → +14,5%

---

### 💰 Analyse des marges (produits à forte rentabilité)

<img width="900" src="https://github.com/user-attachments/assets/d85dd82d-f4c4-4606-82f6-a5c475ecd3d1" alt="Profit par pays" />

- Sur les **10 produits les plus rentables**, 4 proviennent de Classic Cars.  
- Le modèle **1961 Chevrolet Impala** affiche une **marge de 56,27%**.

---

### 🌎 Analyse géographique – Classic Cars

<img width="900" src="https://github.com/user-attachments/assets/1f4c98fa-f4cc-4021-bd6a-c512f359c026" alt="Classic Cars USA" />

- **USA** : $603K de profit, dont $203K via Classic Cars (37% du profit USA)

<img width="900" src="https://github.com/user-attachments/assets/0df72316-1927-4ef2-9f8e-f43fa1454594" alt="Clients Actifs/Inactifs" />

- Plusieurs pays misent fortement sur cette catégorie.  
  **Exemple** :  
  - **France** : $162K de profit  
  - Dont **$63K via Classic Cars**  
  - Produit phare : **1969 Dodge Charger → $7K** de profit

---

### 🧑‍💼 Analyse des clients

<img width="900" height="173" alt="image" src="https://github.com/user-attachments/assets/d4a7787c-be69-4252-96c7-32cba685219c" />


- **Clients actifs** : 86 → +4,9%  
- **Clients inactifs** : 12 → –25%

👉 La hausse du nombre de clients **explique directement** la hausse du volume de commandes, et donc la croissance du CA.

---

### 🥇 Top clients

Top clients 2023

<img width="900" height="300" alt="image" src="https://github.com/user-attachments/assets/f9f17d19-bff9-45b2-af42-3910de72777e" /> 

Top clients 2022

<img width="900" height="343" alt="image" src="https://github.com/user-attachments/assets/040d01dd-814d-4321-9a46-e5d47c6d6da9" />



- **Top 2 clients (2022 et 2023)** inchangés mais en hausse :
  - **Euro + Shopping Channel** : $364K → +74%
  - **Mini Gift Distributor Ltd** : $282K → +41%

- **7 nouveaux clients** dans le Top 10 de 2023  
  → preuve de la forte contribution des **nouveaux clients à la croissance**.

---

### ⏱️ Analyse des délais de paiement

<img width="900" src="https://github.com/user-attachments/assets/19a61f0f-0be4-4d8c-8aad-47002aae1030" alt="Max Delay" />

- **Reims Collectables** : délai de paiement le plus long → **26 jours**

<img width="900" src="https://github.com/user-attachments/assets/7f465c83-1a0e-444a-ba13-a3abacc08d08" alt="Euro Shopping Delay" />

- **Euro + Shopping Channel** : délai **négatif de –47j** (commande passée **après** le dernier paiement)  
  → balance positive de $130K  
  → mais reste le **client le plus rentable** → **pas un client à risque**

---

### 🧲 Recommandations – Activer les clients inactifs

<img width="900" src="https://github.com/user-attachments/assets/27fcd116-208b-476c-b196-e20bd62453a4" alt="Clients inactifs" />

👉 Prospecter les **clients inactifs** comme **Alpha Cognac (France)**

#### Recommandation produit :

<img width="900" src="https://github.com/user-attachments/assets/2d7f58fa-4577-4fd4-be9c-f1e8294cf60f" alt="Vintage Cars" />

- **Vintage Cars** en France : +110% de CA → forte croissance

<img width="900" src="https://github.com/user-attachments/assets/a49705f2-1e3d-4b71-af71-1249fbb366d8" alt="Mercedes SSK" />

- Recommander **1928 Mercedes-Benz SSK** (marge : 50,44%)

<img width="900" src="https://github.com/user-attachments/assets/e903e36a-0d03-4943-8647-748ae5341afa" alt="Harley Davidson" />

- Recommander **1936 Harley Davidson El Knucklehead** (marge : 56,75%)

Ces propositions peuvent **convertir un client inactif en actif**, avec un argumentaire basé sur la **rentabilité produit**.

---

### 📊 Récapitulatif des KPI

- **Chiffre d’affaires** : $4 225K → +13,7%  
- **Profit** : $1 692K → +14,5%  
- **Quantités vendues** : 46K → +13%  
- **Clients actifs** : 86 → +4,9%  
- **Clients inactifs** : 12 → –25%
