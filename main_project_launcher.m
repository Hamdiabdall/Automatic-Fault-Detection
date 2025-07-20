%% PROJET: Detection automatique de defauts sur 2 machines par reseau de neurones
%% MAIN - LANCEUR PRINCIPAL DU PROJET
%% Version ASCII pure sans caracteres speciaux

clear all; close all; clc;

fprintf('Verification de l''environnement MATLAB...\n');

%% Verification des toolboxes
matlab_version = version;
fprintf('Version MATLAB: %s\n', matlab_version);

% Verification toolboxes
toolbox_list = ver;
toolbox_names = {toolbox_list.Name};

toolboxes_requis = {'Neural Network Toolbox', 'Statistics and Machine Learning Toolbox'};

% Verification partielle des noms
for i = 1:length(toolboxes_requis)
    if any(contains(toolbox_names, toolboxes_requis{i}(1:10)))
        fprintf('  %s: Disponible\n', toolboxes_requis{i});
    else
        fprintf('  %s: Non detecte (peut fonctionner quand meme)\n', toolboxes_requis{i});
    end
end

%% Verification des dossiers de donnees
fprintf('\nVerification des dossiers de donnees...\n');
dossiers_requis = {'machine1', 'machine2'};

for i = 1:length(dossiers_requis)
    if exist(dossiers_requis{i}, 'dir')
        fprintf('  %s: Trouve\n', dossiers_requis{i});
    else
        fprintf('  %s: MANQUANT\n', dossiers_requis{i});
        error('Dossier requis manquant: %s', dossiers_requis{i});
    end
end

%% Menu principal
while true
    fprintf('\n=== MENU PRINCIPAL - DETECTION DE DEFAUTS ===\n');
    fprintf('1. Preparation des donnees\n');
    fprintf('2. Entrainement des reseaux de neurones\n');
    fprintf('3. Validation et tests\n');
    fprintf('4. Interface utilisateur (IHM)\n');
    fprintf('5. Selection de caracteristiques\n');
    fprintf('6. Visualisation des donnees\n');
    fprintf('7. Generation du rapport industriel\n');
    fprintf('8. Outils de diagnostic\n');
    fprintf('0. Quitter\n\n');
    
    choix = input('Choisissez une option (0-8): ', 's');
    
    switch choix
        case '1'
            fprintf('\n=== PREPARATION DES DONNEES ===\n');
            try
                run('data_preparation_complete.m');
                fprintf('Preparation terminee avec succes!\n');
                input('Appuyez sur Entree pour continuer...');
            catch ME
                fprintf('Erreur: %s\n', ME.message);
                input('Appuyez sur Entree pour continuer...');
            end
            
        case '2'
            if ~exist('Donnees_Preparees.mat', 'file')
                fprintf('ATTENTION: Executez d''abord l''option 1 (Preparation des donnees)\n');
                input('Appuyez sur Entree pour continuer...');
            else
                fprintf('\n=== ENTRAINEMENT DES RESEAUX ===\n');
                try
                    run('train_networks.m');
                    fprintf('Entrainement termine avec succes!\n');
                    input('Appuyez sur Entree pour continuer...');
                catch ME
                    fprintf('Erreur: %s\n', ME.message);
                    input('Appuyez sur Entree pour continuer...');
                end
            end
            
        case '3'
            if ~exist('Reseaux_Entraines.mat', 'file')
                fprintf('ATTENTION: Executez d''abord les options 1 et 2\n');
                input('Appuyez sur Entree pour continuer...');
            else
                fprintf('\n=== VALIDATION DU SYSTEME ===\n');
                try
                    run('validate_networks.m');
                    fprintf('Validation terminee avec succes!\n');
                    input('Appuyez sur Entree pour continuer...');
                catch ME
                    fprintf('Erreur: %s\n', ME.message);
                    input('Appuyez sur Entree pour continuer...');
                end
            end
            
        case '4'
            fprintf('\n=== LANCEMENT DE L''INTERFACE UTILISATEUR ===\n');
            try
                run('fault_detection_gui.m');
            catch ME
                fprintf('Erreur: %s\n', ME.message);
                input('Appuyez sur Entree pour continuer...');
            end
            
        case '5'
            fprintf('\n=== SELECTION DE CARACTERISTIQUES ===\n');
            fprintf('INFO: La selection des caracteristiques est maintenant integree\n');
            fprintf('      dans les scripts principaux (data_preparation_complete.m)\n');
            fprintf('      Les 8 indicateurs principaux sont automatiquement selectionnes:\n');
            fprintf('      1. Energie\n');
            fprintf('      2. Puissance\n');
            fprintf('      3. Amplitude Max\n');
            fprintf('      4. Moyenne\n');
            fprintf('      5. RMS\n');
            fprintf('      6. Kurtosis\n');
            fprintf('      7. Facteur de Crete\n');
            fprintf('      8. Facteur K\n');
            fprintf('\nPour personnaliser, editez data_preparation_complete.m\n');
            input('Appuyez sur Entree pour continuer...');
            
        case '6'
            fprintf('\n=== VISUALISATION DES DONNEES ===\n');
            fprintf('a. Comparer les donnees des 2 machines\n');
            fprintf('b. Visualiser les indicateurs par machine\n');
            fprintf('c. Retour\n');
            
            sub_choix = input('Choisissez (a/b/c): ', 's');
            
            switch sub_choix
                case 'a'
                    try
                        visualiser_comparaison_machines();
                        input('Appuyez sur Entree pour continuer...');
                    catch ME
                        fprintf('Erreur: %s\n', ME.message);
                        input('Appuyez sur Entree pour continuer...');
                    end
                    
                case 'b'
                    try
                        visualiser_indicateurs_machines();
                        input('Appuyez sur Entree pour continuer...');
                    catch ME
                        fprintf('Erreur: %s\n', ME.message);
                        input('Appuyez sur Entree pour continuer...');
                    end
            end
            
        case '7'
            fprintf('\n=== GENERATION DU RAPPORT INDUSTRIEL ===\n');
            try
                run('generate_industrial_report.m');
                fprintf('Rapport genere avec succes!\n');
                input('Appuyez sur Entree pour continuer...');
            catch ME
                fprintf('Erreur: %s\n', ME.message);
                input('Appuyez sur Entree pour continuer...');
            end
            
        case '8'
            fprintf('\n=== OUTILS DE DIAGNOSTIC ===\n');
            fprintf('a. Verifier l''integrite des donnees\n');
            fprintf('b. Tester un fichier specifique\n');
            fprintf('c. Visualiser les indicateurs\n');
            fprintf('d. Retour\n');
            
            sub_choix = input('Choisissez (a/b/c/d): ', 's');
            
            switch sub_choix
                case 'a'
                    try
                        diagnostic_integrite_donnees();
                        input('Appuyez sur Entree pour continuer...');
                    catch ME
                        fprintf('Erreur: %s\n', ME.message);
                        input('Appuyez sur Entree pour continuer...');
                    end
                    
                case 'b'
                    try
                        diagnostic_fichier_specifique();
                        input('Appuyez sur Entree pour continuer...');
                    catch ME
                        fprintf('Erreur: %s\n', ME.message);
                        input('Appuyez sur Entree pour continuer...');
                    end
                    
                case 'c'
                    try
                        diagnostic_visualiser_indicateurs();
                        input('Appuyez sur Entree pour continuer...');
                    catch ME
                        fprintf('Erreur: %s\n', ME.message);
                        input('Appuyez sur Entree pour continuer...');
                    end
            end
            
        case '0'
            fprintf('Au revoir!\n');
            break;
            
        otherwise
            fprintf('Option non valide. Veuillez choisir entre 0 et 8.\n');
    end
end

%% FONCTIONS UTILITAIRES

function visualiser_comparaison_machines()
    if exist('Donnees_Preparees.mat', 'file')
        load('Donnees_Preparees.mat');
        
        figure('Name', 'Comparaison des Machines');
        
        indicateur_noms = {'Energie', 'Puissance', 'Pic', 'Moyenne', 'RMS', 'Kurtosis', 'F.Crete', 'F.K'};
        
        for i = 1:8
            subplot(2,4,i);
            histogram(X_M1(:,i), 20, 'FaceAlpha', 0.5, 'FaceColor', 'blue');
            hold on;
            histogram(X_M2(:,i), 20, 'FaceAlpha', 0.5, 'FaceColor', 'red');
            title(indicateur_noms{i});
            legend('Machine 1', 'Machine 2');
            grid on;
        end
        
        sgtitle('Comparaison des Indicateurs - Machine 1 vs Machine 2');
        fprintf('Graphique de comparaison genere!\n');
    else
        fprintf('Donnees non preparees. Executez d''abord l''option 1.\n');
    end
end

function visualiser_indicateurs_machines()
    if exist('Donnees_Preparees.mat', 'file')
        load('Donnees_Preparees.mat');
        
        % Machine 1
        figure('Name', 'Machine 1 - Analyse des Indicateurs');
        
        dossiers = {'machine1/Fonc_Defaut_Eng_Dn', 'machine1/Fonc_Defaut_Inner_et_Eng_Dn', ...
                   'machine1/Fonc_Defaut_R_Combo', 'machine1/Fonc_Sain_2'};
        
        for i = 1:length(dossiers)
            if exist(dossiers{i}, 'dir')
                fprintf('Dossier %s: OK\n', dossiers{i});
            else
                fprintf('Dossier %s: MANQUANT\n', dossiers{i});
            end
        end
        
        subplot(2,1,1);
        histogram(Y_M1, 'FaceColor', 'blue', 'FaceAlpha', 0.7);
        title('Machine 1 - Distribution des Classes');
        xlabel('Classe (0=Defectueux, 1=Sain)');
        ylabel('Nombre d''echantillons');
        
        subplot(2,1,2);
        histogram(Y_M2, 'FaceColor', 'red', 'FaceAlpha', 0.7);
        title('Machine 2 - Distribution des Classes');
        xlabel('Classe (0=Defectueux, 1=Sain)');
        ylabel('Nombre d''echantillons');
        
        fprintf('Analyse des indicateurs terminee!\n');
    else
        fprintf('Donnees non preparees. Executez d''abord l''option 1.\n');
    end
end

function diagnostic_integrite_donnees()
    fprintf('=== DIAGNOSTIC D''INTEGRITE DES DONNEES ===\n');
    
    % Verification des dossiers
    dossiers_M1 = {'machine1/Fonc_Defaut_Eng_Dn', 'machine1/Fonc_Defaut_Inner_et_Eng_Dn', ...
                   'machine1/Fonc_Defaut_R_Combo', 'machine1/Fonc_Sain_2'};
    dossiers_M2 = {'machine 2/M2_VRAI_Mesures_BILL', 'machine 2/M2_VRAI_Mesures_OUTER', ...
                   'machine 2/M2_VRAI_Mesures_Sain'};
    
    fprintf('\nMachine 1:\n');
    for i = 1:length(dossiers_M1)
        if exist(dossiers_M1{i}, 'dir')
            csv_files = dir(fullfile(dossiers_M1{i}, '*.csv'));
            fprintf('  %s: %d fichiers CSV\n', dossiers_M1{i}, length(csv_files));
        else
            fprintf('  %s: MANQUANT\n', dossiers_M1{i});
        end
    end
    
    fprintf('\nMachine 2:\n');
    for i = 1:length(dossiers_M2)
        if exist(dossiers_M2{i}, 'dir')
            csv_files = dir(fullfile(dossiers_M2{i}, '*.csv'));
            fprintf('  %s: %d fichiers CSV\n', dossiers_M2{i}, length(csv_files));
        else
            fprintf('  %s: MANQUANT\n', dossiers_M2{i});
        end
    end
    
    % Verification des fichiers .mat
    fprintf('\nFichiers de donnees:\n');
    if exist('Donnees_Preparees.mat', 'file')
        fprintf('  Donnees_Preparees.mat: OK\n');
    else
        fprintf('  Donnees_Preparees.mat: MANQUANT\n');
    end
    
    if exist('Reseaux_Entraines.mat', 'file')
        fprintf('  Reseaux_Entraines.mat: OK\n');
        data = load('Reseaux_Entraines.mat');
        if isfield(data, 'accuracy_M1') && isfield(data, 'accuracy_M2')
            fprintf('    - Precision Machine 1: %.1f%%\n', data.accuracy_M1);
            fprintf('    - Precision Machine 2: %.1f%%\n', data.accuracy_M2);
        end
    else
        fprintf('  Reseaux_Entraines.mat: MANQUANT\n');
    end
    
    if exist('Resultats_Validation.mat', 'file')
        fprintf('  Resultats_Validation.mat: OK\n');
        data = load('Resultats_Validation.mat');
        if isfield(data, 'accuracy_M1_full') && isfield(data, 'accuracy_M2_full')
            fprintf('    - Validation Machine 1: %.1f%%\n', data.accuracy_M1_full);
            fprintf('    - Validation Machine 2: %.1f%%\n', data.accuracy_M2_full);
        end
    else
        fprintf('  Resultats_Validation.mat: MANQUANT\n');
    end
end

function diagnostic_fichier_specifique()
    fprintf('=== TEST D''UN FICHIER SPECIFIQUE ===\n');
    
    % Selectionner un fichier
    [filename, pathname] = uigetfile({'*.csv', 'Fichiers CSV (*.csv)'}, 'Selectionnez un fichier de test');
    
    if filename == 0
        return;
    end
    
    try
        filepath = fullfile(pathname, filename);
        data = importdata(filepath);
        
        fprintf('Fichier: %s\n', filename);
        fprintf('Dimensions: %dx%d\n', size(data,1), size(data,2));
        
        if size(data, 2) >= 2
            vibration_signal = data(:, 2);
            fprintf('Signal vibratoire:\n');
            fprintf('  - Longueur: %d echantillons\n', length(vibration_signal));
            fprintf('  - Min: %.6f\n', min(vibration_signal));
            fprintf('  - Max: %.6f\n', max(vibration_signal));
            fprintf('  - Moyenne: %.6f\n', mean(vibration_signal));
            fprintf('  - Ecart-type: %.6f\n', std(vibration_signal));
            
            % Visualisation
            figure('Name', ['Analyse: ' filename]);
            subplot(2,1,1);
            plot(vibration_signal);
            title(['Signal Vibratoire: ' filename]);
            xlabel('Echantillons');
            ylabel('Amplitude');
            grid on;
            
            subplot(2,1,2);
            histogram(vibration_signal, 50);
            title('Distribution des Amplitudes');
            xlabel('Amplitude');
            ylabel('Frequence');
            grid on;
            
        else
            fprintf('Erreur: Le fichier doit contenir au moins 2 colonnes\n');
        end
        
    catch ME
        fprintf('Erreur lors de l''analyse: %s\n', ME.message);
    end
end

function diagnostic_visualiser_indicateurs()
    if exist('Donnees_Preparees.mat', 'file')
        load('Donnees_Preparees.mat');
        fprintf('=== VISUALISATION DES INDICATEURS ===\n');
        
        figure('Name', 'Distribution des Indicateurs par Machine');
        
        indicateur_noms = {'Energie', 'Puissance', 'Pic', 'Moyenne', 'RMS', 'Kurtosis', 'F.Crete', 'F.K'};
        
        for i = 1:8
            subplot(2,4,i);
            
            % Histogrammes superposes
            histogram(X_M1(:,i), 30, 'FaceAlpha', 0.5, 'FaceColor', 'blue', 'EdgeColor', 'none');
            hold on;
            histogram(X_M2(:,i), 30, 'FaceAlpha', 0.5, 'FaceColor', 'red', 'EdgeColor', 'none');
            
            title(indicateur_noms{i});
            legend('Machine 1', 'Machine 2', 'Location', 'best');
            grid on;
            
            % Statistiques
            fprintf('Indicateur %d (%s):\n', i, indicateur_noms{i});
            fprintf('  Machine 1: Moy=%.3f, Std=%.3f\n', mean(X_M1(:,i)), std(X_M1(:,i)));
            fprintf('  Machine 2: Moy=%.3f, Std=%.3f\n', mean(X_M2(:,i)), std(X_M2(:,i)));
        end
        
        sgtitle('Distribution des 8 Indicateurs Vibratoires');
        
    else
        fprintf('Donnees non preparees. Executez d''abord l''option 1.\n');
    end
end
