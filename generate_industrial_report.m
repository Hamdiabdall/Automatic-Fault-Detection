clear all
close all
clc

fprintf('=== GENERATION RAPPORT INDUSTRIEL ===\n')

%% Configuration
report_title = 'RAPPORT INDUSTRIEL - DETECTION AUTOMATIQUE DE DEFAUTS';
report_date = datestr(now, 'dd/mm/yyyy');
report_time = datestr(now, 'HH:MM');

%% Verification des donnees requises
required_files = {'Donnees_Preparees.mat', 'trained_networks.mat', 'validation_results.mat'};
missing_files = {};

for i = 1:length(required_files)
    if ~exist(required_files{i}, 'file')
        missing_files{end+1} = required_files{i};
    end
end

if ~isempty(missing_files)
    fprintf('ATTENTION: Fichiers manquants pour le rapport complet:\n');
    for i = 1:length(missing_files)
        fprintf('  - %s\n', missing_files{i});
    end
    fprintf('Execution du pipeline requis...\n');
    
    % Executer le pipeline minimal
    if exist('simple_test.m', 'file')
        run('simple_test.m');
    end
    if exist('data_preparation_complete.m', 'file') && ~exist('Donnees_Preparees.mat', 'file')
        run('data_preparation_complete.m');
    end
    if exist('train_networks.m', 'file') && ~exist('trained_networks.mat', 'file')
        run('train_networks.m');
    end
    if exist('validate_networks.m', 'file') && ~exist('validation_results.mat', 'file')
        run('validate_networks.m');
    end
end

%% Chargement des donnees
fprintf('Chargement des donnees pour le rapport...\n');

try
    load('Donnees_Preparees.mat');
    fprintf('  Donnees preparees: OK\n');
    data_loaded = true;
catch
    fprintf('  Donnees preparees: NON DISPONIBLES\n');
    data_loaded = false;
end

try
    load('trained_networks.mat');
    fprintf('  Reseaux entraines: OK\n');
    networks_loaded = true;
catch
    fprintf('  Reseaux entraines: NON DISPONIBLES\n');
    networks_loaded = false;
end

try
    load('validation_results.mat');
    fprintf('  Resultats validation: OK\n');
    validation_loaded = true;
catch
    fprintf('  Resultats validation: NON DISPONIBLES\n');
    validation_loaded = false;
end

%% Generation du rapport HTML
html_filename = 'RAPPORT_INDUSTRIEL.html';
fprintf('Generation du rapport HTML: %s\n', html_filename);

fid = fopen(html_filename, 'w');
if fid == -1
    error('Impossible de creer le fichier HTML');
end

% En-tete HTML
fprintf(fid, '<!DOCTYPE html>\n<html>\n<head>\n');
fprintf(fid, '<meta charset="UTF-8">\n');
fprintf(fid, '<title>%s</title>\n', report_title);
fprintf(fid, '<style>\n');
fprintf(fid, 'body { font-family: Arial, sans-serif; margin: 40px; }\n');
fprintf(fid, 'h1 { color: #2E86AB; border-bottom: 3px solid #2E86AB; }\n');
fprintf(fid, 'h2 { color: #A23B72; border-bottom: 1px solid #A23B72; }\n');
fprintf(fid, 'h3 { color: #F18F01; }\n');
fprintf(fid, '.metric { background: #f0f8ff; padding: 10px; border-left: 4px solid #2E86AB; margin: 10px 0; }\n');
fprintf(fid, '.success { color: #28a745; font-weight: bold; }\n');
fprintf(fid, '.warning { color: #ffc107; font-weight: bold; }\n');
fprintf(fid, '.error { color: #dc3545; font-weight: bold; }\n');
fprintf(fid, 'table { border-collapse: collapse; width: 100%%; }\n');
fprintf(fid, 'th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }\n');
fprintf(fid, 'th { background-color: #2E86AB; color: white; }\n');
fprintf(fid, '</style>\n</head>\n<body>\n');

% Titre principal
fprintf(fid, '<h1>%s</h1>\n', report_title);
fprintf(fid, '<p><strong>Date:</strong> %s &nbsp;&nbsp;&nbsp; <strong>Heure:</strong> %s</p>\n', report_date, report_time);

% Section 1: Objectif et contexte
fprintf(fid, '<h2>1. OBJECTIF ET CONTEXTE</h2>\n');
fprintf(fid, '<p>Ce projet vise à développer un système automatisé de détection de défauts sur deux machines industrielles ');
fprintf(fid, 'en utilisant des réseaux de neurones sous MATLAB. Le système analyse des signaux vibratoires pour ');
fprintf(fid, 'classifier automatiquement les échantillons comme sains ou défectueux.</p>\n');

% Section 2: Architecture du système
fprintf(fid, '<h2>2. ARCHITECTURE DU SYSTÈME</h2>\n');
fprintf(fid, '<h3>2.1 Structure des données</h3>\n');
fprintf(fid, '<ul>\n');
fprintf(fid, '<li><strong>Machine 1:</strong> 4 conditions (1 saine + 3 défectueuses)</li>\n');
fprintf(fid, '<li><strong>Machine 2:</strong> 3 conditions (1 saine + 2 défectueuses)</li>\n');
fprintf(fid, '<li><strong>Format:</strong> Fichiers CSV avec timestamp + accélération</li>\n');
fprintf(fid, '<li><strong>Total:</strong> ~490 fichiers de données</li>\n');
fprintf(fid, '</ul>\n');

fprintf(fid, '<h3>2.2 Indicateurs vibratoires</h3>\n');
fprintf(fid, '<p>8 indicateurs calculés pour chaque signal:</p>\n');
fprintf(fid, '<table>\n');
fprintf(fid, '<tr><th>Indicateur</th><th>Formule</th><th>Description</th></tr>\n');
fprintf(fid, '<tr><td>Énergie (E)</td><td>sum(signal²)</td><td>Énergie totale du signal</td></tr>\n');
fprintf(fid, '<tr><td>Puissance (P)</td><td>mean(signal²)</td><td>Puissance moyenne</td></tr>\n');
fprintf(fid, '<tr><td>Amplitude crête</td><td>max(|signal|)</td><td>Valeur maximale</td></tr>\n');
fprintf(fid, '<tr><td>Moyenne</td><td>mean(signal)</td><td>Valeur moyenne</td></tr>\n');
fprintf(fid, '<tr><td>RMS</td><td>sqrt(mean(signal²))</td><td>Valeur efficace</td></tr>\n');
fprintf(fid, '<tr><td>Kurtosis</td><td>kurtosis(signal)</td><td>Forme de distribution</td></tr>\n');
fprintf(fid, '<tr><td>Facteur de crête</td><td>Peak/RMS</td><td>Rapport crête/efficace</td></tr>\n');
fprintf(fid, '<tr><td>Facteur K</td><td>Complexe</td><td>Indicateur de forme avancé</td></tr>\n');
fprintf(fid, '</table>\n');

% Section 3: Résultats
fprintf(fid, '<h2>3. RÉSULTATS DE PERFORMANCE</h2>\n');

if validation_loaded
    fprintf(fid, '<div class="metric">\n');
    fprintf(fid, '<h3>3.1 Performance Machine 1</h3>\n');
    fprintf(fid, '<ul>\n');
    fprintf(fid, '<li><strong>Précision:</strong> %.2f%%</li>\n', validation_results.M1_accuracy);
    fprintf(fid, '<li><strong>Rappel:</strong> %.2f%%</li>\n', validation_results.M1_recall);
    fprintf(fid, '<li><strong>F1-Score:</strong> %.2f</li>\n', validation_results.M1_f1);
    fprintf(fid, '</ul>\n');
    fprintf(fid, '</div>\n');
    
    fprintf(fid, '<div class="metric">\n');
    fprintf(fid, '<h3>3.2 Performance Machine 2</h3>\n');
    fprintf(fid, '<ul>\n');
    fprintf(fid, '<li><strong>Précision:</strong> %.2f%%</li>\n', validation_results.M2_accuracy);
    fprintf(fid, '<li><strong>Rappel:</strong> %.2f%%</li>\n', validation_results.M2_recall);
    fprintf(fid, '<li><strong>F1-Score:</strong> %.2f</li>\n', validation_results.M2_f1);
    fprintf(fid, '</ul>\n');
    fprintf(fid, '</div>\n');
    
    % Évaluation du déploiement
    if validation_results.M1_accuracy >= 90 && validation_results.M2_accuracy >= 90
        fprintf(fid, '<p class="success">✓ SYSTÈME APPROUVÉ POUR DÉPLOIEMENT INDUSTRIEL (>90%% précision)</p>\n');
        deployment_status = 'APPROUVE';
    elseif validation_results.M1_accuracy >= 85 && validation_results.M2_accuracy >= 85
        fprintf(fid, '<p class="warning">⚠ DÉPLOIEMENT CONDITIONNEL (85-90%% précision)</p>\n');
        deployment_status = 'CONDITIONNEL';
    else
        fprintf(fid, '<p class="error">❌ SYSTÈME NON PRÊT POUR DÉPLOIEMENT (<85%% précision)</p>\n');
        deployment_status = 'NON_PRET';
    end
else
    fprintf(fid, '<p class="error">Données de validation non disponibles</p>\n');
    deployment_status = 'INDETERMINE';
end

% Section 4: Architecture réseau de neurones
fprintf(fid, '<h2>4. ARCHITECTURE RÉSEAU DE NEURONES</h2>\n');
if networks_loaded
    fprintf(fid, '<ul>\n');
    fprintf(fid, '<li><strong>Type:</strong> Réseau feedforward</li>\n');
    fprintf(fid, '<li><strong>Architecture:</strong> [8] → [15] → [10] → [1]</li>\n');
    fprintf(fid, '<li><strong>Algorithme:</strong> Levenberg-Marquardt</li>\n');
    fprintf(fid, '<li><strong>Fonction activation:</strong> Tangente hyperbolique</li>\n');
    fprintf(fid, '<li><strong>Sortie:</strong> Classification binaire (0=sain, 1=défectueux)</li>\n');
    if exist('training_info', 'var')
        fprintf(fid, '<li><strong>Temps entrainement M1:</strong> %.2f secondes</li>\n', training_info.M1_training_time);
        fprintf(fid, '<li><strong>Temps entrainement M2:</strong> %.2f secondes</li>\n', training_info.M2_training_time);
    end
    fprintf(fid, '</ul>\n');
else
    fprintf(fid, '<p class="error">Informations réseau non disponibles</p>\n');
end

% Section 5: Démarche méthodologique
fprintf(fid, '<h2>5. DÉMARCHE MÉTHODOLOGIQUE</h2>\n');
fprintf(fid, '<ol>\n');
fprintf(fid, '<li><strong>Acquisition des données:</strong> Signaux vibratoires sur 2 machines</li>\n');
fprintf(fid, '<li><strong>Prétraitement:</strong> Extraction de 8 indicateurs vibratoires</li>\n');
fprintf(fid, '<li><strong>Normalisation:</strong> Z-score pour standardisation</li>\n');
fprintf(fid, '<li><strong>Sélection:</strong> Critère de Fisher pour réduction dimensionnelle</li>\n');
fprintf(fid, '<li><strong>Entrainement:</strong> Réseaux de neurones feedforward</li>\n');
fprintf(fid, '<li><strong>Validation:</strong> Test sur données indépendantes</li>\n');
fprintf(fid, '<li><strong>Déploiement:</strong> Interface utilisateur intégrée</li>\n');
fprintf(fid, '</ol>\n');

% Section 6: Interface utilisateur
fprintf(fid, '<h2>6. INTERFACE UTILISATEUR</h2>\n');
fprintf(fid, '<p>Le système propose deux interfaces:</p>\n');
fprintf(fid, '<ul>\n');
fprintf(fid, '<li><strong>Interface graphique (GUI):</strong> fault_detection_gui.m</li>\n');
fprintf(fid, '<li><strong>Menu interactif:</strong> main_project_launcher.m</li>\n');
fprintf(fid, '</ul>\n');
fprintf(fid, '<p><strong>Fonctionnalités disponibles:</strong></p>\n');
fprintf(fid, '<ul>\n');
fprintf(fid, '<li>Chargement automatique des données</li>\n');
fprintf(fid, '<li>Sélection des indicateurs pertinents</li>\n');
fprintf(fid, '<li>Lancement du traitement automatisé</li>\n');
fprintf(fid, '<li>Visualisation des résultats en temps réel</li>\n');
fprintf(fid, '<li>Export des métriques de performance</li>\n');
fprintf(fid, '</ul>\n');

% Section 7: Perspectives et recommandations
fprintf(fid, '<h2>7. PERSPECTIVES ET RECOMMANDATIONS</h2>\n');
fprintf(fid, '<h3>7.1 Améliorations possibles</h3>\n');
fprintf(fid, '<ul>\n');
fprintf(fid, '<li>Intégration de nouveaux types de défauts</li>\n');
fprintf(fid, '<li>Optimisation des hyperparamètres du réseau</li>\n');
fprintf(fid, '<li>Implémentation d''algorithmes d''apprentissage adaptatif</li>\n');
fprintf(fid, '<li>Extension à d''autres machines industrielles</li>\n');
fprintf(fid, '</ul>\n');

fprintf(fid, '<h3>7.2 Déploiement industriel</h3>\n');
switch deployment_status
    case 'APPROUVE'
        fprintf(fid, '<p class="success">Le système est <strong>approuvé pour déploiement industriel immédiat</strong>.</p>\n');
        fprintf(fid, '<p>Recommandations de déploiement:</p>\n');
        fprintf(fid, '<ul>\n');
        fprintf(fid, '<li>Installation sur serveur de production</li>\n');
        fprintf(fid, '<li>Formation des opérateurs</li>\n');
        fprintf(fid, '<li>Mise en place de la maintenance préventive</li>\n');
        fprintf(fid, '</ul>\n');
    case 'CONDITIONNEL'
        fprintf(fid, '<p class="warning">Le système nécessite une <strong>validation supplémentaire</strong> avant déploiement.</p>\n');
        fprintf(fid, '<p>Actions requises:</p>\n');
        fprintf(fid, '<ul>\n');
        fprintf(fid, '<li>Tests sur données terrain supplémentaires</li>\n');
        fprintf(fid, '<li>Ajustement des paramètres</li>\n');
        fprintf(fid, '<li>Validation par experts métier</li>\n');
        fprintf(fid, '</ul>\n');
    case 'NON_PRET'
        fprintf(fid, '<p class="error">Le système <strong>n''est pas prêt</strong> pour déploiement industriel.</p>\n');
        fprintf(fid, '<p>Améliorations nécessaires:</p>\n');
        fprintf(fid, '<ul>\n');
        fprintf(fid, '<li>Optimisation de l''architecture réseau</li>\n');
        fprintf(fid, '<li>Augmentation du jeu de données</li>\n');
        fprintf(fid, '<li>Amélioration des indicateurs</li>\n');
        fprintf(fid, '</ul>\n');
    otherwise
        fprintf(fid, '<p class="warning">Statut de déploiement indéterminé - validation requise.</p>\n');
end

% Section 8: Conclusion
fprintf(fid, '<h2>8. CONCLUSION</h2>\n');
fprintf(fid, '<p>Ce projet a permis de développer un système complet de détection automatique de défauts ');
fprintf(fid, 'sur deux machines industrielles. L''approche basée sur les réseaux de neurones et l''analyse ');
fprintf(fid, 'vibratoire s''avère prometteuse pour la maintenance prédictive.</p>\n');

if validation_loaded
    avg_accuracy = (validation_results.M1_accuracy + validation_results.M2_accuracy) / 2;
    fprintf(fid, '<p><strong>Performance globale:</strong> %.2f%% de précision moyenne</p>\n', avg_accuracy);
end

fprintf(fid, '<p><strong>Livrables du projet:</strong></p>\n');
fprintf(fid, '<ul>\n');
fprintf(fid, '<li>Scripts MATLAB optimisés et documentés</li>\n');
fprintf(fid, '<li>Interface utilisateur complète</li>\n');
fprintf(fid, '<li>Documentation technique exhaustive</li>\n');
fprintf(fid, '<li>Réseaux de neurones entrainés et validés</li>\n');
fprintf(fid, '<li>Système de sélection d''indicateurs</li>\n');
fprintf(fid, '</ul>\n');

% Pied de page
fprintf(fid, '<hr>\n');
fprintf(fid, '<p><em>Rapport généré automatiquement le %s à %s par le système MATLAB de détection de défauts.</em></p>\n', report_date, report_time);
fprintf(fid, '</body>\n</html>\n');

fclose(fid);

%% Generation du rapport texte
txt_filename = 'RAPPORT_INDUSTRIEL.txt';
fprintf('Generation du rapport texte: %s\n', txt_filename);

fid = fopen(txt_filename, 'w');
if fid == -1
    error('Impossible de creer le fichier texte');
end

fprintf(fid, '========================================\n');
fprintf(fid, '%s\n', report_title);
fprintf(fid, '========================================\n');
fprintf(fid, 'Date: %s - Heure: %s\n\n', report_date, report_time);

fprintf(fid, '1. PERFORMANCE SYSTÈME\n');
fprintf(fid, '----------------------\n');
if validation_loaded
    fprintf(fid, 'Machine 1 - Précision: %.2f%%\n', validation_results.M1_accuracy);
    fprintf(fid, 'Machine 2 - Précision: %.2f%%\n', validation_results.M2_accuracy);
    fprintf(fid, 'Statut déploiement: %s\n\n', deployment_status);
else
    fprintf(fid, 'Données de validation non disponibles\n\n');
end

fprintf(fid, '2. ARCHITECTURE TECHNIQUE\n');
fprintf(fid, '-------------------------\n');
fprintf(fid, '- Réseau de neurones feedforward [8-15-10-1]\n');
fprintf(fid, '- 8 indicateurs vibratoires\n');
fprintf(fid, '- Classification binaire sain/défectueux\n');
fprintf(fid, '- Interface utilisateur intégrée\n\n');

fprintf(fid, '3. DONNÉES TRAITÉES\n');
fprintf(fid, '------------------\n');
fprintf(fid, '- Machine 1: 4 conditions (280 fichiers)\n');
fprintf(fid, '- Machine 2: 3 conditions (210 fichiers)\n');
fprintf(fid, '- Format: CSV timestamp + accélération\n\n');

fprintf(fid, '4. RECOMMANDATION\n');
fprintf(fid, '----------------\n');
switch deployment_status
    case 'APPROUVE'
        fprintf(fid, 'SYSTÈME APPROUVÉ POUR DÉPLOIEMENT INDUSTRIEL\n');
    case 'CONDITIONNEL'
        fprintf(fid, 'VALIDATION SUPPLÉMENTAIRE RECOMMANDÉE\n');
    case 'NON_PRET'
        fprintf(fid, 'AMÉLIORATIONS NÉCESSAIRES AVANT DÉPLOIEMENT\n');
    otherwise
        fprintf(fid, 'VALIDATION COMPLÈTE REQUISE\n');
end

fclose(fid);

%% Resume des fichiers generes
fprintf('\n=== RAPPORT INDUSTRIEL GÉNÉRÉ ===\n');
fprintf('Fichiers créés:\n');
fprintf('  - %s (format HTML)\n', html_filename);
fprintf('  - %s (format texte)\n', txt_filename);

if exist(html_filename, 'file')
    fprintf('✓ Rapport HTML généré avec succès\n');
else
    fprintf('✗ Erreur lors de la génération HTML\n');
end

if exist(txt_filename, 'file')
    fprintf('✓ Rapport texte généré avec succès\n');
else
    fprintf('✗ Erreur lors de la génération texte\n');
end

fprintf('\nRapport industriel complet disponible.\n');
fprintf('Ouvrir le fichier HTML dans un navigateur pour visualisation optimale.\n')
