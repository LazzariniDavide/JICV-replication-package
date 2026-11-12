clc; clear all; close all;

addpath("..\Road_profiles\mat_files\")

Fontsize_axis   = 32;
Fontsize_labels = 48;

filt        = 10;

figure

colours = ['r', 'g', 'b'];

for i = 1: 3

    %% CALCULATE PSD

    road = i;

    switch(road)
    
        case 1 % A_road_train
            figurename      = 'A_road_train';
            data            = load('A_road_train');
            road_height_tmp = data.A_road_train.height;
            distance_tmp    = data.A_road_train.distance;
            start_distance  = 0.0345;
            end_distance    = 45;
            discr           = 0.0345;
            classname       = "A"; % 1.96 - 1.94
    
        case 2 % B_road_train1
            figurename      = 'B_road_train1';
            data            = load('B_road_train1');
            road_height_tmp = data.B_road_train1.height;
            distance_tmp    = data.B_road_train1.distance;
            start_distance  = 0.0321;
            end_distance    = 45;
            discr           = 0.0321;
            classname       = "B"; % 8.6 - 6.44
    
        case 3 % C_road_train
            figurename      = 'C_road_train';
            data            = load('C_road_train');
            road_height_tmp = data.C_road_train.height;
            distance_tmp    = data.C_road_train.distance;
            start_distance  = 0.0083;
            end_distance    = 45;
            discr           = 0.0083;
            classname       = "C"; % 15 - 10.47
    
    end
    
    road_height     = road_height_tmp(start_distance/discr:end_distance/discr);
    distance        = distance_tmp(1:(end_distance-start_distance)/discr+1);
    
    N               = length(distance);                     % Number of samples
    Fs              = 1/(distance(2)-distance(1));          % Sampling frequency (1/distance increment)
    freq            = 0:Fs/N:Fs/2;                          % Frequency axis
    
    % Compute PSD using Fast Fourier Transform (FFT)
    psd             = (1/(Fs*N))*abs(fft(road_height)).^2;  % Two-sided power
    % Take only positive frequencies
    psd             = psd(1:N/2+1);                         % One-sided
    % Double values except for DC and Nyquist
    psd(2:end-1)    = 2*psd(2:end-1);
    % Filter signal
    windowSize      = filt; 
    b               = (1/windowSize)*ones(1,windowSize);
    psd_filt        = filter(b,1,psd);

    %% LINEAR REGRESSION
    % Define the frequency range for regression
    fmin = 0.2;
    fmax = 3;
    
    % Select data within the range
    idx = (freq >= fmin) & (freq <= fmax);
    freq_fit = freq(idx);
    psd_fit = psd_filt(idx);
    
    % Perform linear regression in log-log space
    log_freq = log10(freq_fit);
    log_psd = log10(psd_fit);
    p = polyfit(log_freq, log_psd, 1); % Linear fit (y = mx + b)
    
    % Generate fitted PSD values
    log_psd_fit = polyval(p, log_freq); % Compute regression line values

    % Plot original log-log data
    % % loglog(freq, psd_filt, strcat(colours(i),'-'), 'LineWidth', 1.5); % Original data in blue
    % % hold on;
    loglog(freq_fit, 10.^log_psd_fit, strcat(colours(i),'--'), 'LineWidth', 3); % Regression line in red
    hold on;

    % Display slope and intercept
    disp(['Slope: ', num2str(p(1))]);
    disp(['Intercept: ', num2str(10^p(2))]); % Convert back to linear scale

end
hold off;
% Labels and legend
set(gca,'FontSize', Fontsize_axis)
ylabel('$G_d\ (\Omega)$', 'interpreter', 'latex', 'FontSize', Fontsize_labels)
xlabel('$\Omega\ \mathrm{[rad/m]}$', 'interpreter', 'latex', 'FontSize', Fontsize_labels)
xlim([1e-1,1e1])
grid on;