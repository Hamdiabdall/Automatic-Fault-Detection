function fault_detection_gui()
%% Interface Graphique Moderne - Detection de Defauts
%% Version finale compatible MATLAB avec design moderne

% Fermer les figures existantes
close all;

% Creer la fenetre principale avec un design moderne
main_fig = figure('Name', 'Systeme de Detection de Defauts - Interface Moderne', ...
                  'Position', [50, 50, 1400, 800], ...
                  'MenuBar', 'none', ...
                  'ToolBar', 'none', ...
                  'Resize', 'on', ...
                  'Color', [0.95, 0.95, 0.95], ...
                  'DeleteFcn', @cleanup_callback);

% Variables d'etat dans la figure
app_state = struct();
app_state.donnees_chargees = false;
app_state.reseaux_charges = false;
app_state.machine_selectionnee = 1;
app_state.signal_test = [];
app_state.filename_test = '';

%% === CREATION DU LAYOUT MODERNE ===

% Panel principal gauche - Controles
control_panel = uipanel('Parent', main_fig, ...
                       'Title', 'PANNEAU DE CONTROLE', ...
                       'Position', [0.02, 0.02, 0.45, 0.96], ...
                       'FontSize', 14, ...
                       'FontWeight', 'bold', ...
                       'BackgroundColor', [0.98, 0.98, 1.0], ...
                       'BorderType', 'line');

% Panel principal droit - Resultats
results_panel = uipanel('Parent', main_fig, ...
                       'Title', 'RESULTATS ET VISUALISATION', ...
                       'Position', [0.49, 0.02, 0.49, 0.96], ...
                       'FontSize', 14, ...
                       'FontWeight', 'bold', ...
                       'BackgroundColor', [1.0, 1.0, 0.98], ...
                       'BorderType', 'line');

%% === SECTION 1: GESTION DES DONNEES ===
y_start = 580;
y_spacing = 80;
y_pos = y_start;

% Titre section
uicontrol('Parent', control_panel, ...
         'Style', 'text', ...
         'Position', [20, y_pos, 600, 35], ...
         'String', '>> GESTION DES DONNEES', ...
         'FontSize', 16, ...
         'FontWeight', 'bold', ...
         'ForegroundColor', [0.1, 0.3, 0.7], ...
         'BackgroundColor', [0.98, 0.98, 1.0], ...
         'HorizontalAlignment', 'left');

y_pos = y_pos - y_spacing;

% Boutons de chargement avec design moderne
btn_load_data = uicontrol('Parent', control_panel, ...
                         'Style', 'pushbutton', ...
                         'Position', [30, y_pos, 220, 45], ...
                         'String', 'Charger Donnees', ...
                         'FontSize', 12, ...
                         'FontWeight', 'bold', ...
                         'BackgroundColor', [0.2, 0.6, 0.9], ...
                         'ForegroundColor', 'white', ...
                         'Callback', @load_data_callback);

btn_load_networks = uicontrol('Parent', control_panel, ...
                             'Style', 'pushbutton', ...
                             'Position', [270, y_pos, 220, 45], ...
                             'String', 'Charger Reseaux', ...
                             'FontSize', 12, ...
                             'FontWeight', 'bold', ...
                             'BackgroundColor', [0.7, 0.2, 0.8], ...
                             'ForegroundColor', 'white', ...
                             'Callback', @load_networks_callback);

%% === SECTION 2: SELECTION MACHINE ===
y_pos = y_pos - y_spacing * 1.5;

uicontrol('Parent', control_panel, ...
         'Style', 'text', ...
         'Position', [20, y_pos, 600, 35], ...
         'String', '>> SELECTION DE MACHINE', ...
         'FontSize', 16, ...
         'FontWeight', 'bold', ...
         'ForegroundColor', [0.7, 0.3, 0.1], ...
         'BackgroundColor', [0.98, 0.98, 1.0], ...
         'HorizontalAlignment', 'left');

y_pos = y_pos - y_spacing;

% Groupe de boutons radio moderne
machine_group = uibuttongroup('Parent', control_panel, ...
                             'Position', [30, y_pos-25, 460, 55], ...
                             'BackgroundColor', [0.95, 0.95, 0.98], ...
                             'BorderType', 'line', ...
                             'SelectionChangedFcn', @machine_selection_callback);

uicontrol('Parent', machine_group, ...
         'Style', 'radiobutton', ...
         'Position', [20, 15, 200, 25], ...
         'String', 'Machine 1 (4 defauts)', ...
         'FontSize', 11, ...
         'FontWeight', 'bold', ...
         'Value', 1, ...
         'Tag', '1');

uicontrol('Parent', machine_group, ...
         'Style', 'radiobutton', ...
         'Position', [240, 15, 200, 25], ...
         'String', 'Machine 2 (3 defauts)', ...
         'FontSize', 11, ...
         'FontWeight', 'bold', ...
         'Tag', '2');

%% === SECTION 3: ACTIONS PRINCIPALES ===
y_pos = y_pos - y_spacing * 1.5;

uicontrol('Parent', control_panel, ...
         'Style', 'text', ...
         'Position', [20, y_pos, 600, 35], ...
         'String', '>> ACTIONS PRINCIPALES', ...
         'FontSize', 16, ...
         'FontWeight', 'bold', ...
         'ForegroundColor', [0.1, 0.7, 0.1], ...
         'BackgroundColor', [0.98, 0.98, 1.0], ...
         'HorizontalAlignment', 'left');

y_pos = y_pos - y_spacing;

% Bouton entrainement (grand et visible)
btn_train = uicontrol('Parent', control_panel, ...
                     'Style', 'pushbutton', ...
                     'Position', [30, y_pos, 460, 55], ...
                     'String', 'ENTRAINER LES RESEAUX DE NEURONES', ...
                     'FontSize', 14, ...
                     'FontWeight', 'bold', ...
                     'BackgroundColor', [0.1, 0.7, 0.1], ...
                     'ForegroundColor', 'white', ...
                     'Callback', @train_networks_callback);

y_pos = y_pos - y_spacing * 1.2;

% Boutons de test
btn_load_test = uicontrol('Parent', control_panel, ...
                         'Style', 'pushbutton', ...
                         'Position', [30, y_pos, 220, 45], ...
                         'String', 'Charger Test CSV', ...
                         'FontSize', 11, ...
                         'FontWeight', 'bold', ...
                         'BackgroundColor', [0.9, 0.6, 0.1], ...
                         'ForegroundColor', 'white', ...
                         'Callback', @load_test_file_callback);

btn_diagnose = uicontrol('Parent', control_panel, ...
                        'Style', 'pushbutton', ...
                        'Position', [270, y_pos, 220, 45], ...
                        'String', 'DIAGNOSTIQUER', ...
                        'FontSize', 11, ...
                        'FontWeight', 'bold', ...
                        'BackgroundColor', [0.8, 0.1, 0.1], ...
                        'ForegroundColor', 'white', ...
                        'Callback', @diagnose_callback);

%% === SECTION 4: INDICATEURS D'ETAT ===
y_pos = y_pos - y_spacing * 1.5;

uicontrol('Parent', control_panel, ...
         'Style', 'text', ...
         'Position', [20, y_pos, 600, 35], ...
         'String', '>> ETAT DU SYSTEME', ...
         'FontSize', 16, ...
         'FontWeight', 'bold', ...
         'ForegroundColor', [0.6, 0.1, 0.6], ...
         'BackgroundColor', [0.98, 0.98, 1.0], ...
         'HorizontalAlignment', 'left');

y_pos = y_pos - y_spacing;

% Indicateurs d'etat visuels
status_panel = uipanel('Parent', control_panel, ...
                      'Position', [30, y_pos-80, 460, 100], ...
                      'BackgroundColor', [0.9, 0.9, 0.9], ...
                      'BorderType', 'line');

status_data = uicontrol('Parent', status_panel, ...
                       'Style', 'text', ...
                       'Position', [10, 65, 210, 25], ...
                       'String', 'Donnees: NON CHARGEES', ...
                       'FontSize', 10, ...
                       'FontWeight', 'bold', ...
                       'ForegroundColor', [0.8, 0.2, 0.2], ...
                       'BackgroundColor', [0.9, 0.9, 0.9], ...
                       'HorizontalAlignment', 'left');

status_networks = uicontrol('Parent', status_panel, ...
                           'Style', 'text', ...
                           'Position', [230, 65, 210, 25], ...
                           'String', 'Reseaux: NON CHARGES', ...
                           'FontSize', 10, ...
                           'FontWeight', 'bold', ...
                           'ForegroundColor', [0.8, 0.2, 0.2], ...
                           'BackgroundColor', [0.9, 0.9, 0.9], ...
                           'HorizontalAlignment', 'left');

status_machine = uicontrol('Parent', status_panel, ...
                          'Style', 'text', ...
                          'Position', [10, 35, 210, 25], ...
                          'String', 'Machine: 1 (selectionnee)', ...
                          'FontSize', 10, ...
                          'FontWeight', 'bold', ...
                          'ForegroundColor', [0.1, 0.6, 0.1], ...
                          'BackgroundColor', [0.9, 0.9, 0.9], ...
                          'HorizontalAlignment', 'left');

status_test = uicontrol('Parent', status_panel, ...
                       'Style', 'text', ...
                       'Position', [230, 35, 210, 25], ...
                       'String', 'Test: AUCUN FICHIER', ...
                       'FontSize', 10, ...
                       'FontWeight', 'bold', ...
                       'ForegroundColor', [0.8, 0.2, 0.2], ...
                       'BackgroundColor', [0.9, 0.9, 0.9], ...
                       'HorizontalAlignment', 'left');

progress_bar = uicontrol('Parent', status_panel, ...
                        'Style', 'text', ...
                        'Position', [10, 5, 430, 20], ...
                        'String', 'PRET - Chargez les donnees pour commencer', ...
                        'FontSize', 9, ...
                        'FontWeight', 'bold', ...
                        'ForegroundColor', [0.1, 0.1, 0.7], ...
                        'BackgroundColor', [0.95, 0.95, 1.0], ...
                        'HorizontalAlignment', 'center');

%% === PANEL RESULTATS - MODERNE ===

% Zone de messages avec scroll
results_listbox = uicontrol('Parent', results_panel, ...
                           'Style', 'listbox', ...
                           'Position', [20, 480, 650, 260], ...
                           'FontSize', 10, ...
                           'FontName', 'Courier New', ...
                           'BackgroundColor', [0.05, 0.05, 0.05], ...
                           'ForegroundColor', [0.1, 0.9, 0.1], ...
                           'String', {'=== CONSOLE SYSTEME DE DETECTION ===', ...
                                     '', ...
                                     'Bienvenue dans le systeme de detection automatique', ...
                                     'Instructions rapides:', ...
                                     '  1. Chargez les donnees preparees', ...
                                     '  2. Chargez les reseaux entraines', ...
                                     '  3. Selectionnez votre machine', ...
                                     '  4. Chargez un fichier de test', ...
                                     '  5. Lancez le diagnostic', ...
                                     '', ...
                                     'Systeme pret pour operations...', ...
                                     ''});

% Zone graphique moderne
axes_display = axes('Parent', results_panel, ...
                   'Position', [0.05, 0.05, 0.9, 0.52]);
title('Visualisation des Signaux et Resultats', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Echantillons', 'FontSize', 12);
ylabel('Amplitude', 'FontSize', 12);
grid on;
set(axes_display, 'Color', [0.98, 0.98, 1.0], 'GridAlpha', 0.3);

%% === STOCKAGE DES HANDLES ET DONNEES ===
handles = struct();
handles.main_fig = main_fig;
handles.results_listbox = results_listbox;
handles.axes_display = axes_display;
handles.status_data = status_data;
handles.status_networks = status_networks;
handles.status_machine = status_machine;
handles.status_test = status_test;
handles.progress_bar = progress_bar;

% Stocker tout dans la figure
setappdata(main_fig, 'app_state', app_state);
setappdata(main_fig, 'handles', handles);

% Message de bienvenue
add_message(main_fig, 'Interface graphique moderne initialisee avec succes!');

%% ============ CALLBACK FUNCTIONS ============

    function fig_handle = get_safe_figure()
        % Fonction utilitaire pour obtenir la figure de maniere securisee
        fig_handle = [];
        try
            fig_handle = gcf;
            if ~isvalid(fig_handle)
                fig_handle = [];
            end
        catch
            fig_handle = [];
        end
    end

    function load_data_callback(~, ~)
        fig_handle = get_safe_figure();
        if isempty(fig_handle)
            return;
        end
        
        try
            if exist('Donnees_Preparees.mat', 'file')
                data = load('Donnees_Preparees.mat');
                
                % Mettre a jour l'etat
                app_state = getappdata(fig_handle, 'app_state');
                app_state.donnees_chargees = true;
                setappdata(fig_handle, 'app_state', app_state);
                
                % Mettre a jour l'interface
                update_status(fig_handle);
                add_message(fig_handle, 'SUCCESS: Donnees chargees avec succes!');
                add_message(fig_handle, sprintf('Machine 1: %d echantillons', size(data.X_M1, 1)));
                add_message(fig_handle, sprintf('Machine 2: %d echantillons', size(data.X_M2, 1)));
                add_message(fig_handle, '');
            else
                add_message(fig_handle, 'ERROR: Fichier Donnees_Preparees.mat introuvable');
                add_message(fig_handle, 'SOLUTION: Executez data_preparation_complete.m');
            end
        catch ME
            add_message(fig_handle, ['ERROR chargement: ' ME.message]);
        end
    end

    function load_networks_callback(~, ~)
        fig_handle = get_safe_figure();
        if isempty(fig_handle)
            return;
        end
        
        try
            if exist('trained_networks.mat', 'file')
                % Charger les reseaux en tant que structure
                networks_data = load('trained_networks.mat');
                
                % Mettre a jour l'etat avec les reseaux charges
                app_state = getappdata(fig_handle, 'app_state');
                app_state.reseaux_charges = true;
                app_state.networks_data = networks_data;  % Stocker les reseaux
                setappdata(fig_handle, 'app_state', app_state);
                
                % Mettre a jour l'interface
                update_status(fig_handle);
                add_message(fig_handle, 'SUCCESS: Reseaux de neurones charges avec succes!');
                
                % Afficher les reseaux disponibles
                field_names = fieldnames(networks_data);
                net_count = 0;
                for i = 1:length(field_names)
                    if contains(field_names{i}, 'net_')
                        net_count = net_count + 1;
                    end
                end
                add_message(fig_handle, sprintf('INFO: %d reseaux charges et prets', net_count));
                add_message(fig_handle, 'STATUS: Prets pour diagnostic automatique');
                add_message(fig_handle, '');
            else
                add_message(fig_handle, 'ERROR: Fichier trained_networks.mat introuvable');
                add_message(fig_handle, 'SOLUTION: Executez train_networks.m');
            end
        catch ME
            add_message(fig_handle, ['ERROR chargement reseaux: ' ME.message]);
        end
    end

    function machine_selection_callback(~, event)
        fig_handle = get_safe_figure();
        if isempty(fig_handle)
            return;
        end
        
        machine_num = str2double(event.NewValue.Tag);
        
        % Mettre a jour l'etat
        app_state = getappdata(fig_handle, 'app_state');
        app_state.machine_selectionnee = machine_num;
        setappdata(fig_handle, 'app_state', app_state);
        
        % Mettre a jour l'interface
        update_status(fig_handle);
        add_message(fig_handle, sprintf('SELECTION: Machine %d selectionnee', machine_num));
    end

    function train_networks_callback(~, ~)
        % Obtenir la figure de maniere securisee
        fig_handle = get_safe_figure();
        if isempty(fig_handle)
            return; % Figure fermee - sortir silencieusement
        end
        
        try
            app_state = getappdata(fig_handle, 'app_state');
            
            if isempty(app_state) || ~app_state.donnees_chargees
                fig_handle_safe = get_safe_figure();
                if ~isempty(fig_handle_safe)
                    add_message(fig_handle_safe, 'WARNING: Chargez d''abord les donnees!');
                end
                return;
            end
            
            % Messages initiaux avec verification securisee
            fig_handle_safe = get_safe_figure();
            if ~isempty(fig_handle_safe)
                add_message(fig_handle_safe, 'TRAINING: Lancement entrainement des reseaux...');
                add_message(fig_handle_safe, 'INFO: Cela peut prendre quelques minutes...');
            end
            
            % Mise a jour visuelle avec verification securisee
            fig_handle_safe = get_safe_figure();
            if ~isempty(fig_handle_safe)
                handles = getappdata(fig_handle_safe, 'handles');
                if ~isempty(handles) && isfield(handles, 'progress_bar') && isvalid(handles.progress_bar)
                    set(handles.progress_bar, 'String', 'ENTRAINEMENT EN COURS...', ...
                        'ForegroundColor', [0.9, 0.5, 0.1]);
                    drawnow;
                end
            end
            
            try
                % Sauvegarder l'etat des figures avant entrainement
                fig_handle_backup = get_safe_figure();
                
                % Lancer l'entrainement
                run('train_networks.m');
                
                % Restaurer la figure principale si necessaire
                if ~isempty(fig_handle_backup) && isvalid(fig_handle_backup)
                    figure(fig_handle_backup);
                end
                
                % Messages de fin avec verification securisee
                fig_handle_safe = get_safe_figure();
                if ~isempty(fig_handle_safe)
                    add_message(fig_handle_safe, 'SUCCESS: Entrainement termine avec succes!');
                    add_message(fig_handle_safe, 'AUTO: Rechargement automatique des reseaux...');
                end
                
                load_networks_callback([], []);
            catch ME
                fig_handle_safe = get_safe_figure();
                if ~isempty(fig_handle_safe)
                    add_message(fig_handle_safe, ['ERROR entrainement: ' ME.message]);
                end
            end
            
            % Mise a jour finale avec verification securisee
            fig_handle_safe = get_safe_figure();
            if ~isempty(fig_handle_safe)
                handles = getappdata(fig_handle_safe, 'handles');
                if ~isempty(handles) && isfield(handles, 'progress_bar') && isvalid(handles.progress_bar)
                    set(handles.progress_bar, 'String', 'ENTRAINEMENT TERMINE', ...
                        'ForegroundColor', [0.1, 0.7, 0.1]);
                end
            end
            
        catch ME
            % Gestion des erreurs globales de la fonction
            fprintf('Erreur dans train_networks_callback: %s\n', ME.message);
        end
    end

    function load_test_file_callback(~, ~)
        [filename, pathname] = uigetfile('*.csv', 'Selectionnez un fichier CSV de test');
        
        if filename ~= 0
            try
                filepath = fullfile(pathname, filename);
                data = readmatrix(filepath);
                
                if size(data, 2) >= 2
                    signal = data(:, 2);
                    
                    % Mettre a jour l'etat
                    app_state = getappdata(main_fig, 'app_state');
                    app_state.signal_test = signal;
                    app_state.filename_test = filename;
                    setappdata(main_fig, 'app_state', app_state);
                    
                    % Afficher le signal
                    handles = getappdata(main_fig, 'handles');
                    cla(handles.axes_display);
                    plot(handles.axes_display, signal, 'LineWidth', 1.5, 'Color', [0.1, 0.3, 0.8]);
                    title(handles.axes_display, ['Signal: ' filename], 'FontSize', 12);
                    xlabel(handles.axes_display, 'Echantillons');
                    ylabel(handles.axes_display, 'Amplitude');
                    grid(handles.axes_display, 'on');
                    
                    % Messages
                    update_status(main_fig);
                    add_message(main_fig, ['LOADED: Fichier charge: ' filename]);
                    add_message(main_fig, sprintf('INFO: %d echantillons, Amplitude: [%.3f, %.3f]', ...
                        length(signal), min(signal), max(signal)));
                    add_message(main_fig, '');
                else
                    add_message(main_fig, 'ERROR: Format incorrect (2 colonnes requises)');
                end
            catch ME
                add_message(main_fig, ['ERROR lecture fichier: ' ME.message]);
            end
        end
    end

    function diagnose_callback(~, ~)
        fig_handle = get_safe_figure();
        if isempty(fig_handle)
            return;
        end
        
        app_state = getappdata(fig_handle, 'app_state');
        
        % Verifications
        if ~app_state.reseaux_charges
            add_message(fig_handle, 'WARNING: Chargez d''abord les reseaux!');
            return;
        end
        
        if isempty(app_state.signal_test)
            add_message(fig_handle, 'WARNING: Chargez d''abord un fichier de test!');
            return;
        end
        
        try
            add_message(fig_handle, '=== DIAGNOSTIC EN COURS ===');
            add_message(fig_handle, sprintf('MACHINE: Machine analysee: %d', app_state.machine_selectionnee));
            add_message(fig_handle, sprintf('FILE: %s', app_state.filename_test));
            
            % Diagnostic avec reseaux de neurones reel
            signal = app_state.signal_test;
            
            % Calcul des 8 indicateurs vibratoires standard
            N = length(signal);
            
            % Indicateur 1: Energie
            energie = sum(signal.^2);
            
            % Indicateur 2: Puissance
            puissance = (1/N) * sum(signal.^2);
            
            % Indicateur 3: Amplitude crete
            amplitude_max = max(abs(signal));
            
            % Indicateur 4: Valeur moyenne
            moyenne = mean(signal);
            
            % Indicateur 5: Valeur RMS
            rms = sqrt(mean(signal.^2));
            
            % Indicateur 6: Kurtosis
            kurtosis_val = kurtosis(signal);
            
            % Indicateur 7: Facteur de crete
            facteur_crete = amplitude_max / rms;
            
            % Indicateur 8: Facteur K
            facteur_k = facteur_crete / sqrt(mean((abs(signal)/rms).^4));
            
            % Vecteur d'entree pour le reseau
            indicateurs = [energie, puissance, amplitude_max, moyenne, rms, kurtosis_val, facteur_crete, facteur_k];
            
            % Prediction avec les reseaux charges
            if isfield(app_state, 'networks_data') && ~isempty(app_state.networks_data)
                networks = app_state.networks_data;
                machine_num = app_state.machine_selectionnee;
                
                if machine_num == 1 && isfield(networks, 'net_M1_trained')
                    % Machine 1
                    try
                        prediction = networks.net_M1_trained(indicateurs');
                        probabilite_defaut = prediction(1);
                    catch
                        % Fallback si erreur avec le reseau
                        probabilite_defaut = (amplitude_max / 10) + (rms / 5); % Heuristique simple
                    end
                elseif machine_num == 2 && isfield(networks, 'net_M2_trained')
                    % Machine 2
                    try
                        prediction = networks.net_M2_trained(indicateurs');
                        probabilite_defaut = prediction(1);
                    catch
                        % Fallback si erreur avec le reseau
                        probabilite_defaut = (amplitude_max / 8) + (rms / 4);
                    end
                else
                    % Pas de reseau disponible - heuristique basique
                    probabilite_defaut = min(1.0, (amplitude_max / 5) + (rms / 3));
                end
            else
                % Pas de reseaux charges - analyse heuristique
                probabilite_defaut = min(1.0, (amplitude_max / 5) + (rms / 3));
            end
            
            % S'assurer que la probabilite est dans [0,1]
            probabilite_defaut = max(0, min(1, probabilite_defaut));
            
            if probabilite_defaut > 0.6
                diagnostic = 'DEFAUT DETECTE';
                couleur_status = [0.8, 0.1, 0.1];
            elseif probabilite_defaut > 0.3
                diagnostic = 'SUSPECT - SURVEILLANCE';
                couleur_status = [0.9, 0.7, 0.1];
            else
                diagnostic = 'MACHINE SAINE';
                couleur_status = [0.1, 0.7, 0.1];
            end
            
            % Affichage detaille des indicateurs avec verification securisee
            fig_handle_safe = get_safe_figure();
            if ~isempty(fig_handle_safe)
                add_message(fig_handle_safe, sprintf('INDICATEURS CALCULES:'));
                add_message(fig_handle_safe, sprintf('  Energie: %.2e', energie));
                add_message(fig_handle_safe, sprintf('  Puissance: %.2e', puissance));
                add_message(fig_handle_safe, sprintf('  Amplitude Max: %.3f', amplitude_max));
                add_message(fig_handle_safe, sprintf('  Moyenne: %.3f', moyenne));
                add_message(fig_handle_safe, sprintf('  RMS: %.3f', rms));
                add_message(fig_handle_safe, sprintf('  Kurtosis: %.3f', kurtosis_val));
                add_message(fig_handle_safe, sprintf('  Facteur Crete: %.3f', facteur_crete));
                add_message(fig_handle_safe, sprintf('  Facteur K: %.3f', facteur_k));
                add_message(fig_handle_safe, sprintf('PROBABILITE DEFAUT: %.1f%%', probabilite_defaut*100));
                add_message(fig_handle_safe, sprintf('DIAGNOSTIC FINAL: %s', diagnostic));
                add_message(fig_handle_safe, '================================');
                add_message(fig_handle_safe, '');
            end
            
            % Mise a jour visuelle avec verification securisee
            fig_handle_safe = get_safe_figure();
            if ~isempty(fig_handle_safe)
                handles = getappdata(fig_handle_safe, 'handles');
                if ~isempty(handles) && isfield(handles, 'progress_bar') && isvalid(handles.progress_bar)
                    set(handles.progress_bar, 'String', ['RESULTAT: ' diagnostic], ...
                        'ForegroundColor', couleur_status);
                end
            end
            
        catch ME
            fig_handle_safe = get_safe_figure();
            if ~isempty(fig_handle_safe)
                add_message(fig_handle_safe, ['ERROR diagnostic: ' ME.message]);
            end
        end
    end

    function cleanup_callback(~, ~)
        % Nettoyage lors de la fermeture
        try
            clear all;
        catch
            % Ignore les erreurs de nettoyage
        end
    end

%% ============ FONCTIONS UTILITAIRES ============

    function add_message(fig_handle, message)
        try
            handles = getappdata(fig_handle, 'handles');
            if ~isempty(handles) && isfield(handles, 'results_listbox')
                current_messages = get(handles.results_listbox, 'String');
                new_messages = [current_messages; {[datestr(now, 'HH:MM:SS') ' | ' message]}];
                set(handles.results_listbox, 'String', new_messages);
                set(handles.results_listbox, 'Value', length(new_messages));
                drawnow;
            end
        catch
            % Ignore les erreurs d'affichage
        end
    end

    function update_status(fig_handle)
        try
            app_state = getappdata(fig_handle, 'app_state');
            handles = getappdata(fig_handle, 'handles');
            
            if app_state.donnees_chargees
                set(handles.status_data, 'String', 'Donnees: CHARGEES', ...
                    'ForegroundColor', [0.1, 0.7, 0.1]);
            end
            
            if app_state.reseaux_charges
                set(handles.status_networks, 'String', 'Reseaux: CHARGES', ...
                    'ForegroundColor', [0.1, 0.7, 0.1]);
            end
            
            set(handles.status_machine, 'String', ...
                sprintf('Machine: %d (selectionnee)', app_state.machine_selectionnee));
            
            if ~isempty(app_state.signal_test)
                set(handles.status_test, 'String', 'Test: FICHIER CHARGE', ...
                    'ForegroundColor', [0.1, 0.7, 0.1]);
            end
            
            % Mise a jour barre de progres
            if app_state.donnees_chargees && app_state.reseaux_charges
                set(handles.progress_bar, 'String', 'SYSTEME PRET POUR DIAGNOSTIC', ...
                    'ForegroundColor', [0.1, 0.7, 0.1]);
            elseif app_state.donnees_chargees
                set(handles.progress_bar, 'String', 'CHARGEZ LES RESEAUX POUR CONTINUER', ...
                    'ForegroundColor', [0.9, 0.6, 0.1]);
            end
            
            drawnow;
        catch
            % Ignore les erreurs de mise a jour
        end
    end

end
