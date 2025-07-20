clear all
close all
clc

fprintf('=== COMPLETE FAULT DETECTION DATA PREPARATION ===\n')

%% Custom functions (replace Statistics Toolbox dependencies)
function k = kurtosis_custom(x)
    x = x(:);  % Convert to column vector
    mu = mean(x);
    sigma = std(x);
    if sigma == 0
        k = 0;
    else
        x_centered = x - mu;
        fourth_moment = mean(x_centered.^4);
        k = fourth_moment / (sigma^4) - 3;  % Excess kurtosis
    end
end

function [z, mu, sigma] = zscore_custom(x)
    % Custom zscore implementation
    mu = mean(x, 1);          % Mean along columns
    sigma = std(x, 0, 1);     % Standard deviation along columns
    
    % Avoid division by zero
    sigma(sigma == 0) = 1;
    
    % Z-score normalization
    z = bsxfun(@minus, x, mu);
    z = bsxfun(@rdivide, z, sigma);
end

% Configuration
START_FILE = 10;  % Start from file 10
END_FILE = 70;    % End at file 70
NUM_INDICATORS = 8; % Number of vibration indicators

% Initialize storage matrices
data_M1_healthy = [];
data_M1_faulty_1 = [];
data_M1_faulty_2 = [];
data_M1_faulty_3 = [];
data_M2_healthy = [];
data_M2_faulty_1 = [];
data_M2_faulty_2 = [];

%% MACHINE 1 DATA PROCESSING
fprintf('Processing Machine 1 data...\n');

% Machine 1 - Healthy samples
fprintf('  Loading healthy samples...\n');
folder = 'machine1/Fonc_Sain_2';
files = dir(fullfile(folder, 'acc_*.csv'));
for i = START_FILE:min(END_FILE, length(files))
    if i <= length(files)
        try
            filepath = fullfile(folder, files(i).name);
            data = importdata(filepath);
            signal = data(:,2);
            
            % Calculate 8 vibration indicators
            E = sum(signal.^2);                    % Energy
            P = mean(signal.^2);                   % Power
            peak = max(abs(signal));               % Peak amplitude
            mean_val = mean(signal);               % Mean
            rms_val = sqrt(mean(signal.^2));       % RMS
            kurt_val = kurtosis_custom(signal);  % Kurtosis (custom implementation)
            crest_factor = peak / rms_val;         % Crest factor
            % K factor: proper calculation using fourth moment
            if rms_val > 0
                k_factor = crest_factor / sqrt(mean((abs(signal)/rms_val).^4));
            else
                k_factor = 0;
            end
            
            indicators = [E, P, peak, mean_val, rms_val, kurt_val, crest_factor, k_factor];
            data_M1_healthy = [data_M1_healthy; indicators];
        catch
            continue;
        end
    end
end
fprintf('    Processed: %d healthy samples\n', size(data_M1_healthy,1));

% Machine 1 - Faulty samples (Type 1)
fprintf('  Loading faulty samples (Eng_Dn)...\n');
folder = 'machine1/Fonc_Defaut_Eng_Dn';
files = dir(fullfile(folder, 'acc_*.csv'));
for i = START_FILE:min(END_FILE, length(files))
    if i <= length(files)
        try
            filepath = fullfile(folder, files(i).name);
            data = importdata(filepath);
            signal = data(:,2);
            
            E = sum(signal.^2);
            P = mean(signal.^2);
            peak = max(abs(signal));
            mean_val = mean(signal);
            rms_val = sqrt(mean(signal.^2));
            kurt_val = kurtosis_custom(signal);
            crest_factor = peak / rms_val;
            k_factor = peak * rms_val;
            
            indicators = [E, P, peak, mean_val, rms_val, kurt_val, crest_factor, k_factor];
            data_M1_faulty_1 = [data_M1_faulty_1; indicators];
        catch
            continue;
        end
    end
end
fprintf('    Processed: %d faulty samples (Type 1)\n', size(data_M1_faulty_1,1));

% Machine 1 - Faulty samples (Type 2)
fprintf('  Loading faulty samples (Inner_et_Eng_Dn)...\n');
folder = 'machine1/Fonc_Defaut_Inner_et_Eng_Dn';
files = dir(fullfile(folder, 'acc_*.csv'));
for i = START_FILE:min(END_FILE, length(files))
    if i <= length(files)
        try
            filepath = fullfile(folder, files(i).name);
            data = importdata(filepath);
            signal = data(:,2);
            
            E = sum(signal.^2);
            P = mean(signal.^2);
            peak = max(abs(signal));
            mean_val = mean(signal);
            rms_val = sqrt(mean(signal.^2));
            kurt_val = kurtosis_custom(signal);
            crest_factor = peak / rms_val;
            k_factor = peak * rms_val;
            
            indicators = [E, P, peak, mean_val, rms_val, kurt_val, crest_factor, k_factor];
            data_M1_faulty_2 = [data_M1_faulty_2; indicators];
        catch
            continue;
        end
    end
end
fprintf('    Processed: %d faulty samples (Type 2)\n', size(data_M1_faulty_2,1));

% Machine 1 - Faulty samples (Type 3)
fprintf('  Loading faulty samples (R_Combo)...\n');
folder = 'machine1/Fonc_Defaut_R_Combo';
files = dir(fullfile(folder, 'acc_*.csv'));
for i = START_FILE:min(END_FILE, length(files))
    if i <= length(files)
        try
            filepath = fullfile(folder, files(i).name);
            data = importdata(filepath);
            signal = data(:,2);
            
            E = sum(signal.^2);
            P = mean(signal.^2);
            peak = max(abs(signal));
            mean_val = mean(signal);
            rms_val = sqrt(mean(signal.^2));
            kurt_val = kurtosis_custom(signal);
            crest_factor = peak / rms_val;
            k_factor = peak * rms_val;
            
            indicators = [E, P, peak, mean_val, rms_val, kurt_val, crest_factor, k_factor];
            data_M1_faulty_3 = [data_M1_faulty_3; indicators];
        catch
            continue;
        end
    end
end
fprintf('    Processed: %d faulty samples (Type 3)\n', size(data_M1_faulty_3,1));

%% MACHINE 2 DATA PROCESSING
fprintf('Processing Machine 2 data...\n');

% Machine 2 - Healthy samples
fprintf('  Loading healthy samples...\n');
folder = 'machine2/M2_VRAI_Mesures_Sain';
files = dir(fullfile(folder, 'acc_*.csv'));
for i = START_FILE:min(END_FILE, length(files))
    if i <= length(files)
        try
            filepath = fullfile(folder, files(i).name);
            data = importdata(filepath);
            signal = data(:,2);
            
            E = sum(signal.^2);
            P = mean(signal.^2);
            peak = max(abs(signal));
            mean_val = mean(signal);
            rms_val = sqrt(mean(signal.^2));
            kurt_val = kurtosis_custom(signal);
            crest_factor = peak / rms_val;
            k_factor = peak * rms_val;
            
            indicators = [E, P, peak, mean_val, rms_val, kurt_val, crest_factor, k_factor];
            data_M2_healthy = [data_M2_healthy; indicators];
        catch
            continue;
        end
    end
end
fprintf('    Processed: %d healthy samples\n', size(data_M2_healthy,1));

% Machine 2 - Faulty samples (BILL)
fprintf('  Loading faulty samples (BILL)...\n');
folder = 'machine2/M2_VRAI_Mesures_BILL';
files = dir(fullfile(folder, 'acc_*.csv'));
for i = START_FILE:min(END_FILE, length(files))
    if i <= length(files)
        try
            filepath = fullfile(folder, files(i).name);
            data = importdata(filepath);
            signal = data(:,2);
            
            E = sum(signal.^2);
            P = mean(signal.^2);
            peak = max(abs(signal));
            mean_val = mean(signal);
            rms_val = sqrt(mean(signal.^2));
            kurt_val = kurtosis_custom(signal);
            crest_factor = peak / rms_val;
            k_factor = peak * rms_val;
            
            indicators = [E, P, peak, mean_val, rms_val, kurt_val, crest_factor, k_factor];
            data_M2_faulty_1 = [data_M2_faulty_1; indicators];
        catch
            continue;
        end
    end
end
fprintf('    Processed: %d faulty samples (BILL)\n', size(data_M2_faulty_1,1));

% Machine 2 - Faulty samples (OUTER)
fprintf('  Loading faulty samples (OUTER)...\n');
folder = 'machine2/M2_VRAI_Mesures_OUTER';
files = dir(fullfile(folder, 'acc_*.csv'));
for i = START_FILE:min(END_FILE, length(files))
    if i <= length(files)
        try
            filepath = fullfile(folder, files(i).name);
            data = importdata(filepath);
            signal = data(:,2);
            
            E = sum(signal.^2);
            P = mean(signal.^2);
            peak = max(abs(signal));
            mean_val = mean(signal);
            rms_val = sqrt(mean(signal.^2));
            kurt_val = kurtosis_custom(signal);
            crest_factor = peak / rms_val;
            k_factor = peak * rms_val;
            
            indicators = [E, P, peak, mean_val, rms_val, kurt_val, crest_factor, k_factor];
            data_M2_faulty_2 = [data_M2_faulty_2; indicators];
        catch
            continue;
        end
    end
end
fprintf('    Processed: %d faulty samples (OUTER)\n', size(data_M2_faulty_2,1));

%% CREATE FINAL DATASETS FOR BINARY CLASSIFICATION
fprintf('Creating final datasets...\n');

% Machine 1: Combine all faulty types vs healthy
X_M1_faulty = [data_M1_faulty_1; data_M1_faulty_2; data_M1_faulty_3];
X_M1_healthy = data_M1_healthy;
X_M1 = [X_M1_faulty; X_M1_healthy];
Y_M1 = [zeros(size(X_M1_faulty,1), 1); ones(size(X_M1_healthy,1), 1)];

% Machine 2: Combine faulty types vs healthy
X_M2_faulty = [data_M2_faulty_1; data_M2_faulty_2];
X_M2_healthy = data_M2_healthy;
X_M2 = [X_M2_faulty; X_M2_healthy];
Y_M2 = [zeros(size(X_M2_faulty,1), 1); ones(size(X_M2_healthy,1), 1)];

%% NORMALIZE DATA
fprintf('Normalizing data (z-score)...\n');
[X_M1_norm, mu_M1, sigma_M1] = zscore_custom(X_M1);
[X_M2_norm, mu_M2, sigma_M2] = zscore_custom(X_M2);

%% SAVE COMPLETE DATASET
fprintf('Saving complete dataset...\n');
save('Donnees_Preparees.mat', ...
     'X_M1', 'Y_M1', 'X_M2', 'Y_M2', ...
     'X_M1_norm', 'X_M2_norm', ...
     'mu_M1', 'sigma_M1', 'mu_M2', 'sigma_M2', ...
     'X_M1_faulty', 'X_M1_healthy', 'X_M2_faulty', 'X_M2_healthy');

%% DISPLAY FINAL RESULTS
fprintf('\n=== DATA PREPARATION COMPLETED ===\n');
fprintf('MACHINE 1:\n');
fprintf('  Total samples: %d\n', size(X_M1,1));
fprintf('  Faulty samples: %d\n', size(X_M1_faulty,1));
fprintf('  Healthy samples: %d\n', size(X_M1_healthy,1));
fprintf('  Indicators per sample: %d\n', size(X_M1,2));

fprintf('\nMACHINE 2:\n');
fprintf('  Total samples: %d\n', size(X_M2,1));
fprintf('  Faulty samples: %d\n', size(X_M2_faulty,1));
fprintf('  Healthy samples: %d\n', size(X_M2_healthy,1));
fprintf('  Indicators per sample: %d\n', size(X_M2,2));

fprintf('\nDATA QUALITY CHECK:\n');
fprintf('  Machine 1 - Mean energy: %.2e\n', mean(X_M1(:,1)));
fprintf('  Machine 2 - Mean energy: %.2e\n', mean(X_M2(:,1)));
fprintf('  Normalization parameters saved\n');

fprintf('\nFILES GENERATED:\n');
fprintf('  Donnees_Preparees.mat - Complete dataset ready for training\n');
fprintf('\n=== SUCCESS: Data preparation completed successfully ===\n');

% Generate summary visualization
figure('Name', 'Data Preparation Summary');
subplot(2,2,1);
histogram(Y_M1, 'FaceColor', 'blue', 'FaceAlpha', 0.7);
title('Machine 1 - Class Distribution');
xlabel('Class (0=Faulty, 1=Healthy)');
ylabel('Number of Samples');

subplot(2,2,2);
histogram(Y_M2, 'FaceColor', 'red', 'FaceAlpha', 0.7);
title('Machine 2 - Class Distribution');
xlabel('Class (0=Faulty, 1=Healthy)');
ylabel('Number of Samples');

figure('Name', 'Machine 1 - Normalized Indicators Distribution');
for i = 1:8
    subplot(2,4,i);
    histogram(X_M1_norm(:,i), 20);
    title(['Indicator ' num2str(i)]);
    xlabel('Normalized Values');
    ylabel('Frequency');
end
sgtitle('Machine 1 - Indicators Distribution (Normalized)');

figure('Name', 'Machine 2 - Normalized Indicators Distribution');
for i = 1:8
    subplot(2,4,i);
    histogram(X_M2_norm(:,i), 20);
    title(['Indicator ' num2str(i)]);
    xlabel('Normalized Values');
    ylabel('Frequency');
end
sgtitle('Machine 2 - Indicators Distribution (Normalized)');
