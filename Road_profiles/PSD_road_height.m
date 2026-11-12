clc; clear all; close all;

addpath("Data\")

fontsize    = 18;

road        = 11;

switch(road)

    case 1 % Our road
        figurename      = 'Road_R5_Discretization_1cm';
        data            = load('Road_R5_Discretization_1cm');
        fields          = fieldnames(data);
        road_height_tmp = data.(fields{1})*10^-3;
        distance_tmp    = data.(fields{2});
        start_distance  = 30;
        end_distance    = 80;
        discr           = 0.01;
        filt            = 1;
        classname       = "A";

    case 2 % R5_Vx_80kph
        figurename      = 'R5_Vx_80kph';
        data            = load('R5_Vx_80kph');
        road_height_tmp = data.zr_FL*10^-3;
        distance_tmp    = data.test_distance/2.6;
        start_distance  = 65;
        end_distance    = 194.9;
        discr           = 0.1001;
        filt            = 1;
        classname       = "B";

    case 3 % R5_Vx_40kph ------------------------------ 2° paper
        figurename      = 'R5_Vx_40kph';
        data            = load('R5_Vx_40kph');
        road_height_tmp = data.zr_FL*10^-3;
        distance_tmp    = data.test_distance;
        start_distance  = 85;
        end_distance    = 735;
        discr           = 0.1003;
        filt            = 1;
        classname       = "A";

    case 4 % R4_Vx_80kph
        figurename      = 'R4_Vx_80kph';
        data            = load('R4_Vx_80kph');
        road_height_tmp = data.zr_FL*10^-3;
        distance_tmp    = data.test_distance/2.6;
        start_distance  = 65;
        end_distance    = 115;
        discr           = 0.1001;
        filt            = 1;
        classname       = "B";

    case 5 % R3_Vx_90kph
        figurename      = 'R3_Vx_90kph';
        data            = load('R3_Vx_90kph');
        road_height_tmp = data.zr_FL*10^-3;
        distance_tmp    = data.test_distance;
        start_distance  = 80;
        end_distance    = 915;
        discr           = 0.1004;
        filt            = 1;
        classname       = "B";

    case 6 % R2_Vx_80kph
        figurename      = 'R2_Vx_80kph';
        data            = load('R2_Vx_80kph');
        road_height_tmp = data.zr_FL*10^-3;
        distance_tmp    = data.test_distance;
        start_distance  = 75;
        end_distance    = 1040;
        discr           = 0.1001;
        filt            = 1;
        classname       = "A";

    case 7 % R1_Vx_100kph
        figurename      = 'R1_Vx_100kph';
        data            = load('R1_Vx_100kph');
        road_height_tmp = data.zr_FL*10^-3;
        distance_tmp    = data.test_distance;
        start_distance  = 85;
        end_distance    = 730;
        discr           = 0.1003;
        filt            = 1;
        classname       = "A";

    case 8 % R1_Vx_40kph
        figurename      = 'R1_Vx_40kph';
        data            = load('R1_Vx_40kph');
        road_height_tmp = data.zr_FL*10^-3;
        distance_tmp    = data.test_distance;
        start_distance  = 34;
        end_distance    = 85;
        discr           = 0.0401;
        filt            = 1;
        classname       = "B";

    case 9 % A_road_train
        figurename      = 'A_road_train';
        data            = load('A_road_train');
        road_height_tmp = data.A_road_train.height;
        distance_tmp    = data.A_road_train.distance;
        start_distance  = 0.0345;
        end_distance    = 45;
        discr           = 0.0345;
        filt            = 3;
        classname       = "A"; % 1.96 - 1.94

    case 10 % B_road_train1
        figurename      = 'B_road_train1';
        data            = load('B_road_train1');
        road_height_tmp = data.B_road_train1.height;
        distance_tmp    = data.B_road_train1.distance;
        start_distance  = 0.0321;
        end_distance    = 45;
        discr           = 0.0321;
        filt            = 3;
        classname       = "B"; % 8.6 - 6.44

    case 11 % C_road_train
        figurename      = 'C_road_train';
        data            = load('C_road_train');
        road_height_tmp = data.C_road_train.height;
        distance_tmp    = data.C_road_train.distance;
        start_distance  = 0.0083;
        end_distance    = 45;
        discr           = 0.0083;
        filt            = 3;
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
% To dB/Hz
psd_db          = pow2db(psd);
% Filter signal
windowSize      = filt; 
b               = (1/windowSize)*ones(1,windowSize);
psd_db_filt     = filter(b,1,psd_db);
% Filter signal
windowSize      = filt; 
b               = (1/windowSize)*ones(1,windowSize);
psd_filt        = filter(b,1,psd);

% Road height in function of distance (full length)
figure(1)
grid on; hold on;
plot(distance_tmp, road_height_tmp, '-.', 'Color', 'b', 'LineWidth', 1.5)
xlabel('$\mathrm{Distance}\ \mathrm{[m]}$', 'interpreter', 'latex', 'FontSize', fontsize)
ylabel('$\mathrm{z_r}\ \mathrm{[m]}$', 'interpreter',' latex', 'FontSize', fontsize)
xlim([0,distance_tmp(end)])
cd("Figures\");
saveas(figure(1),strcat(figurename,'_time_domain'),'fig');
cd("..\");

% Road height in function of distance (only useful distance)
figure(2)
grid on; hold on;
plot(distance, road_height, '-.', 'Color', 'b', 'LineWidth', 1.5)
xlabel('$\mathrm{Distance}\ \mathrm{[m]}$', 'interpreter', 'latex', 'FontSize', fontsize)
ylabel('$\mathrm{z_r}\ \mathrm{[m]}$', 'interpreter',' latex', 'FontSize', fontsize)
xlim([0,distance(end)])
cd("Figures\");
saveas(figure(2),strcat(figurename,'_short_time_domain'),'fig');
cd("..\");

% PSD
figure(3)
grid on; hold on;
semilogx(freq, psd_db, 'Color', 'r', 'LineWidth', 1.5)
semilogx(freq, psd_db_filt, '-.', 'Color', 'b', 'LineWidth', 1.5)
xlim([0 15])
xlabel('$\mathrm{Frequency}\ \mathrm{[Hz]}$', 'interpreter', 'latex', 'FontSize', fontsize)
ylabel('$\mathrm{PSD_{z_r}}\ \mathrm{[dB/Hz]}$', 'interpreter',' latex', 'FontSize', fontsize)
cd("Figures\");
saveas(figure(3),strcat(figurename,'_PSD_dB'),'fig');
cd("..\");

% ISO 8608:2016
figure(4)
subplot(2,1,1)
grid on; hold on;
semilogx(freq, psd, 'Color', 'r', 'LineWidth', 1.5)
semilogx(freq, psd_filt, '-.', 'Color', 'b', 'LineWidth', 1.5)
xlim([0 15])
ylabel('$\mathrm{PSD_{z_r}}\ \mathrm{[m^3/rad]}$', 'interpreter',' latex', 'FontSize', fontsize)
subplot(2,1,2)
grid on; hold on;
semilogx(freq, psd, 'Color', 'r', 'LineWidth', 1.5)
semilogx(freq, psd_filt, '-.', 'Color', 'b', 'LineWidth', 1.5)
xlim([0.9 1.1])
xlabel('$\mathrm{Frequency}\ \mathrm{[Hz]}$', 'interpreter', 'latex', 'FontSize', fontsize)
ylabel('$\mathrm{PSD_{z_r}}\ \mathrm{[m^3/rad]}$', 'interpreter',' latex', 'FontSize', fontsize)
cd("Figures\");
saveas(figure(4),strcat(figurename,'_PSD_',classname),'fig');
cd("..\");