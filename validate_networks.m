clear all
close all
clc

fprintf('=== NEURAL NETWORK VALIDATION ===\n')

%% Load trained networks and data
fprintf('Loading trained networks and data...\n')

if ~exist('trained_networks.mat', 'file')
    error('Trained networks not found. Run train_networks.m first.')
end

if ~exist('Donnees_Preparees.mat', 'file')
    error('Prepared data not found. Run data_preparation_complete.m first.')
end

load('Donnees_Preparees.mat')
load('trained_networks.mat')

fprintf('Networks and data loaded successfully\n')
fprintf('Training timestamp: %s\n', training_info.timestamp)

%% Prepare test data for validation
fprintf('\nPreparing validation data...\n')

% Use the normalized data that was prepared
X_M1_test = X_M1_norm;
targets_M1_test = Y_M1;

X_M2_test = X_M2_norm;
targets_M2_test = Y_M2;

fprintf('  Machine 1 test data: %dx%d\n', size(X_M1_test))
fprintf('  Machine 2 test data: %dx%d\n', size(X_M2_test))

%% Validate Machine 1 Network
fprintf('\nValidating Machine 1 network...\n')

% Check if we're using Neural Network Toolbox or simple implementation
has_nn_toolbox = exist('feedforwardnet', 'file') == 2;

% Predict
if has_nn_toolbox
    Y_M1 = net_M1_trained(X_M1_test');
    predictions_M1 = (Y_M1 > 0.5)';
else
    Y_M1 = net_M1_trained.predict(X_M1_test);
    predictions_M1 = (Y_M1 > 0.5);
end

% Calculate metrics
TP_M1 = sum((predictions_M1 == 1) & (targets_M1_test == 1));
TN_M1 = sum((predictions_M1 == 0) & (targets_M1_test == 0));
FP_M1 = sum((predictions_M1 == 1) & (targets_M1_test == 0));
FN_M1 = sum((predictions_M1 == 0) & (targets_M1_test == 1));

accuracy_M1 = (TP_M1 + TN_M1) / length(targets_M1_test) * 100;
precision_M1 = TP_M1 / (TP_M1 + FP_M1) * 100;
recall_M1 = TP_M1 / (TP_M1 + FN_M1) * 100;
f1_M1 = 2 * (precision_M1 * recall_M1) / (precision_M1 + recall_M1);

fprintf('  Accuracy: %.2f%%\n', accuracy_M1)
fprintf('  Precision: %.2f%%\n', precision_M1)
fprintf('  Recall: %.2f%%\n', recall_M1)
fprintf('  F1-Score: %.2f\n', f1_M1)

% Confusion matrix
conf_M1 = [TN_M1, FP_M1; FN_M1, TP_M1];
fprintf('  Confusion Matrix:\n')
fprintf('    True Neg: %d  False Pos: %d\n', TN_M1, FP_M1)
fprintf('    False Neg: %d  True Pos: %d\n', FN_M1, TP_M1)

%% Validate Machine 2 Network
fprintf('\nValidating Machine 2 network...\n')

% Predict
if has_nn_toolbox
    Y_M2 = net_M2_trained(X_M2_test');
    predictions_M2 = (Y_M2 > 0.5)';
else
    Y_M2 = net_M2_trained.predict(X_M2_test);
    predictions_M2 = (Y_M2 > 0.5);
end

% Calculate metrics
TP_M2 = sum((predictions_M2 == 1) & (targets_M2_test == 1));
TN_M2 = sum((predictions_M2 == 0) & (targets_M2_test == 0));
FP_M2 = sum((predictions_M2 == 1) & (targets_M2_test == 0));
FN_M2 = sum((predictions_M2 == 0) & (targets_M2_test == 1));

accuracy_M2 = (TP_M2 + TN_M2) / length(targets_M2_test) * 100;
precision_M2 = TP_M2 / (TP_M2 + FP_M2) * 100;
recall_M2 = TP_M2 / (TP_M2 + FN_M2) * 100;
f1_M2 = 2 * (precision_M2 * recall_M2) / (precision_M2 + recall_M2);

fprintf('  Accuracy: %.2f%%\n', accuracy_M2)
fprintf('  Precision: %.2f%%\n', precision_M2)
fprintf('  Recall: %.2f%%\n', recall_M2)
fprintf('  F1-Score: %.2f\n', f1_M2)

% Confusion matrix
conf_M2 = [TN_M2, FP_M2; FN_M2, TP_M2];
fprintf('  Confusion Matrix:\n')
fprintf('    True Neg: %d  False Pos: %d\n', TN_M2, FP_M2)
fprintf('    False Neg: %d  True Pos: %d\n', FN_M2, TP_M2)

%% Random file testing
fprintf('\nPerforming random file tests...\n')

% Test 5 random files from each machine
num_tests = 5;

% Machine 1 random tests
fprintf('  Machine 1 random tests:\n')
test_folders_M1 = {'machine1/Fonc_Sain_2', 'machine1/Fonc_Defaut_Eng_Dn'};
expected_M1 = [0, 1]; % 0=healthy, 1=faulty

for folder_idx = 1:length(test_folders_M1)
    folder = test_folders_M1{folder_idx};
    expected = expected_M1(folder_idx);
    
    % Get random files
    csv_files = dir(fullfile(folder, 'acc_*.csv'));
    if length(csv_files) >= num_tests
        test_indices = randperm(length(csv_files), num_tests);
        
        for i = 1:num_tests
            try
                filepath = fullfile(folder, csv_files(test_indices(i)).name);
                data = importdata(filepath);
                signal = data(:,2);
                
                % Calculate 8 vibration indicators (consistent with data preparation)
                E = sum(signal.^2);                    % Energy
                P = mean(signal.^2);                   % Power
                peak = max(abs(signal));               % Peak amplitude
                mean_val = mean(signal);               % Mean
                rms_val = sqrt(mean(signal.^2));       % RMS
                kurt_val = kurtosis(signal);           % Kurtosis
                crest_factor = peak / rms_val;         % Crest factor
                % K factor: proper calculation using fourth moment
                if rms_val > 0
                    k_factor = crest_factor / sqrt(mean((abs(signal)/rms_val).^4));
                else
                    k_factor = 0;
                end
                
                % Normalize using stored parameters
                indicators = [E, P, peak, mean_val, rms_val, kurt_val, crest_factor, k_factor];
                indicators_norm = (indicators - mean_all) ./ std_all;
                
                % Predict
                Y_pred = net_M1_trained(indicators_norm');
                prediction = (Y_pred > 0.5);
                
                status = 'CORRECT';
                if prediction ~= expected
                    status = 'INCORRECT';
                end
                
                fprintf('    File %s: Pred=%.3f (%d) Expected=%d [%s]\n', ...
                       csv_files(test_indices(i)).name, Y_pred, prediction, expected, status)
            catch ME
                fprintf('    Error testing file %s: %s\n', csv_files(test_indices(i)).name, ME.message)
            end
        end
    end
end

% Machine 2 random tests
fprintf('  Machine 2 random tests:\n')
test_folders_M2 = {'machine2/M2_VRAI_Mesures_Sain', 'machine2/M2_VRAI_Mesures_BILL'};
expected_M2 = [0, 1]; % 0=healthy, 1=faulty

for folder_idx = 1:length(test_folders_M2)
    folder = test_folders_M2{folder_idx};
    expected = expected_M2(folder_idx);
    
    % Get random files
    csv_files = dir(fullfile(folder, 'acc_*.csv'));
    if length(csv_files) >= num_tests
        test_indices = randperm(length(csv_files), num_tests);
        
        for i = 1:num_tests
            try
                filepath = fullfile(folder, csv_files(test_indices(i)).name);
                data = importdata(filepath);
                signal = data(:,2);
                
                % Calculate 8 vibration indicators (consistent with data preparation)
                E = sum(signal.^2);                    % Energy
                P = mean(signal.^2);                   % Power
                peak = max(abs(signal));               % Peak amplitude
                mean_val = mean(signal);               % Mean
                rms_val = sqrt(mean(signal.^2));       % RMS
                kurt_val = kurtosis(signal);           % Kurtosis
                crest_factor = peak / rms_val;         % Crest factor
                % K factor: proper calculation using fourth moment
                if rms_val > 0
                    k_factor = crest_factor / sqrt(mean((abs(signal)/rms_val).^4));
                else
                    k_factor = 0;
                end
                
                % Normalize using stored parameters
                indicators = [E, P, peak, mean_val, rms_val, kurt_val, crest_factor, k_factor];
                indicators_norm = (indicators - mean_all) ./ std_all;
                
                % Predict
                Y_pred = net_M2_trained(indicators_norm');
                prediction = (Y_pred > 0.5);
                
                status = 'CORRECT';
                if prediction ~= expected
                    status = 'INCORRECT';
                end
                
                fprintf('    File %s: Pred=%.3f (%d) Expected=%d [%s]\n', ...
                       csv_files(test_indices(i)).name, Y_pred, prediction, expected, status)
            catch ME
                fprintf('    Error testing file %s: %s\n', csv_files(test_indices(i)).name, ME.message)
            end
        end
    end
end

%% Generate validation plots
fprintf('\nGenerating validation plots...\n')

figure('Position', [100, 100, 1400, 1000])

% Machine 1 confusion matrix
subplot(2,3,1)
imagesc(conf_M1)
colormap(gca, [1 0.8 0.8; 0.8 1 0.8])
title('Machine 1 - Confusion Matrix')
xlabel('Predicted')
ylabel('Actual')
set(gca, 'XTick', 1:2, 'XTickLabel', {'Healthy', 'Faulty'})
set(gca, 'YTick', 1:2, 'YTickLabel', {'Healthy', 'Faulty'})
for i = 1:2
    for j = 1:2
        text(j, i, num2str(conf_M1(i,j)), 'HorizontalAlignment', 'center', ...
             'FontSize', 14, 'FontWeight', 'bold')
    end
end

% Machine 2 confusion matrix
subplot(2,3,2)
imagesc(conf_M2)
colormap(gca, [1 0.8 0.8; 0.8 1 0.8])
title('Machine 2 - Confusion Matrix')
xlabel('Predicted')
ylabel('Actual')
set(gca, 'XTick', 1:2, 'XTickLabel', {'Healthy', 'Faulty'})
set(gca, 'YTick', 1:2, 'YTickLabel', {'Healthy', 'Faulty'})
for i = 1:2
    for j = 1:2
        text(j, i, num2str(conf_M2(i,j)), 'HorizontalAlignment', 'center', ...
             'FontSize', 14, 'FontWeight', 'bold')
    end
end

% Accuracy comparison
subplot(2,3,3)
machines = {'Machine 1', 'Machine 2'};
accuracies = [accuracy_M1, accuracy_M2];
bar(accuracies, 'FaceColor', [0.2 0.6 0.8])
set(gca, 'XTickLabel', machines)
ylabel('Accuracy (%)')
title('Validation Accuracy')
ylim([0 100])
for i = 1:length(accuracies)
    text(i, accuracies(i)+2, sprintf('%.1f%%', accuracies(i)), ...
         'HorizontalAlignment', 'center', 'FontWeight', 'bold')
end
grid on

% Precision comparison
subplot(2,3,4)
precisions = [precision_M1, precision_M2];
bar(precisions, 'FaceColor', [0.8 0.4 0.2])
set(gca, 'XTickLabel', machines)
ylabel('Precision (%)')
title('Precision')
ylim([0 100])
for i = 1:length(precisions)
    text(i, precisions(i)+2, sprintf('%.1f%%', precisions(i)), ...
         'HorizontalAlignment', 'center', 'FontWeight', 'bold')
end
grid on

% Recall comparison
subplot(2,3,5)
recalls = [recall_M1, recall_M2];
bar(recalls, 'FaceColor', [0.6 0.8 0.4])
set(gca, 'XTickLabel', machines)
ylabel('Recall (%)')
title('Recall')
ylim([0 100])
for i = 1:length(recalls)
    text(i, recalls(i)+2, sprintf('%.1f%%', recalls(i)), ...
         'HorizontalAlignment', 'center', 'FontWeight', 'bold')
end
grid on

% F1-Score comparison
subplot(2,3,6)
f1_scores = [f1_M1, f1_M2];
bar(f1_scores, 'FaceColor', [0.8 0.6 0.8])
set(gca, 'XTickLabel', machines)
ylabel('F1-Score')
title('F1-Score')
ylim([0 100])
for i = 1:length(f1_scores)
    text(i, f1_scores(i)+2, sprintf('%.1f', f1_scores(i)), ...
         'HorizontalAlignment', 'center', 'FontWeight', 'bold')
end
grid on

sgtitle('Neural Network Validation Results', 'FontSize', 16, 'FontWeight', 'bold')

% Save plot
saveas(gcf, 'validation_results.png')
fprintf('Validation plot saved as validation_results.png\n')

%% Save validation results
validation_results = struct();
validation_results.timestamp = datestr(now);
validation_results.M1_accuracy = accuracy_M1;
validation_results.M1_precision = precision_M1;
validation_results.M1_recall = recall_M1;
validation_results.M1_f1 = f1_M1;
validation_results.M1_confusion = conf_M1;
validation_results.M2_accuracy = accuracy_M2;
validation_results.M2_precision = precision_M2;
validation_results.M2_recall = recall_M2;
validation_results.M2_f1 = f1_M2;
validation_results.M2_confusion = conf_M2;

save('validation_results.mat', 'validation_results')
fprintf('Validation results saved to validation_results.mat\n')

%% Final summary
fprintf('\n=== VALIDATION SUMMARY ===\n')
fprintf('Machine 1 Performance:\n')
fprintf('  Accuracy: %.2f%%\n', accuracy_M1)
fprintf('  Precision: %.2f%%\n', precision_M1)
fprintf('  Recall: %.2f%%\n', recall_M1)
fprintf('  F1-Score: %.2f\n', f1_M1)

fprintf('\nMachine 2 Performance:\n')
fprintf('  Accuracy: %.2f%%\n', accuracy_M2)
fprintf('  Precision: %.2f%%\n', precision_M2)
fprintf('  Recall: %.2f%%\n', recall_M2)
fprintf('  F1-Score: %.2f\n', f1_M2)

% Industrial deployment recommendation
if accuracy_M1 >= 90 && accuracy_M2 >= 90
    fprintf('\n=== INDUSTRIAL DEPLOYMENT READY ===\n')
    fprintf('Both networks achieve >90%% accuracy - APPROVED for deployment\n')
elseif accuracy_M1 >= 85 && accuracy_M2 >= 85
    fprintf('\n=== INDUSTRIAL DEPLOYMENT - CONDITIONAL ===\n')
    fprintf('Networks achieve >85%% accuracy - Additional validation recommended\n')
else
    fprintf('\n=== INDUSTRIAL DEPLOYMENT - NOT READY ===\n')
    fprintf('Networks below 85%% accuracy - Requires improvement\n')
end

fprintf('\nFiles generated:\n')
fprintf('  - validation_results.mat (metrics and confusion matrices)\n')
fprintf('  - validation_results.png (performance plots)\n')
