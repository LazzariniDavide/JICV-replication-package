clear all; close all; clc;

warning("off")
open('C1_Full_Car_Model.slx')

% Save simulation data in Results\Sim_data\
filename = sprintf('Fig13_speedBump_NMPCtc');

%% SIMULATION SETTINGS

% 1 - PASSIVE       || 2 - ACTIVE
passive     = 2;
% 1 - W/O PREVIEW   || 2 - W\ PREVIEW
preview     = 2;
% 1 - FIXED         || 2 - RL           || 3 - RB
adaptive    = 1;
% 1 - Speed bump    || 2 - B-road       || 3 - Step
test        = 1;

% Simulink sampling time [s]
Ts_sim = 0.001;

%% ADD FOLDERS

rmpath(genpath('NMPCs\'))
rmpath(genpath('NMPCs2\'))
rmpath(genpath('NMPCs3\'))
rmpath(genpath('NMPCs4\'))

addpath('MF_Swift')
addpath(genpath('Road_profiles\'))
addpath(genpath('NMPCs\'))
% addpath(genpath('NMPCs2\'))
% addpath(genpath('NMPCs3\'))
% addpath(genpath('NMPCs4\'))
addpath('saved_agent\')
addpath('Results\Fig13_sim_data\')

%% Parameters distribution

rng(2)

Fontsize_axis   = 18;
Fontsize_labels = 32;
Fontsize_legend = 32;

N_monte    = 500;  % iterations number (Monte Carlo scenarios)

% Additional sprung mass in the CoG ---------------------------------------
additional_mass_kg_min = -100;                                             % desired lower limit
additional_mass_kg_max = 100;                                              % desired upper limit
additional_mass_kg_scaling = 50;                                           % scaling factor to obtain desired lower and upper limits
for i=1:1:N_monte
    additional_mass_kg(i) = normrnd((additional_mass_kg_max+additional_mass_kg_min)/2,sqrt(additional_mass_kg_scaling*(additional_mass_kg_max-additional_mass_kg_min)/2));
    if additional_mass_kg(i) < 0
        additional_mass_kg(i) = -additional_mass_kg(i);
    end
end

% Drivetrain inertia scaling factor ---------------------------------------
drive_inertia_scal_factor_min = 0.6;                                       % desired lower limit
drive_inertia_scal_factor_max = 1.4;                                       % desired upper limit
drive_inertia_scal_factor_scaling = 0.04;                                  % scaling factor to obtain desired lower and upper limits
for i=1:1:N_monte
    drive_inertia_scal_factor(i) = normrnd((drive_inertia_scal_factor_max+drive_inertia_scal_factor_min)/2,sqrt(drive_inertia_scal_factor_scaling*(drive_inertia_scal_factor_max-drive_inertia_scal_factor_min)/2));
end

% Gain on longitudinal shape factor ----------------------------------------
cx_gain_min = 0.8;                                                         % desired lower limit
cx_gain_max = 1.2;                                                         % desired upper limit
cx_gain_scaling = 0.01;                                                    % scaling factor to obtain desired lower and upper limits
for i=1:1:N_monte
    cx_gain(i) = normrnd((cx_gain_max+cx_gain_min)/2,sqrt(cx_gain_scaling*(cx_gain_max-cx_gain_min)/2));
end

% Road preview position error ---------------------------------------------
road_prev_pos_err_min = -0.15;                                             % desired lower limit
road_prev_pos_err_max = 0.15;                                              % desired upper limit
road_prev_pos_err_scaling = 0.03;                                          % scaling factor to obtain desired lower and upper limits
for i=1:1:N_monte
    road_prev_pos_err(i) = normrnd((road_prev_pos_err_max+road_prev_pos_err_min)/2,sqrt(road_prev_pos_err_scaling*(road_prev_pos_err_max-road_prev_pos_err_min)/2));
end

% Road height preview scaling factor --------------------------------------
road_height_prev_scal_fact_min = 0.5;                                      % desired lower limit
road_height_prev_scal_fact_max = 1.5;                                      % desired upper limit
road_height_prev_scal_fact_scaling = 0.05;                                 % scaling factor to obtain desired lower and upper limits
for i=1:1:N_monte
    road_height_prev_scal_fact(i) = normrnd((road_height_prev_scal_fact_max+road_height_prev_scal_fact_min)/2,sqrt(road_height_prev_scal_fact_scaling*(road_height_prev_scal_fact_max-road_height_prev_scal_fact_min)/2));
end

% Friction preview scaling factor -----------------------------------------
mu_prev_scal_fact_min = 0.6;                                               % desired lower limit
mu_prev_scal_fact_max = 1.4;                                               % desired upper limit
mu_prev_scal_fact_scaling = 0.03;                                          % scaling factor to obtain desired lower and upper limits
for i=1:1:N_monte
    mu_prev_scal_fact(i) = normrnd((mu_prev_scal_fact_max+mu_prev_scal_fact_min)/2,sqrt(mu_prev_scal_fact_scaling*(mu_prev_scal_fact_max-mu_prev_scal_fact_min)/2));
end

%% Plot probability distribution of varied parameters

figname     = 'Fig12_monteCarlo_parameters';

load('negative_improvement_idx')

% Adjust subplot positions manually for proper alignment
figure(1)

set(gcf,"Units","centimeters","Position",[5 5 30 20])

subplot(2,3,1)
set(gca, 'FontSize', Fontsize_axis);
box on; hold on;
[n1, x1] = hist(additional_mass_kg, 20);
h1 = bar(x1, n1, 'hist');
set(h1, 'facecolor', 'w');
[n_neg, x_neg] = hist(additional_mass_kg(negative_improvement_idx{1}), 18);
h_neg = bar(x_neg, n_neg, 'hist');
set(h_neg, 'facecolor', 'b');
xlabel('$m_{b,add}\ \mathrm{[kg]}$', 'interpreter', 'latex', 'fontname', 'Times New Roman', 'FontSize', Fontsize_labels);
ylabel('Samples', 'interpreter', 'latex', 'fontname', 'Times New Roman', 'FontSize', Fontsize_labels);
xlim([0, max(x1)]);

subplot(2,3,2)
set(gca, 'FontSize', Fontsize_axis);
box on; hold on;
[n2, x2] = hist(drive_inertia_scal_factor, 20);
h2 = bar(x2, n2, 'hist');
set(h2, 'facecolor', 'w');
[n_neg, x_neg] = hist(drive_inertia_scal_factor(negative_improvement_idx{1}), 16);
h_neg = bar(x_neg, n_neg, 'hist');
set(h_neg, 'facecolor', 'b');
xlabel('$k_J\ \mathrm{[-]}$', 'interpreter', 'latex', 'fontname', 'Times New Roman', 'FontSize', Fontsize_labels);
ylabel('Samples', 'interpreter', 'latex', 'fontname', 'Times New Roman', 'FontSize', Fontsize_labels);
mean_val = (drive_inertia_scal_factor_min + drive_inertia_scal_factor_max) / 2;
diff_left = mean_val - min(x2);
diff_right = max(x2) - mean_val;
xlim([mean_val - max(diff_left, diff_right), mean_val + max(diff_left, diff_right)]);

subplot(2,3,3)
set(gca, 'FontSize', Fontsize_axis);
box on; hold on;
[n3, x3] = hist(cx_gain, 20);
h3 = bar(x3, n3, 'hist');
set(h3, 'facecolor', 'w');
[n_neg, x_neg] = hist(cx_gain(negative_improvement_idx{1}), 16);
h_neg = bar(x_neg, n_neg, 'hist');
set(h_neg, 'facecolor', 'b');
xlabel('$k_x\ \mathrm{[-]}$', 'interpreter', 'latex', 'fontname', 'Times New Roman', 'FontSize', Fontsize_labels);
ylabel('Samples', 'interpreter', 'latex', 'fontname', 'Times New Roman', 'FontSize', Fontsize_labels);
mean_val = (cx_gain_min + cx_gain_max) / 2;
diff_left = mean_val - min(x3);
diff_right = max(x3) - mean_val;
xlim([mean_val - max(diff_left, diff_right), mean_val + max(diff_left, diff_right)]);

subplot(2,3,4)
set(gca, 'FontSize', Fontsize_axis);
box on; hold on;
[n4, x4] = hist(road_prev_pos_err, 20);
h4 = bar(x4, n4, 'hist');
set(h4, 'facecolor', 'w');
[n_neg, x_neg] = hist(road_prev_pos_err(negative_improvement_idx{1}), 16);
h_neg = bar(x_neg, n_neg, 'hist');
set(h_neg, 'facecolor', 'b');
xlabel('$x_{err}\ \mathrm{[m]}$', 'interpreter', 'latex', 'fontname', 'Times New Roman', 'FontSize', Fontsize_labels);
ylabel('Samples', 'interpreter', 'latex', 'fontname', 'Times New Roman', 'FontSize', Fontsize_labels);
mean_val = (road_prev_pos_err_min + road_prev_pos_err_max) / 2;
diff_left = mean_val - min(x4);
diff_right = max(x4) - mean_val;
xlim([mean_val - max(diff_left, diff_right), mean_val + max(diff_left, diff_right)]);

subplot(2,3,5)
set(gca, 'FontSize', Fontsize_axis);
box on; hold on;
[n5, x5] = hist(road_height_prev_scal_fact, 20);
h5 = bar(x5, n5, 'hist');
set(h5, 'facecolor', 'w');
[n_neg, x_neg] = hist(road_height_prev_scal_fact(negative_improvement_idx{1}), 15);
h_neg = bar(x_neg, n_neg, 'hist');
set(h_neg, 'facecolor', 'b');
xlabel('$k_{r}\ \mathrm{[-]}$', 'interpreter', 'latex', 'fontname', 'Times New Roman', 'FontSize', Fontsize_labels);
ylabel('Samples', 'interpreter', 'latex', 'fontname', 'Times New Roman', 'FontSize', Fontsize_labels);
mean_val = (road_height_prev_scal_fact_min + road_height_prev_scal_fact_max) / 2;
diff_left = mean_val - min(x5);
diff_right = max(x5) - mean_val;
xlim([mean_val - max(diff_left, diff_right), mean_val + max(diff_left, diff_right)]);

subplot(2,3,6)
set(gca, 'FontSize', Fontsize_axis);
box on; hold on;
[n6, x6] = hist(mu_prev_scal_fact, 20);
h6 = bar(x6, n6, 'hist');
set(h6, 'facecolor', 'w');
[n_neg, x_neg] = hist(mu_prev_scal_fact(negative_improvement_idx{1}), 10);
h_neg = bar(x_neg, n_neg, 'hist');
set(h_neg, 'facecolor', 'b');
xlabel('$k_{\mu}\ \mathrm{[-]}$', 'interpreter', 'latex', 'fontname', 'Times New Roman', 'FontSize', Fontsize_labels);
ylabel('Samples', 'interpreter', 'latex', 'fontname', 'Times New Roman', 'FontSize', Fontsize_labels);
mean_val = (mu_prev_scal_fact_min + mu_prev_scal_fact_max) / 2;
diff_left = mean_val - min(x6);
diff_right = max(x6) - mean_val;
xlim([mean_val - max(diff_left, diff_right), mean_val + max(diff_left, diff_right)]);

cd('Plots\')
% --- Export ---
set(gcf, 'Renderer', 'painters');
print(gcf, figname, '-dsvg');
cd('..\')

% return;

%% VEHICLE PARAMETERS

data = A2_Full_car_model_parameters_4onBoard();

run('A3_Parameters_MF_Swift.m');

%% INITIAL STATES

speed_ini               = 40;   % [km/h]
pos_ini                 = 0;    % [m]

% Body
z_b_dot_ini             = 0;
z_b_ini                 = 0;
x_b_dot_ini             = speed_ini/3.6;
x_b_ini                 = data.b+pos_ini;
Pitch_dot               = 0;
Pitch                   = 0;

% Rear - Left Wheel
z_u_dot_ini_R_L         = 0;
z_u_ini_R_L             = 0;
x_u_dot_ini_R_L         = speed_ini/3.6 - 1.125*1e-4;
x_u_ini_R_L             = pos_ini;
omega_ini_R_L           = x_u_dot_ini_R_L/data.R_R +2.483*1e-6;
slip_ini_R_L            = 0;
torque_ini_R_L          = 0;

% Rear - Right Wheel
z_u_dot_ini_R_R         = 0;
z_u_ini_R_R             = 0;
x_u_dot_ini_R_R         = speed_ini/3.6 - 1.125*1e-4;
x_u_ini_R_R             = pos_ini;
omega_ini_R_R           = x_u_dot_ini_R_R/data.R_R+2.483*1e-6;
slip_ini_R_R            = 0;
torque_ini_R_R          = 0;

% Rear differential
theta_df_dot_ini_R      = omega_ini_R_R;
delta_theta_s_dot_ini_R = 0;
theta_w_ini_R_L         = -1.056*1e-2;
theta_s_ini_R_L         = 0;
theta_s_ini_R_R         = 0;
T_hs_ini_R_L            = 0;
T_hs_ini_R_R            = 0;

% Front - Left Wheel
z_u_dot_ini_F_L         = 0;
z_u_ini_F_L             = 0;
x_u_dot_ini_F_L         = speed_ini/3.6 - 1.125*1e-4;
x_u_ini_F_L             = data.a+data.b+pos_ini;
omega_ini_F_L           = x_u_dot_ini_F_L/data.R_F;
slip_ini_F_L            = 0;
torque_ini_F_L          = 0;

% Front - Right Wheel
z_u_dot_ini_F_R         = 0;
z_u_ini_F_R             = 0;
x_u_dot_ini_F_R         = speed_ini/3.6 - 1.125*1e-4;
x_u_ini_F_R             = data.a+data.b+pos_ini;
omega_ini_F_R           = x_u_dot_ini_R_R/data.R_F;
slip_ini_F_R            = 0;
torque_ini_F_R          = 0;

% Front differential
theta_df_dot_ini_F      = omega_ini_F_R;
theta_w_ini_F_L         = -1.056*1e-2;
delta_theta_s_dot_ini_F = 0;
theta_s_ini_F_L         = 0;
theta_s_ini_F_R         = 0;
T_hs_ini_F_L            = 0;
T_hs_ini_F_R            = 0;

%% ========================================================================
% =========================================================================
% ================================== NMPC =================================
% =========================================================================
% =========================================================================

%% NMPC PARAMETERS

% Sampling time vector
Ts      = 1e-3*[0 5 10 15 20 25 30 40 60 80 100];   % NMPCs
% Ts      = 1e-3*[0 5 10 15 20 30 40];                % NMPCs2
% Ts      = 1e-3*[0 5 10 20 30 40 80];                % NMPCs3
% Ts      = 1e-3*[0 10 20 30 50 60 100];              % NMPCs4
% Prediction horizon steps
N       = 10;
% Preview steps
M       = N;
% Number of solver iterations
N_iter  = 3;

%% COST FUNCTION WEIGHTS

% NMPCin - General weights
Q1                   = 1e7;
Q2                   = 1e5;
QN1                  = 0;
QN2                  = 0;
R1                   = 1e10;
R2                   = 1e2;

switch test
    case 1 % Speed bump
        % NMPCcm
        % % % Q1                   = 1e8;
        % % % Q2                   = 0;
        % % % QN1                  = 0;
        % % % QN2                  = 0;
        % % % R1                   = 0;
        % % % R2                   = 1e2;

        % NMPCaj
        % % % Q1                   = 0;
        % % % Q2                   = 1e6;
        % % % QN1                  = 0;
        % % % QN2                  = 0;
        % % % R1                   = 0;
        % % % R2                   = 1e2;

        % NMPCtc
        Q1                   = 0;
        Q2                   = 0;
        QN1                  = 0;
        QN2                  = 0;
        R1                   = 1e10;
        R2                   = 1e2;

        % NMPCin
        % % % Q1                   = 1e7;
        % % % Q2                   = 1e5;
        % % % QN1                  = 0;
        % % % QN2                  = 0;
        % % % R1                   = 1e9;
        % % % R2                   = 1e2;

    case 2 % B-road
        % NMPCcm
        % % % Q1                   = 1e8;
        % % % Q2                   = 0;
        % % % QN1                  = 0;
        % % % QN2                  = 0;
        % % % R1                   = 0;
        % % % R2                   = 1e2;

        % NMPCcmaj
        % % % Q1                   = 1e8;
        % % % Q2                   = 1e6;
        % % % QN1                  = 0;
        % % % QN2                  = 0;
        % % % R1                   = 0;
        % % % R2                   = 1e2;

        % NMPCin
        Q1                   = 1e7;
        Q2                   = 1e5;
        QN1                  = 0;
        QN2                  = 0;
        R1                   = 1e10;
        R2                   = 1e2;

    case 3 % Step
        % NMPCcm
        % % % Q1                   = 1e9;
        % % % Q2                   = 0;
        % % % QN1                  = 0;
        % % % QN2                  = 0;
        % % % R1                   = 0;
        % % % R2                   = 1e2;

        % NMPCaj
        % % % Q1                   = 0;
        % % % Q2                   = 1e6;
        % % % QN1                  = 0;
        % % % QN2                  = 0;
        % % % R1                   = 0;
        % % % R2                   = 1e2;

        % NMPCtc
        % % % Q1                   = 0;
        % % % Q2                   = 0;
        % % % QN1                  = 0;
        % % % QN2                  = 0;
        % % % R1                   = 1e10;
        % % % R2                   = 1e2;

        % NMPCin
        Q1                   = 1e6;
        Q2                   = 1e5;
        QN1                  = 0;
        QN2                  = 0;
        R1                   = 1e10;
        R2                   = 1e2;

        % NMPCin2_N3
        % % % Q1                   = 1e7;
        % % % Q2                   = 1e5;
        % % % QN1                  = 0;
        % % % QN2                  = 0;
        % % % R1                   = 1e10;
        % % % R2                   = 1e2;

        % NMPCin2_N2
        % % % Q1                   = 1e7;
        % % % Q2                   = 1e5;
        % % % QN1                  = 0;
        % % % QN2                  = 0;
        % % % R1                   = 1e10;
        % % % R2                   = 1e2;

        % NMPCin2_N1
        % % % Q1                   = 1e6;
        % % % Q2                   = 1e5;
        % % % QN1                  = 0;
        % % % QN2                  = 0;
        % % % R1                   = 1e10;
        % % % R2                   = 1e2;

        % NMPCin3_N3
        % % % Q1                   = 1e6;
        % % % Q2                   = 1e5;
        % % % QN1                  = 0;
        % % % QN2                  = 0;
        % % % R1                   = 1e10;
        % % % R2                   = 1e2;

        % NMPCin3_N2
        % % % Q1                   = 1e6;
        % % % Q2                   = 1e5;
        % % % QN1                  = 0;
        % % % QN2                  = 0;
        % % % R1                   = 1e10;
        % % % R2                   = 1e2;

        % NMPCin3_N1
        % % % Q1                   = 1e6;
        % % % Q2                   = 1e5;
        % % % QN1                  = 0;
        % % % QN2                  = 0;
        % % % R1                   = 1e10;
        % % % R2                   = 1e2;

        % NMPCin4_N3
        % % % Q1                   = 1e6;
        % % % Q2                   = 1e5;
        % % % QN1                  = 0;
        % % % QN2                  = 0;
        % % % R1                   = 1e10;
        % % % R2                   = 1e2;

        % NMPCin4_N2
        % % % Q1                   = 1e6;
        % % % Q2                   = 1e5;
        % % % QN1                  = 0;
        % % % QN2                  = 0;
        % % % R1                   = 1e9;
        % % % R2                   = 1e2;

        % NMPCin4_N1
        % % % Q1                   = 1e6;
        % % % Q2                   = 1e5;
        % % % QN1                  = 0;
        % % % QN2                  = 0;
        % % % R1                   = 1e10;
        % % % R2                   = 1e2;

end

W                 = diag([0 0 0 1e2]);
WN                = diag([0 0]);
Wmat_NMPC_init    = [W(1,:) W(2,:) W(3,:) W(4,:)];
WNmat_NMPC_init   = [WN(1,:) WN(2,:)];

%% NMPC INITIAL CONDITIONS

% z_b_dot z_b z_u_dot z_u x_b_dot x_b x_u_dot x_u ...
% theta_w_dot theta_w theta_s_dot theta_s torque

X_0 = [z_b_dot_ini z_b_ini z_u_dot_ini_F_L z_u_ini_F_L x_b_dot_ini x_b_ini x_u_dot_ini_F_L x_u_ini_F_L ...
        omega_ini_F_L theta_w_ini_F_L omega_ini_F_L theta_s_ini_F_L torque_ini_F_L];

xInit   = X_0.'; % Initial states values

zInit   = [];
uInit   = 0;     % Initial control action
bValues = [];    % bound values are fixed in the generated code

% a_b_ref saturation
a_b_ref_sat = [ zeros(1,10);
                0.67*ones(1,10);
                0.94 1.46*ones(1,9);
                0.94 1.9 2.25*ones(1,8);
                0.94 1.9 2.65 3.04*ones(1,7);
                0.94 1.9 2.9 3.35 3.83*ones(1,6);
                0.94 1.9 2.9 3.35 4 4.27 4.62*ones(1,4);
                0.94 1.9 2.9 3.35 4.35 4.6 4.85 5.1 5.42*ones(1,2)];

%% ========================================================================
% =========================================================================
% ========================= ADAPTIVE TUNING LAYER =========================
% =========================================================================
% =========================================================================

%% Rule Based Weight adaptation parameters

% W1
w1_min  = -10;
w1_max  = 9;
w1_k    = 5000;
w1_h0   = 0.0008;
w1_sat  = 0.085;

% W1 2
% w1_min  = -10;
% w1_max  = 9;
% w1_k    = 9000;
% w1_h0   = 0.00045;
% w1_sat  = 0.07;

% W2
w2_min  = -10;
w2_max  = 5.3;
w2_k    = 10;
w2_h0   = 2;
w2_inc  = 0.05;

% R1
r1_min  = -10;
r1_max  = 11;
r1_k    = 1000;
r1_h0   = 0.99; 

% R2
r2      = 2;

%% REINFORCEMENT LEARNING

% Front
load("saved_agent/trainedAgent_episode_front.mat","agent");
delete('blockAgentData.mat');
generatePolicyBlock(agent);
bdclose("untitled")
movefile('blockAgentData.mat', 'blockAgentData_front.mat');

% Rear
load("saved_agent/trainedAgent_episode_rear.mat","agent");
delete('blockAgentData.mat');
generatePolicyBlock(agent);
bdclose("untitled")
movefile('blockAgentData.mat', 'blockAgentData_rear.mat');

R2_rl   = 2;

% Action limits
LowLim_Q1   = -10;
Q1_sat      = 0;

%% ========================================================================
% =========================================================================
% ================================== TEST =================================
% =========================================================================
% =========================================================================

%% TEST SELECTION

currentPath = fileparts(mfilename('fullpath'));

switch test
    case 1 % Speed bump
        t_end_sim           = 1.6;
        start_distance      = 8;
        end_distance        = 14;

        % Load .crg file of road height profile
        Sbump_selector      = 3;
        handmade_front      = 'handmade_speed_bump_index.crg';
        handmade_front      = strrep(handmade_front,'index',num2str(Sbump_selector));
        handmade_front      = strcat(currentPath,'\Road_profiles\height_crg_files\',handmade_front);
        handmade_rear       = handmade_front;
        
        % Load .crg file of road friction profile
        handmade_mu_front   = strcat(currentPath,'\Road_profiles\friction_crg_files\','handmade_fric_sbump.crg');
        handmade_mu_rear    = handmade_mu_front;

        % Road height LUT for NMPC
        multiplier          = [0.5 0.75 1 1.25 1.5 1.75 2 0.5 0.75 1 1.25 1.5 1.75 2];
        if Sbump_selector >= 1 && Sbump_selector < 8 % Type 1
            h_road  = 0.055;
            b_road  = 0.9/2;
        else % Type 2
            h_road  = 0.04;
            b_road  = 0.6/2;
        end
        x_bump              = -b_road:0.01:b_road;
        z_bump              = h_road/2*(1+cos(pi*x_bump/b_road));
        road_profile        = [zeros(1,1001), z_bump, zeros(1,2000-length(z_bump))] ...
            *1000*multiplier(Sbump_selector); % Road height profile
        test_distance       = 0:0.01:30; % Road displacement discretization

        % Road friction LUT for NMPC
        mu_road             = [ones(1,(1001+(length(x_bump)-1)/2)) ...
            0.1*ones(1,2000-(length(x_bump)-1)/2)];
        mu_distance         = test_distance;

        % Torque demand profile
        l_discr             = 0:0.01:data.L;
        Ft_demand_F         = [zeros(1,(1001+(length(x_bump)-1)/2)) ...
            ones(1,(2000-(length(x_bump)-1)/2))*200]./data.R_F; % Required force F
        Ft_demand_R = [zeros(1,(1001+(length(x_bump)-1)/2-length(l_discr))) ...
            ones(1,(2000-(length(x_bump)-1)/2+length(l_discr)))*200]./data.R_R; % Required force R
        T_distance          = test_distance;

    case 2 % B-road
        t_end_sim           = 2.7;
        start_distance      = 10;
        end_distance        = 20;

        % Load .crg file of road height profile
        handmade_front      = strcat(currentPath,'\Road_profiles\height_crg_files\','B_road_train1.crg');
        handmade_rear       = handmade_front;
        
        % Load .crg file of road friction profile
        handmade_mu_front   = strcat(currentPath,'\Road_profiles\friction_crg_files\','handmade_fric_broad.crg');
        handmade_mu_rear    = handmade_mu_front;

        % Road height LUT for NMPC
        load B_road_train1.mat;
        test_distance       = B_road_train1.distance(1):0.01:B_road_train1.distance(end); % Road displacement discretization
        road_profile        = spline(B_road_train1.distance,B_road_train1.height,test_distance)*1e3; % Road height profile

        % Road friction LUT for NMPC
        mu_road             = [ones(1,1501) 0.1*ones(1,length(test_distance)-1501)];
        mu_distance         = test_distance;

        % Torque demand profile
        l_discr             = 0:0.01:data.L;
        Ft_demand_F         = [zeros(1,1501) ...
            200*ones(1,length(test_distance)-1501)]./data.R_F; % Required force F
        Ft_demand_R         = [zeros(1,1501-length(l_discr)) ...
            200*ones(1,length(test_distance)-1501+length(l_discr))]./data.R_R; % Required force R
        T_distance          = test_distance;

    case 3 % Step
        t_end_sim           = 1.6;
        start_distance      = 4;
        end_distance        = 13;

        % Load .crg file of road height profile
        Step_selector       = 3;
        handmade_front      = strcat(currentPath,'\Road_profiles\height_crg_files\','handmade_step_3cm_singlefunctions.crg');
        handmade_rear       = handmade_front;
        
        % Load .crg file of road friction profile
        handmade_mu_front   = strcat(currentPath,'\Road_profiles\friction_crg_files\','handmade_fric_step_01_singlefunctions.crg');
        handmade_mu_rear    = handmade_mu_front;

        % Road height LUT for NMPC
        road_profile        = [zeros(1,801),ones(1,2200)*10*Step_selector]; % Road height profile
        test_distance       = 0:0.01:30; % Road displacement discretization

        % Road friction LUT for NMPC
        mu_road             = [ones(1,1001), 0.1*ones(1,2000)];
        mu_distance         = test_distance;

        % Torque demand profile
        l_discr             = 0:0.01:data.L;
        Ft_demand_F         = [zeros(1,601) 200*ones(1,2400)]./data.R_F; % Required force F
        Ft_demand_R         = [zeros(1,(601-length(l_discr))) ...
            200*ones(1,(2400+length(l_discr)))]./data.R_R; % Required force R
        T_distance          = test_distance;

end

%% ========================================================================
% =========================================================================
% =============================== TOOLCHAIN ===============================
% =========================================================================
% =========================================================================

KPIs = zeros(N_monte,5);

for i = 1:N_monte

    fprintf("Loading test n°%d...\n\n",i);

    % Vehicle parameters
    data = A2_Full_car_model_parameters_4onBoard();

    % Additional sprung mass
    data.m_b        = data.m_b + additional_mass_kg(i);
    data.m_total    = data.m_total + additional_mass_kg(i);

    % Longitudinal slip stiffness scaling factor
    newValue = 34.4585*cx_gain(i);
    parFile = 'MF_Swift\Siemens_car205_60R15.tir';
    txt = fileread(parFile);
    pattern = '(PKX1\s*=\s*)[-+]?\d*\.?\d+(.*)';
    txt = regexprep(txt, pattern, sprintf('$1%.4f$2', newValue));
    fid = fopen(parFile, 'w');
    fwrite(fid, txt);
    fclose(fid);

    % Drivetrain equivalent inertia scaling factor
    data.J_eq_F4    = data.J_eq_F4*drive_inertia_scal_factor(i);
    data.J_eq_R4    = data.J_eq_R4*drive_inertia_scal_factor(i);

    % Position preview error
    x_err           = road_prev_pos_err(i);

    % Road height preview scaling factor
    k_r             = road_height_prev_scal_fact(i);

    % Friction preview scaling factor
    k_mu            = mu_prev_scal_fact(i);

    % Run simulink
    sim("C1_Full_Car_Model.slx")

    KPI     = A4_KPIs(BUS, a_b_ref_sim, slip_ref_front_sim, slip_ref_rear_sim, start_distance, end_distance);
    KPIs(i,:) = [KPI.RMSE_x_b_ddot KPI.VDV_x_b_ddot KPI.max_delta_omega KPI.RMS_slip_viol_F KPI.slip_viol_max];
end

cd("Results\Fig13_sim_data\")
save(filename,"KPIs");
cd("..\..\")