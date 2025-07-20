# 🧪 **GUIDE COMPLET DE TEST - SYSTÈME DE DÉTECTION DE DÉFAUTS**

## 🖥️ **TESTS DANS MATLAB (Interface Graphique)**

### **Méthode 1 : Tests Rapides**
```matlab
% Dans MATLAB Command Window, exécuter ligne par ligne :

% 1. Test complet du système
run('ALL_TESTS_SUITE.m')

% 2. Interface graphique principale
run('fault_detection_gui.m')

% 3. Menu interactif complet
run('main_project_launcher.m')
```

### **Méthode 2 : Pipeline Complet**
```matlab
% Exécution complète étape par étape dans MATLAB :

%% ÉTAPE 1 : Préparation des données
run('data_preparation_complete.m')
% ✅ Résultat attendu : "SUCCESS: Data preparation completed successfully"

%% ÉTAPE 2 : Entraînement des réseaux
run('train_networks.m')
% ✅ Résultat attendu : "TRAINING COMPLETED" avec précision >90%

%% ÉTAPE 3 : Validation des performances
run('validate_networks.m')
% ✅ Résultat attendu : "INDUSTRIAL DEPLOYMENT READY"

%% ÉTAPE 4 : Génération du rapport
run('generate_industrial_report.m')
% ✅ Résultat attendu : Rapports HTML et TXT générés

%% ÉTAPE 5 : Interface utilisateur
run('fault_detection_gui.m')
% ✅ Résultat attendu : Interface graphique s'ouvre
```

### **Méthode 3 : Tests Individuels**
```matlab
% Tests spécifiques de composants :

% Test de chargement de données
data = importdata('machine1/Fonc_Sain_2/acc_00015.csv');
fprintf('Fichier chargé : %dx%d\n', size(data));

% Test de calcul d'indicateurs
signal = data(:,2);
energy = sum(signal.^2);
fprintf('Énergie calculée : %.2e\n', energy);

% Test de réseau (si entraîné)
if exist('trained_networks.mat', 'file')
    load('trained_networks.mat');
    fprintf('Réseaux chargés avec succès\n');
end
```

---

## 💻 **TESTS EN TERMINAL (Ligne de Commande)**

### **Prérequis Terminal**
```bash
# Naviguer vers le dossier du projet
cd /home/hamdi/Desktop/Matlab

# Vérifier la présence de MATLAB
which matlab
```

### **Méthode 1 : Tests Batch (Recommandée)**
```bash
# Test rapide de l'environnement
matlab -batch "run('simple_test.m')"

# Suite complète de tests
matlab -batch "run('ALL_TESTS_SUITE.m')"

# Pipeline complet automatisé
matlab -batch "run('data_preparation_complete.m'); run('train_networks.m'); run('validate_networks.m')"

# Génération de rapport
matlab -batch "run('generate_industrial_report.m')"
```

### **Méthode 2 : Tests Interactifs**
```bash
# Lancer MATLAB en mode interactif
matlab -nodesktop -nosplash

# Puis dans MATLAB (prompt >>):
>> run('simple_test.m')
>> run('ALL_TESTS_SUITE.m')
>> exit
```

### **Méthode 3 : Tests Silencieux**
```bash
# Exécution sans affichage des graphiques
matlab -batch -noFigureWindows "run('data_preparation_complete.m')"

# Test avec sauvegarde des logs
matlab -batch "run('ALL_TESTS_SUITE.m')" > test_results.log 2>&1

# Test avec timeout (5 minutes max)
timeout 300 matlab -batch "run('train_networks.m')"
```

### **Méthode 4 : Tests de Performance**
```bash
# Mesurer le temps d'exécution
time matlab -batch "run('data_preparation_complete.m')"

# Tests multiples pour la robustesse
for i in {1..3}; do
    echo "Test $i"
    matlab -batch "run('simple_test.m')"
done
```

---

## 🔍 **VÉRIFICATION DES RÉSULTATS**

### **Fichiers à Vérifier Après Tests**
```bash
# Vérifier les fichiers générés
ls -la *.mat *.png *.html *.txt

# Vérifier la taille des fichiers critiques
du -h Donnees_Preparees.mat trained_networks.mat validation_results.mat

# Afficher les dernières lignes des logs
tail -20 test_results.log
```

### **Codes de Sortie à Surveiller**
```bash
# Code 0 = Succès
echo $?  # Après chaque commande matlab

# Vérification automatique
if matlab -batch "run('simple_test.m')"; then
    echo "✅ Test réussi"
else
    echo "❌ Test échoué"
fi
```

---

## 🚨 **RÉSOLUTION DES PROBLÈMES COURANTS**

### **Problème : "Invalid text character"**
```matlab
% Solution : Vérifier l'encodage des fichiers
system('file *.m');  % Dans MATLAB
```
```bash
# Solution en terminal
file *.m
grep -l "Invalid" *.m
```

### **Problème : "Toolbox manquant"**
```matlab
% Vérification des toolboxes disponibles
ver  % Liste toutes les toolboxes

% Le système fonctionne SANS toolbox grâce aux implémentations custom
run('simple_test.m')  % Affiche les avertissements mais continue
```

### **Problème : "File not found"**
```bash
# Vérifier la structure des dossiers
find . -name "*.csv" | head -10
find . -name "*.mat" | head -5

# Vérifier les permissions
ls -la *.m
```

---

## 📊 **TESTS DE VALIDATION COMPLÈTE**

### **Script de Test Ultime (Terminal)**
```bash
#!/bin/bash
echo "🧪 DÉBUT DES TESTS COMPLETS"

# Test 1 : Environnement
echo "Test 1 : Environnement..."
matlab -batch "run('simple_test.m')" && echo "✅ Environnement OK" || echo "❌ Environnement KO"

# Test 2 : Données
echo "Test 2 : Suite complète..."
matlab -batch "run('ALL_TESTS_SUITE.m')" && echo "✅ Suite OK" || echo "❌ Suite KO"

# Test 3 : Pipeline
echo "Test 3 : Pipeline complet..."
matlab -batch "run('data_preparation_complete.m'); run('train_networks.m'); run('validate_networks.m')" && echo "✅ Pipeline OK" || echo "❌ Pipeline KO"

echo "🏁 TESTS TERMINÉS"
```

### **Commande One-Shot Complète**
```bash
# Test complet en une commande
matlab -batch "
try
    run('simple_test.m');
    run('data_preparation_complete.m');
    run('train_networks.m');
    run('validate_networks.m');
    run('generate_industrial_report.m');
    fprintf('🎉 TOUS LES TESTS RÉUSSIS!\n');
catch ME
    fprintf('❌ ERREUR: %s\n', ME.message);
end
"
```

---

## ⏱️ **TEMPS D'EXÉCUTION ATTENDUS**

| Test | MATLAB GUI | Terminal | Durée |
|------|------------|----------|-------|
| `simple_test.m` | 5-10s | 10-15s | ⚡ Rapide |
| `ALL_TESTS_SUITE.m` | 15-30s | 20-35s | ⚡ Rapide |
| `data_preparation_complete.m` | 30-60s | 45-75s | 🔄 Moyen |
| `train_networks.m` | 60-120s | 75-135s | 🔄 Moyen |
| `validate_networks.m` | 10-20s | 15-25s | ⚡ Rapide |
| **Pipeline Complet** | **2-4 min** | **3-5 min** | 🔄 **Total** |

---

## 🎯 **RÉSULTATS ATTENDUS PAR TEST**

### **simple_test.m**
```
=== FAULT DETECTION SYSTEM - SIMPLE TEST ===
Test 1: Basic MATLAB functionality...
  Basic math: PASSED
Test 2: Directory structure...
  machine1: EXISTS
  machine2: EXISTS
Test 3: CSV file availability...
  machine1/Fonc_Sain_2: 70 CSV files
  machine2/M2_VRAI_Mesures_Sain: 70 CSV files
Test 4: Single CSV file loading...
  File loaded: 25600x2 matrix
  Signal energy: 7.79e+03
  CSV loading: PASSED

=== SYSTEM READY ===
```

### **ALL_TESTS_SUITE.m**
```
=== SUITE DE TESTS COMPLETE - DETECTION DE DEFAUTS ===
--- TEST 1: ENVIRONNEMENT DE BASE ---
✓ Math de base: OK
⚠ Neural Network Toolbox: Manquant (OK avec implémentation custom)
✓ Statistics functions: Using integrated implementation
✓ TEST 1 REUSSI

--- TEST 2: STRUCTURE DES DONNEES ---
✓ Total fichiers CSV: 490
✓ TEST 2 REUSSI

=== RESUME FINAL DES TESTS ===
Total tests executes: 7
Tests reussis: 7
Tests echoues: 0
Taux de reussite: 100.0%

🎉 TOUS LES TESTS SONT REUSSIS ! 🎉
```

### **data_preparation_complete.m**
```
=== COMPLETE FAULT DETECTION DATA PREPARATION ===
Processing Machine 1 data...
  Processed: 61 healthy samples
  Processed: 183 faulty samples total
Processing Machine 2 data...  
  Processed: 61 healthy samples
  Processed: 122 faulty samples total

=== SUCCESS: Data preparation completed successfully ===
```

### **train_networks.m**
```
=== NEURAL NETWORK TRAINING ===
Neural Network Toolbox not found - Using basic implementation
Training Machine 1 network...
  Training completed in 0.20 seconds
  Final MSE: 0.015324
Training Machine 2 network...
  Training completed in 0.09 seconds  
  Final MSE: 0.071337

=== TRAINING COMPLETED ===
Machine 1: 100.00% accuracy
Machine 2: 94.54% accuracy
```

### **validate_networks.m**
```
=== NEURAL NETWORK VALIDATION ===
Validating Machine 1 network...
  Accuracy: 100.00%
  Precision: 100.00%
  Recall: 100.00%
  F1-Score: 100.00

Validating Machine 2 network...
  Accuracy: 94.54%
  Precision: 85.92%
  Recall: 100.00%
  F1-Score: 92.42

=== INDUSTRIAL DEPLOYMENT READY ===
Both networks achieve >90% accuracy - APPROVED for deployment
```

---

## 🚀 **COMMANDES RAPIDES DE DÉMARRAGE**

### **Test Ultra-Rapide (30 secondes)**
```bash
cd /home/hamdi/Desktop/Matlab
matlab -batch "run('simple_test.m')"
```

### **Test Complet (3-5 minutes)**
```bash
cd /home/hamdi/Desktop/Matlab
matlab -batch "run('ALL_TESTS_SUITE.m'); run('data_preparation_complete.m'); run('train_networks.m'); run('validate_networks.m')"
```

### **Interface Graphique**
```bash
cd /home/hamdi/Desktop/Matlab
matlab -batch "run('fault_detection_gui.m')"
```

---

## 📝 **CHECKLIST DE VALIDATION**

- [ ] ✅ Tests environnement passés (`simple_test.m`)
- [ ] ✅ Suite complète passée (`ALL_TESTS_SUITE.m`)  
- [ ] ✅ Données préparées (`Donnees_Preparees.mat` créé)
- [ ] ✅ Réseaux entraînés (`trained_networks.mat` créé)
- [ ] ✅ Validation réussie (précision >90%)
- [ ] ✅ Rapport généré (`RAPPORT_INDUSTRIEL.html` créé)
- [ ] ✅ Interface graphique fonctionnelle
- [ ] ✅ Fichiers de résultats présents (`.png`, `.mat`)

**🎉 Système 100% opérationnel et prêt pour déploiement industriel !**
