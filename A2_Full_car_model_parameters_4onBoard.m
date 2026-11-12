function data = A2_Full_car_model_parameters_4onBoard()

%% TYRE
data.R_F     = 0.3725;      % Effective radius
data.R_R     = 0.3725;      % Effective radius
data.f_0_F   = 0.01075;     % Rolling resistance coefficient
data.f_2_F   = 0;           % Rolling resistance coefficient
data.f_0_R   = 0.01075;     % Rolling resistance coefficient
data.f_2_R   = 0;           % Rolling resistance coefficient
data.k_t_F   = 317634;      % Tangential tyre Stiffness 317634
data.k_r_F   = data.k_t_F;  % Radial tyre Stiffness 
data.c_t_F   = 50;          % Tangetial Tyre damper 50
data.k_t_R   = data.k_t_F;  % Tangential tyre Stiffness
data.k_r_R   = data.k_t_R;  % Radial tyre Stiffness
data.c_t_R   = data.c_t_F;  % Tangetial Tyre damper
data.I_y_F   = 1.6-0.211;   % Wheel inertia
data.I_y_R   = 1.6-0.211;   % Wheel inertia
data.L_slip  = 0.25;        % Relaxation length [m]

%% CAR MODEL PARAMETERS
data.m_u_F    = 30;                          % Front unsprung mass 
data.m_u_R    = 30;                          % Rear individual unsprung mass
data.a        = 1.4727;                      % Front wheelbase
data.b        = 1.4553;                      % Rear wheelbase
data.L        = data.a + data.b;                       % Wheelbase
data.hg       = 0.631;                       % COG height
data.m_b      = (2593+49*4);               % Sprung mass
data.m_app_FL = data.m_b + 2*data.m_u_R + data.m_u_F + 2*data.I_y_R/(data.R_R^2) + data.I_y_F/(data.R_F^2);    % Massa apparente
data.m_app_RL = data.m_b + 2*data.m_u_F + data.m_u_R + 2*data.I_y_F/(data.R_F^2) + data.I_y_R/(data.R_R^2);    % Massa apparente
data.m_total  = (data.m_b + 2*data.m_u_F + 2*data.m_u_R); % Total mass
data.I_b_y    = 2200/2;                      % Half vehicle body inertia

%% SUNSPENSION PARAMETERS
data.AP_F    = 0.05;   % Anti properties percentages (5%)
data.AP_R    = 0.05;   % Anti properties percentages (5%)
data.p_inst  = 0.5;    % Front to Total distribution installation
data.c_x_F   = 1800;   % Front damper parameter x_axis (C_ew = C*2)
data.k_x_F   = 600000; % Front stiffness parameter x_axis (K_ew = K*2)
data.c_x_R   = 1800;   % Rear damper parameter x_axis (C_ew = C*2)
data.k_x_R   = 600000; % Read stiffness parameter x_axis (K_ew = K*2)
data.k_z_F   = 33000;  % Front stiffness parameter z_axis
data.k_z_R   = 33000;  % Rear stiffness parameter z_axis

%% AERODYNAMICS
data.g           = 9.81;
data.C_d         = 0.28;
data.A_car       = 2.65;
data.rho_air     = 1.20448;
data.Aero_Coeff  = 0.5*data.rho_air*data.C_d*data.A_car; % Aerodynamic force coefficient

%% PACEJKA COEFFICIENT FOR CALCULATING Fx: FIRST FORMULATION
data.b0   = 1.65;
data.b1   = -7.6118;
data.b2   = 1122.6;
data.b3   = -0.00736;
data.b4   = 144.82;
data.b5   = -0.076614;
data.b6   = -0.00386;
data.b7   = 0.085055;
data.b8   = 0.075719;
data.b9   = 0.023655;
data.b10  = 0.023655;

%% ENVELOPING MODEL
% .tir file
data.ls       = 0.67/5; % Scaling of distance between front and rear ellipsoid
data.bc       = 1.32/2; % Semi major axis of ellipsoid
data.ac       = 0.8;    % Semi minor axis of ellipsoid
data.c        = 1.6;    % Order of ellipsoid
data.ac_step  = 0.01;

data.L_Rel  = data.L_slip; % Relaxation length [m]

%% DAMPER LOOK UP TABLES
data.Damper_speed    = [-0.5,-0.4,-0.25,-0.125,-0.05,0,0.05,0.125,0.25,0.4,0.5];
% Front Damper
data.Damper_force_F  = [-903,-823,-705,-560,-200,0,605,1825,2148,2400,2542];
% Rear Damper
data.Damper_force_R  = [-1417,-1300,-1105,-570,-230,0,730,2120,2500,2820,3005];

% Installation ratio
data.Wheel_displacement   = [-100, 100]*10^(-3); % from mm to m
data.Spring_displacement  = [-100, 100]*10^(-3);
data.Damper_displacement  = [-71, 71]*10^(-3);

%% MOTOR TORQUE BOUNDARIES
data.Tm_max = 350;
%noise_intensity = [1.4 1.8 2.2 2.8];

%% REAR AXLES
% Electric motor
data.J_m_R4         = 0.067;         % Electric motor moment of inertia   [kg*m^2] (Toyota Camry)
data.tau_R4          = 0.0056995;        % Motor time constant [s]

% Gearbox 1
data.J_g_1_R4       = 0.0019;        % Primary gear moment of inertia     [kg*m^2]
data.J_g_2_R4       = 0.0049;        % Secondary gear moment of inertia   [kg*m^2]
data.i_g1_R4        = 2.128;           % Gearbox transmission ratio
data.n_g1_R4        = 0.98;          % Gearbox efficiency

% Gearbox 2
data.J_g_3_R4       = 0.0019;        % Primary gear moment of inertia     [kg*m^2]
data.J_g_4_R4       = 0.0049;        % Secondary gear moment of inertia   [kg*m^2]
data.i_g2_R4        = 2.128;           % Gearbox transmission ratio
data.n_g2_R4        = 0.98;          % Gearbox efficiency

% Half shaft
data.J_hs_R4        = 8.589*10^(-5); % Left half shaft moment of inertia  [kg*m^2]
data.backlash_R4    = 0.0105;        % Left half shaft backlash           [rad] (1.2°) 0.0105
data.k_hs_R4        = 7700;          % Left half shaft spring constant    [N*m/rad]
data.b_hs_R4        = 47;            % Left half shaft damper constant    [N*m*s/rad]

data.i_t_R4         = data.i_g1_R4 * data.i_g2_R4;
data.n_t_R4         = data.n_g1_R4 * data.n_g2_R4;

data.J_eq_R4        = data.J_m_R4*data.i_t_R4^2*data.n_t_R4 + data.J_g_1_R4*data.i_t_R4^2*data.n_t_R4 + data.J_g_2_R4*data.i_g2_R4^2*data.n_g2_R4 + data.J_g_3_R4*data.i_g2_R4^2*data.n_g2_R4 + data.J_g_4_R4 + 0.5*data.J_hs_R4;

%% FRONT AXLES
% Electric motor
data.J_m_F4         = 0.067;         % Electric motor moment of inertia   [kg*m^2]
data.tau_F4          = 0.0056995;        % Motor time constant [s]

% Gearbox 1
data.J_g_1_F4       = 0.0019;        % Primary gear moment of inertia     [kg*m^2]
data.J_g_2_F4       = 0.0049;        % Secondary gear moment of inertia   [kg*m^2]
data.i_g1_F4        = 2.128;           % Gearbox transmission ratio
data.n_g1_F4        = 0.98;          % Gearbox efficiency

% Gearbox 2
data.J_g_3_F4       = 0.0019;        % Primary gear moment of inertia     [kg*m^2]
data.J_g_4_F4       = 0.0049;        % Secondary gear moment of inertia   [kg*m^2]
data.i_g2_F4        = 2.128;           % Gearbox transmission ratio
data.n_g2_F4        = 0.98;          % Gearbox efficiency

% Half shaft
data.J_hs_F4        = 8.589*10^(-5); % Left half shaft moment of inertia  [kg*m^2]
data.backlash_F4    = 0.0105;        % Left half shaft backlash           [rad] (1.2°) 0.0105
data.k_hs_F4        = 7700;          % Left half shaft spring constant    [N*m/rad]
data.b_hs_F4        = 47;            % Left half shaft damper constant    [N*m*s/rad]

data.i_t_F4         = data.i_g1_F4 * data.i_g2_F4;
data.n_t_F4         = data.n_g1_F4 * data.n_g2_F4;

data.J_eq_F4        = data.J_m_F4*data.i_t_F4^2*data.n_t_F4 + data.J_g_1_F4*data.i_t_F4^2*data.n_t_F4 + data.J_g_2_F4*data.i_g2_R4^2*data.n_g2_R4 + data.J_g_3_F4*data.i_g2_R4^2*data.n_g2_R4 + data.J_g_4_F4 + 0.5*data.J_hs_R4;

%% Control action bounds
data.Lb_Tm = -350;          % Lower bound
data.Ub_Tm = 350;           % Upper bound

data.a_diff  = 100;

%% Rotational balance
data.FNOMIN          = 7000;
data.QSY1            = 0.01;
data.QSY2            = 0;

%% Longitudinal motion
data.PCX1                     = 1.4106;            % Shape factor Cfx for longitudinal force         
data.PDX1                     = 1.2267;            % Longitudinal friction Mux at Fznom         
data.PDX2                     = 0.0113;            % Variation of friction Mux with load         
data.PDX3                     = 1.4828;            % Variation of friction Mux with camber         
data.PEX1                     = -0.2559;           % Longitudinal curvature Efx at Fznom         
data.PEX2                     = 0.1301;            % Variation of curvature Efx with load         
data.PEX3                     = 0;                 % Variation of curvature Efx with load squared         
data.PEX4                     = 0;                 % Factor in curvature Efx while driving         
data.PKX1                     = 34.4585;           % Longitudinal slip stiffness Kfx/Fz at Fznom         
data.PKX2                     = 11.5014;           % Variation of slip stiffness Kfx/Fz with load         
data.PKX3                     = 0;                 % Exponent in slip stiffness Kfx/Fz with load         
data.PHX1                     = 0;                 % Horizontal shift Shx at Fznom         
data.PHX2                     = 0;                 % Variation of shift Shx with load         
data.PVX1                     = 0;                 % Vertical shift Svx/Fz at Fznom         
data.PVX2                     = 0;                 % Variation of shift Svx/Fz with load 
data.LCX                      = 1;                 % Scale factor of Fx shape factor         
data.LMUX                     = 1;                 % Scale factor of Fx peak friction coefficient         
data.LEX                      = 1;                 % Scale factor of Fx curvature factor         
data.LKX                      = 1;                 % Scale factor of Fx slip stiffness         
data.LHX                      = 1;                 % Scale factor of Fx horizontal shift         
data.LVX                      = 1;                 % Scale factor of Fx vertical shift         
data.LFZO                     = 1;                 % Scale factor of nominal (rated) load
data.gammaFL         = 0;
data.mu_max          = 1;
data.FZ0             = 7000;
data.LGAX            = 0;

end