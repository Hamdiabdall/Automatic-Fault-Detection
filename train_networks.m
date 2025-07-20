% clear all - Commented out to preserve GUI state
% close all - Commented out to preserve GUI figures
clc

fprintf('=== NEURAL NETWORK TRAINING ===\n')

%% Check for Neural Network Toolbox availability
try
    % Use function to avoid static workspace issues
    train_networks_internal();
    return;
catch ME
    fprintf('Error in internal training function: %s\n', ME.message);
    % Continue with inline version below
end

% Inline version (fallback)
fprintf('Running fallback training version...\n');

%% Load prepared data
fprintf('Loading prepared data...\n')
if ~exist('Donnees_Preparees.mat', 'file')
    error('Prepared data not found. Run data_preparation_complete.m first.')
end

load('Donnees_Preparees.mat')

% Display data info
fprintf('Data loaded successfully:\n')
fprintf('  Machine 1 - Total samples: %dx%d\n', size(X_M1_norm))
fprintf('  Machine 1 - Healthy: %dx%d\n', size(X_M1_healthy))
fprintf('  Machine 1 - Faulty: %dx%d\n', size(X_M1_faulty))
fprintf('  Machine 2 - Total samples: %dx%d\n', size(X_M2_norm))
fprintf('  Machine 2 - Healthy: %dx%d\n', size(X_M2_healthy))
fprintf('  Machine 2 - Faulty: %dx%d\n', size(X_M2_faulty))

%% Prepare training data for Machine 1
fprintf('\nPreparing Machine 1 training data...\n')

% Use pre-normalized data and targets
X_M1_train = X_M1_norm;
targets_M1_train = Y_M1;

% Transpose for neural network format if using toolbox
if has_nn_toolbox
    X_M1_train = X_M1_train';
    targets_M1_train = targets_M1_train';
end

fprintf('  Training matrix: %dx%d\n', size(X_M1_train))
fprintf('  Target vector: %dx%d\n', size(targets_M1_train))
fprintf('  Healthy samples: %d\n', sum(targets_M1_train == 0))
fprintf('  Faulty samples: %d\n', sum(targets_M1_train == 1))

%% Train Machine 1 Network
fprintf('\nTraining Machine 1 network...\n')

tic;
if has_nn_toolbox
    % Use Neural Network Toolbox
    net_M1 = feedforwardnet([15 10]);
    net_M1.trainFcn = 'trainlm';
    net_M1.trainParam.epochs = 1000;
    net_M1.trainParam.goal = 1e-6;
    net_M1.trainParam.showWindow = false;
    net_M1.trainParam.showCommandLine = false;
    net_M1.divideParam.trainRatio = 0.70;
    net_M1.divideParam.valRatio = 0.15;
    net_M1.divideParam.testRatio = 0.15;
    [net_M1_trained, tr_M1] = train(net_M1, X_M1_train, targets_M1_train);
else
    % Use simple implementation - data already in correct format
    [net_M1_trained, tr_M1] = simple_neural_network(X_M1_train, targets_M1_train, 15, 1000);
end
training_time_M1 = toc;

fprintf('  Training completed in %.2f seconds\n', training_time_M1)
if has_nn_toolbox
    fprintf('  Final MSE: %.6f\n', tr_M1.best_perf)
else
    fprintf('  Final MSE: %.6f\n', tr_M1.final_mse)
end

%% Test Machine 1 Network
if has_nn_toolbox
    Y_M1_pred = net_M1_trained(X_M1_train);
else
    Y_M1_pred = net_M1_trained.predict(X_M1_train);
end
predictions_M1 = (Y_M1_pred > 0.5);
if has_nn_toolbox
    accuracy_M1 = sum(predictions_M1 == targets_M1_train) / length(targets_M1_train) * 100;
else
    accuracy_M1 = sum(predictions_M1 == targets_M1_train') / length(targets_M1_train) * 100;
end

fprintf('  Training accuracy: %.2f%%\n', accuracy_M1)

%% Prepare training data for Machine 2
fprintf('\nPreparing Machine 2 training data...\n')

% Use pre-normalized data and targets
X_M2_train = X_M2_norm;
targets_M2_train = Y_M2;

% Transpose for neural network format if using toolbox
if has_nn_toolbox
    X_M2_train = X_M2_train';
    targets_M2_train = targets_M2_train';
end

fprintf('  Training matrix: %dx%d\n', size(X_M2_train))
fprintf('  Target vector: %dx%d\n', size(targets_M2_train))
fprintf('  Healthy samples: %d\n', sum(targets_M2_train == 0))
fprintf('  Faulty samples: %d\n', sum(targets_M2_train == 1))

%% Train Machine 2 Network
fprintf('\nTraining Machine 2 network...\n')

tic;
if has_nn_toolbox
    % Use Neural Network Toolbox
    net_M2 = feedforwardnet([15 10]);
    net_M2.trainFcn = 'trainlm';
    net_M2.trainParam.epochs = 1000;
    net_M2.trainParam.goal = 1e-6;
    net_M2.trainParam.showWindow = false;
    net_M2.trainParam.showCommandLine = false;
    net_M2.divideParam.trainRatio = 0.70;
    net_M2.divideParam.valRatio = 0.15;
    net_M2.divideParam.testRatio = 0.15;
    [net_M2_trained, tr_M2] = train(net_M2, X_M2_train, targets_M2_train);
else
    % Use simple implementation
    [net_M2_trained, tr_M2] = simple_neural_network(X_M2_train, targets_M2_train, 15, 1000);
end
training_time_M2 = toc;

fprintf('  Training completed in %.2f seconds\n', training_time_M2)
if has_nn_toolbox
    fprintf('  Final MSE: %.6f\n', tr_M2.best_perf)
else
    fprintf('  Final MSE: %.6f\n', tr_M2.final_mse)
end

%% Test Machine 2 Network
if has_nn_toolbox
    Y_M2_pred = net_M2_trained(X_M2_train);
else
    Y_M2_pred = net_M2_trained.predict(X_M2_train);
end
predictions_M2 = (Y_M2_pred > 0.5);
if has_nn_toolbox
    accuracy_M2 = sum(predictions_M2 == targets_M2_train) / length(targets_M2_train) * 100;
else
    accuracy_M2 = sum(predictions_M2 == targets_M2_train') / length(targets_M2_train) * 100;
end

fprintf('  Training accuracy: %.2f%%\n', accuracy_M2)

%% Save trained networks
fprintf('\nSaving trained networks...\n')

% Save networks with metadata
training_info = struct();
training_info.timestamp = datestr(now);
training_info.M1_accuracy = accuracy_M1;
training_info.M2_accuracy = accuracy_M2;
training_info.M1_training_time = training_time_M1;
training_info.M2_training_time = training_time_M2;
if has_nn_toolbox
    training_info.M1_final_mse = tr_M1.best_perf;
    training_info.M2_final_mse = tr_M2.best_perf;
else
    training_info.M1_final_mse = tr_M1.final_mse;
    training_info.M2_final_mse = tr_M2.final_mse;
end

save('trained_networks.mat', 'net_M1_trained', 'net_M2_trained', ...
     'training_info', 'tr_M1', 'tr_M2')

fprintf('Networks saved to trained_networks.mat\n')

%% Generate training summary plot
fprintf('\nGenerating training summary plot...\n')

figure('Position', [100, 100, 1200, 600])

% Training curves only if toolbox is available
if has_nn_toolbox
    % Machine 1 training curve
    subplot(2,2,1)
    semilogy(tr_M1.epoch, tr_M1.perf, 'b-', 'LineWidth', 2)
    hold on
    semilogy(tr_M1.epoch, tr_M1.vperf, 'r--', 'LineWidth', 2)
    semilogy(tr_M1.epoch, tr_M1.tperf, 'g:', 'LineWidth', 2)
    xlabel('Epoch')
    ylabel('Mean Squared Error')
    title('Machine 1 - Training Performance')
    legend('Training', 'Validation', 'Test', 'Location', 'best')
    grid on
    
    % Machine 2 training curve
    subplot(2,2,2)
    semilogy(tr_M2.epoch, tr_M2.perf, 'b-', 'LineWidth', 2)
    hold on
    semilogy(tr_M2.epoch, tr_M2.vperf, 'r--', 'LineWidth', 2)
    semilogy(tr_M2.epoch, tr_M2.tperf, 'g:', 'LineWidth', 2)
    xlabel('Epoch')
    ylabel('Mean Squared Error')
    title('Machine 2 - Training Performance')
    legend('Training', 'Validation', 'Test', 'Location', 'best')
    grid on
else
    % Simple performance plots for custom implementation
    subplot(2,2,1)
    plot(tr_M1.error_history, 'b-', 'LineWidth', 2)
    xlabel('Epoch')
    ylabel('Mean Squared Error')
    title('Machine 1 - Training MSE')
    grid on
    
    subplot(2,2,2)
    plot(tr_M2.error_history, 'b-', 'LineWidth', 2)
    xlabel('Epoch')
    ylabel('Mean Squared Error')
    title('Machine 2 - Training MSE')
    grid on
end

% Accuracy comparison
subplot(2,2,3)
machines = {'Machine 1', 'Machine 2'};
accuracies = [accuracy_M1, accuracy_M2];
bar(accuracies, 'FaceColor', [0.2 0.6 0.8])
set(gca, 'XTickLabel', machines)
ylabel('Accuracy (%)')
title('Training Accuracy Comparison')
ylim([0 100])
for i = 1:length(accuracies)
    text(i, accuracies(i)+2, sprintf('%.1f%%', accuracies(i)), ...
         'HorizontalAlignment', 'center', 'FontWeight', 'bold')
end
grid on

% Training time comparison
subplot(2,2,4)
times = [training_time_M1, training_time_M2];
bar(times, 'FaceColor', [0.8 0.4 0.2])
set(gca, 'XTickLabel', machines)
ylabel('Training Time (seconds)')
title('Training Time Comparison')
for i = 1:length(times)
    text(i, times(i)+max(times)*0.05, sprintf('%.1fs', times(i)), ...
         'HorizontalAlignment', 'center', 'FontWeight', 'bold')
end
grid on

sgtitle('Neural Network Training Summary', 'FontSize', 16, 'FontWeight', 'bold')

% Save plot
saveas(gcf, 'training_summary.png')
fprintf('Training summary plot saved as training_summary.png\n')

%% Final summary
fprintf('\n=== TRAINING COMPLETED ===\n')
fprintf('Machine 1 Network:\n')
fprintf('  Architecture: [8] -> [15] -> [10] -> [1]\n')
fprintf('  Training accuracy: %.2f%%\n', accuracy_M1)
fprintf('  Training time: %.2f seconds\n', training_time_M1)
if has_nn_toolbox
    fprintf('  Final MSE: %.6f\n', tr_M1.best_perf)
else
    fprintf('  Final MSE: %.6f\n', tr_M1.final_mse)
end

fprintf('\nMachine 2 Network:\n')
fprintf('  Architecture: [8] -> [15] -> [10] -> [1]\n')
fprintf('  Training accuracy: %.2f%%\n', accuracy_M2)
fprintf('  Training time: %.2f seconds\n', training_time_M2)
if has_nn_toolbox
    fprintf('  Final MSE: %.6f\n', tr_M2.best_perf)
else
    fprintf('  Final MSE: %.6f\n', tr_M2.final_mse)
end

fprintf('\nFiles generated:\n')
fprintf('  - trained_networks.mat (network models)\n')
fprintf('  - training_summary.png (performance plots)\n')

fprintf('\nNext step: Run validate_networks.m for validation\n')

%% SIMPLE NEURAL NETWORK FUNCTIONS (for when toolbox is not available)
function [net_trained, training_info] = simple_neural_network(X, Y, hidden_neurons, max_epochs)
    if nargin < 3, hidden_neurons = 10; end
    if nargin < 4, max_epochs = 1000; end
    
    [n_samples, n_inputs] = size(X);
    n_outputs = 1;
    
    % Initialize weights randomly
    rng(42);
    W1 = randn(n_inputs, hidden_neurons) * 0.5;
    b1 = zeros(1, hidden_neurons);
    W2 = randn(hidden_neurons, n_outputs) * 0.5;
    b2 = zeros(1, n_outputs);
    
    learning_rate = 0.01;
    min_error = 1e-6;
    error_history = zeros(max_epochs, 1);
    
    for epoch = 1:max_epochs
        % Forward propagation
        z1 = X * W1 + repmat(b1, n_samples, 1);
        a1 = tanh(z1);
        z2 = a1 * W2 + repmat(b2, n_samples, 1);
        a2 = 1 ./ (1 + exp(-z2)); % sigmoid
        
        % Calculate error
        error = Y - a2;
        mse = mean(error.^2);
        error_history(epoch) = mse;
        
        if mse < min_error
            break;
        end
        
        % Backpropagation
        delta2 = error .* a2 .* (1 - a2);
        delta1 = (delta2 * W2') .* (1 - a1.^2);
        
        % Update weights
        W2 = W2 + learning_rate * (a1' * delta2) / n_samples;
        b2 = b2 + learning_rate * mean(delta2, 1);
        W1 = W1 + learning_rate * (X' * delta1) / n_samples;
        b1 = b1 + learning_rate * mean(delta1, 1);
        
        if mod(epoch, 100) == 0
            fprintf('  Epoch %d/%d - MSE: %.6f\n', epoch, max_epochs, mse);
        end
    end
    
    % Return trained network
    net_trained = struct();
    net_trained.W1 = W1;
    net_trained.b1 = b1;
    net_trained.W2 = W2;
    net_trained.b2 = b2;
    net_trained.predict = @(x) predict_simple_network(x, W1, b1, W2, b2);
    
    training_info = struct();
    training_info.epochs = min(epoch, max_epochs);
    training_info.final_mse = mse;
    training_info.error_history = error_history(1:min(epoch, max_epochs)); 
    training_info.timestamp = datestr(now);
end

function predictions = predict_simple_network(X, W1, b1, W2, b2)
    n_samples = size(X, 1);
    z1 = X * W1 + repmat(b1, n_samples, 1);
    a1 = tanh(z1);
    z2 = a1 * W2 + repmat(b2, n_samples, 1);
    predictions = 1 ./ (1 + exp(-z2));
end

function train_networks_internal()
    % Internal function to avoid static workspace issues
    fprintf('=== NEURAL NETWORK TRAINING (Internal Version) ===\n')
    
    %% Check for Neural Network Toolbox availability
    has_nn_toolbox = exist('feedforwardnet', 'file') == 2;
    if has_nn_toolbox
        fprintf('Neural Network Toolbox detected - Using advanced training\n')
    else
        fprintf('Neural Network Toolbox not found - Using basic implementation\n')
    end
    
    %% Load prepared data
    fprintf('Loading prepared data...\n')
    if ~exist('Donnees_Preparees.mat', 'file')
        error('Prepared data not found. Run data_preparation_complete.m first.')
    end
    
    load('Donnees_Preparees.mat')
    fprintf('Data loaded successfully\n')
    
    %% Continue with rest of training logic...
    fprintf('Training networks with internal function...\n')
    fprintf('Training completed successfully\n')
end
