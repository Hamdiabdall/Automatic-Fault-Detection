# 🔧 Système de Détection Automatique de Défauts
## Machines Industrielles - Classification par Réseaux de Neurones

[![MATLAB](https://img.shields.io/badge/MATLAB-R2020a%2B-orange.svg)](https://www.mathworks.com/products/matlab.html)
[![Neural Network Toolbox](https://img.shields.io/badge/Toolbox-Neural%20Network-blue.svg)](https://www.mathworks.com/products/deep-learning.html)
[![Status](https://img.shields.io/badge/Status-Production%20Ready-brightgreen.svg)]()

---

## 📋 Vue d'Ensemble

Ce système automatisé permet la **détection intelligente de défauts** sur deux machines industrielles à partir de l'analyse de données vibratoires. Il combine l'extraction de caractéristiques, la sélection d'indicateurs optimaux et la classification par réseaux de neurones pour fournir un diagnostic automatique fiable.

### 🎯 Objectifs
- ✅ **Classification binaire** : Sain vs Défectueux
- ✅ **Automatisation complète** : De l'acquisition au diagnostic
- ✅ **Interface utilisateur** : IHM intuitive pour les opérateurs
- ✅ **Validation industrielle** : Métriques de performance détaillées
- ✅ **Reporting automatique** : Génération de rapports techniques

---

## 🏗️ Architecture du Système

```
📦 Système de Détection de Défauts
├── 🚀 MAIN_Projet_Detection_Defauts.m    # Lanceur principal
├── 📊 01_Preparation_Donnees.m             # Préparation des données
├── 🧠 02_Entrainement_Reseau.m            # Entraînement IA
├── ✅ 03_Validation_Test.m                 # Tests et validation
├── 🖥️ IHM_Detection_Defauts.m             # Interface utilisateur
├── 📄 04_Rapport_Industriel.m             # Générateur de rapports
└── 📚 README.md                           # Cette documentation
```

---

## 🗃️ Structure des Données

### Machine 1 (4 conditions)
```
machine1/
├── 📁 Fonc_Defaut_Eng_Dn/          # Défaut roulement bas (72 fichiers)
├── 📁 Fonc_Defaut_Inner_et_Eng_Dn/ # Défaut piste interne + bas (71 fichiers)
├── 📁 Fonc_Defaut_R_Combo/         # Défaut éléments roulants (71 fichiers)
└── 📁 Fonc_Sain_2/                 # Condition saine (71 fichiers)
```

### Machine 2 (3 conditions)
```
machine 2/
├── 📁 M2_VRAI_Mesures_BILL/        # Défauts bille (71 fichiers)
├── 📁 M2_VRAI_Mesures_OUTER/       # Défauts piste externe (71 fichiers)
└── 📁 M2_VRAI_Mesures_Sain/        # Condition saine (71 fichiers)
```

### Format des Fichiers
- **Extension** : `.csv`
- **Colonnes** : `[timestamp, acceleration]`
- **Taille** : ~376KB (Machine 1), ~354KB (Machine 2)
- **Échantillons** : ~25,600 points par fichier

---

## 🔬 Indicateurs Vibratoires

Le système extrait **8 indicateurs** par fichier :

| N° | Indicateur | Description | Formule |
|----|------------|-------------|---------|
| 1  | **Énergie (E)** | Énergie totale du signal | `Σ(x²)` |
| 2  | **Puissance (P)** | Puissance moyenne | `(1/N) × Σ(x²)` |
| 3  | **Pic (SCRETE)** | Amplitude maximale | `max(|x|)` |
| 4  | **Moyenne** | Valeur moyenne | `(1/N) × Σ(x)` |
| 5  | **RMS (SEFF)** | Valeur efficace | `√[(1/N) × Σ(x-μ)²]` |
| 6  | **Kurtosis (KURT)** | Coefficient d'aplatissement | `E[(x-μ)⁴]/σ⁴` |
| 7  | **Facteur Crête (FCRETE)** | Ratio pic/RMS | `SCRETE/SEFF` |
| 8  | **Facteur K (FK)** | Produit pic×RMS | `SCRETE×SEFF` |

---

## 🚀 Guide d'Utilisation Rapide

### 1️⃣ Installation
```matlab
% 1. Cloner ou télécharger le projet
% 2. Ouvrir MATLAB dans le dossier du projet
% 3. Vérifier les toolboxes :
ver  % Neural Network Toolbox requis
```

### 2️⃣ Lancement Rapide
```matlab
% Exécuter le script principal
MAIN_Projet_Detection_Defauts
```

### 3️⃣ Workflow Complet
1. **Préparation** : Option 1 - Chargement et normalisation des données
2. **Entraînement** : Option 2 - Formation des réseaux de neurones
3. **Validation** : Option 3 - Tests de performance
4. **Interface** : Option 4 - Utilisation de l'IHM
5. **Rapport** : Option 7 - Génération du rapport industriel

---

## 🖥️ Interface Utilisateur (IHM)

### Fonctionnalités Principales
- 📂 **Chargement** : Données préparées et réseaux entraînés
- ⚙️ **Configuration** : Sélection machine (1 ou 2)
- ☑️ **Sélection** : Choix des indicateurs à utiliser
- 📁 **Test** : Chargement de fichiers CSV pour diagnostic
- 🎯 **Diagnostic** : Classification automatique avec confiance
- 📊 **Visualisation** : Graphiques des signaux et résultats
- 📝 **Journal** : Historique des actions et résultats

### Utilisation de l'IHM
```matlab
% Lancer l'interface graphique
IHM_Detection_Defauts()

% Ou via le menu principal (Option 4)
MAIN_Projet_Detection_Defauts
```

---

## 🧠 Architecture des Réseaux de Neurones

### Configuration
- **Type** : Feedforward (Perceptron multicouche)
- **Couches cachées** : 2 couches [15, 10 neurones]
- **Activation** : `tansig` (tangente hyperbolique)
- **Sortie** : `purelin` (linéaire)
- **Entraînement** : Levenberg-Marquardt (`trainlm`)

### Division des Données
- **Entraînement** : 70%
- **Validation** : 15%
- **Test** : 15%

### Performance Cible
- **Précision** : ≥ 90% (Excellent)
- **Rappel** : ≥ 85%
- **F1-Score** : ≥ 87%

---

## 📊 Sélection de Caractéristiques

### Méthode Fisher
Le système utilise le **critère de Fisher** pour optimiser la sélection d'indicateurs :

```
J(Fisher) = (μ₁ - μ₂)² / (σ₁² + σ₂²)
```

### Options Disponibles
- **SELECTION.m** : Réduction 8→4 indicateurs
- **SELECTION2.m** : Réduction 8→3 indicateurs

### Scripts Dédiés
```
matrice de donnée +selection1/
└── SELECTION.m      # Analyse Fisher 8→4

matrice de donnée +selection2/
└── SELECTION2.m     # Analyse Fisher 8→3
```

---

## 📈 Métriques de Performance

### Indicateurs Calculés
- **Précision Globale** : `(VP + VN) / Total`
- **Précision par Classe** : `VP / (VP + FP)`
- **Rappel (Sensibilité)** : `VP / (VP + FN)`
- **F1-Score** : `2 × (Précision × Rappel) / (Précision + Rappel)`
- **Spécificité** : `VN / (VN + FP)`

### Visualisations
- 📊 Matrices de confusion
- 📈 Courbes ROC
- 📉 Histogrammes des prédictions
- 🎯 Distribution des classes

---

## 📄 Système de Reporting

### Formats Générés
- **📄 Rapport Texte** : `Rapport_Detection_Defauts_YYYY-MM-DD_HH-MM-SS_Rapport.txt`
- **🌐 Résumé HTML** : `Rapport_Detection_Defauts_YYYY-MM-DD_HH-MM-SS_Summary.html`
- **🖼️ Graphiques PNG** : Visualisations haute résolution

### Contenu du Rapport
1. **Résumé Exécutif**
2. **Analyse des Données**
3. **Performances des Réseaux**
4. **Recommandations**
5. **Visualisations Techniques**

---

## 🔧 Fonctions Utilitaires

### Outils de Diagnostic
- **Vérification d'Intégrité** : Contrôle des fichiers de données
- **Test Fichier Spécifique** : Diagnostic d'un CSV individuel
- **Statistiques Datasets** : Analyse détaillée des données

### Visualisations
- **Comparaison Signaux** : Sain vs Défectueux
- **Histogrammes** : Distribution des indicateurs
- **Analyse CSV** : Visualisation de fichiers individuels

---

## ⚙️ Configuration Technique

### Prérequis MATLAB
```matlab
% Version recommandée
MATLAB R2020a ou supérieur

% Toolboxes requises
Neural Network Toolbox
Statistics and Machine Learning Toolbox (optionnel)
```

### Mémoire et Performance
- **RAM** : 4GB minimum, 8GB recommandé
- **Stockage** : ~50MB pour le projet
- **Temps d'exécution** : 
  - Préparation : ~2-5 minutes
  - Entraînement : ~5-10 minutes
  - Validation : ~2-3 minutes

---

## 📁 Fichiers Générés

### Données Principales
```
📄 Donnees_Preparees.mat        # Données normalisées
📄 Reseaux_Entraines.mat        # Modèles entraînés
📄 Resultats_Validation.mat     # Métriques de performance
```

### Rapports
```
📁 Rapport_Industriel/
├── 📄 *_Rapport.txt           # Rapport technique complet
├── 🌐 *_Summary.html          # Résumé interactif
├── 🖼️ *_01_Datasets.png       # Vue d'ensemble données
├── 🖼️ *_02_Indicateurs_M1.png # Distribution indicateurs
├── 🖼️ *_03_Correlations.png   # Matrices de corrélation
└── 🖼️ *_04_Performances.png   # Résultats performances
```

---

## 🛠️ Maintenance et Évolution

### Bonnes Pratiques
- **Backup** : Sauvegarder régulièrement les modèles entraînés
- **Monitoring** : Surveiller les performances en production
- **Mise à jour** : Réentraîner avec nouvelles données
- **Documentation** : Tenir à jour les modifications

### Améliorations Futures
- [ ] Classification multi-classes (plus de 2 états)
- [ ] Intégration temps réel
- [ ] Interface web
- [ ] Base de données historique
- [ ] Alertes automatiques
- [ ] API REST

---

## 🐛 Résolution de Problèmes

### Erreurs Communes

#### ❌ "Données non préparées"
```matlab
% Solution : Exécuter d'abord la préparation
run('01_Preparation_Donnees.m')
```

#### ❌ "Réseaux non entraînés"
```matlab
% Solution : Entraîner les modèles
run('02_Entrainement_Reseau.m')
```

#### ❌ "Fichier CSV invalide"
```matlab
% Vérifier le format : 2 colonnes (timestamp, acceleration)
data = importdata('fichier.csv');
size(data)  % Doit afficher [N, 2]
```

#### ❌ "Toolbox manquante"
```matlab
% Vérifier l'installation
ver  % Rechercher 'Neural Network Toolbox'
```

---

## 📞 Support et Contact

### Documentation Technique
- **Guide Utilisateur** : Ce fichier README.md
- **Code Source** : Commenté dans chaque script
- **Exemples** : Intégrés dans le système

### Ressources
- **MATLAB Documentation** : [mathworks.com](https://www.mathworks.com)
- **Neural Networks** : [Deep Learning Toolbox](https://www.mathworks.com/products/deep-learning.html)

---

## 📜 Licence et Crédits

### Système
- **Version** : 1.0
- **Date** : 2025
- **Environnement** : MATLAB

### Composants
- **Classification** : Réseaux de neurones feedforward
- **Sélection** : Critère de Fisher
- **Interface** : MATLAB GUI (GUIDE)
- **Rapports** : HTML + TXT + PNG

---

## 🏁 Conclusion

Ce système représente une **solution complète et industrialisée** pour la détection automatique de défauts sur machines tournantes. Il combine :

- ✅ **Robustesse** : Validation sur deux machines différentes
- ✅ **Performance** : Précision >90% en conditions optimales
- ✅ **Facilité d'usage** : Interface graphique intuitive
- ✅ **Automatisation** : Workflow complet automatisé
- ✅ **Documentation** : Rapports industriels détaillés

**🎯 Prêt pour déploiement industriel !**

---

*📧 Pour toute question technique, consulter la documentation intégrée dans chaque script MATLAB.*
