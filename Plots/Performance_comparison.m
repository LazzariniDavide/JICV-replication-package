clear all; close all; clc;

rmpath(genpath('../Results/'))

%% TO SELECT

% Figure 8
% addpath("../Results/Fig8_sim_data/")
% figname     = 'Fig8_speedBumpTest';
% filenames   = {'Fig8_speedBump_passive','Fig8_speedBump_NMPCcm','Fig8_speedBump_NMPCaj','Fig8_speedBump_NMPCtc','Fig8_speedBump_NMPCin'};
% legends     = {'Passive','NMPC$_\mathrm{cm}$','NMPC$_\mathrm{aj}$','NMPC$_\mathrm{tc}$','NMPC$_\mathrm{in}$'};
% xlim_min    = 8;
% xlim_max    = 14;
% colors      = {[1.00 0.78 0.28], [0.41 0.91 0.05], 'r', 'c', 'b'};

% Figure 9
% addpath("../Results/Fig9_sim_data/")
% figname     = 'Fig9_bRoadTest';
% filenames   = {'Fig9_11_bRoad_passive','Fig9_bRoad_NMPCcm','Fig9_bRoad_NMPCcmaj','Fig9_11_bRoad_NMPCin'};
% legends     = {'Passive','NMPC$_\mathrm{cm}$','NMPC$_\mathrm{cm,aj}$','NMPC$_\mathrm{in}$'};
% xlim_min    = 10;
% xlim_max    = 20;
% colors      = {[1.00 0.78 0.28], [0.41 0.91 0.05], 'r', 'b'};

% Figure 10
% addpath("../Results/Fig10_sim_data/")
% figname     = 'Fig10_stepTest';
% filenames   = {'Fig10_step_passive','Fig10_step_NMPCin','Fig10_step_NMPCrb','Fig10_step_NMPCrl'};
% legends     = {'Passive','NMPC$_\mathrm{in}$','NMPC$_\mathrm{rb}$','NMPC$_\mathrm{rl}$'};
% xlim_min    = 4;
% xlim_max    = 13;
% colors      = {[1.00 0.78 0.28], 'b', 'r', 'g'};

% Figure 11
addpath("../Results/Fig11_sim_data/")
figname     = 'Fig11_bRoadTest';
filenames   = {'Fig9_11_bRoad_passive','Fig9_11_bRoad_NMPCin','Fig11_bRoad_NMPCrb','Fig11_bRoad_NMPCrl'};
legends     = {'Passive','NMPC$_\mathrm{in}$','NMPC$_\mathrm{rb}$','NMPC$_\mathrm{rl}$'};
xlim_min    = 10;
xlim_max    = 20;
colors      = {[1.00 0.78 0.28], 'b', 'r', 'g'};

% Other figure
% addpath("../Results/Fig10_sim_data/")
% figname     = 'Fig_tmp';
% filenames   = {'Fig10_step_passive','Fig10_step_NMPCrb','Fig10_step_NMPCrb2'};
% legends     = {'Passive','NMPC$_\mathrm{rb}$','NMPC$_\mathrm{rb,2}$'};
% xlim_min    = 4;
% xlim_max    = 13;
% colors      = {[0 0.4470 0.7410], [0.8500 0.3250 0.0980], [0.9290 0.6940 0.1250], [0.4940 0.1840 0.5560], [0.4660 0.6740 0.1880], [0.3010 0.7450 0.9330], [0.6350 0.0780 0.1840]};

% Other figure
% addpath("../Results/Fig11_sim_data/")
% figname     = 'Fig_tmp';
% filenames   = {'Fig9_11_bRoad_passive','Fig9_11_bRoad_NMPCin','Fig11_bRoad_NMPCrb','Fig11_bRoad_NMPCrb2','Fig11_bRoad_NMPCrb3'};
% legends     = {'Passive','NMPC$_\mathrm{in}$','NMPC$_\mathrm{rb}$','NMPC$_\mathrm{rb,2}$','NMPC$_\mathrm{rb,3}$'};
% xlim_min    = 10;
% xlim_max    = 20;
% colors      = {[0 0.4470 0.7410], [0.8500 0.3250 0.0980], [0.9290 0.6940 0.1250], [0.4940 0.1840 0.5560], [0.4660 0.6740 0.1880], [0.3010 0.7450 0.9330], [0.6350 0.0780 0.1840]};

%% --- Styling Parameters ---
fontsize_axis    = 6;
fontsize_labels  = 10;
fontsize_legend  = 8;
line_width       = 1;
% fontsize_axis    = 14;
% fontsize_labels  = 18;
% fontsize_legend  = 18;
% line_width       = 2;

color_ref        = 'k';  % Reference and passive

%% --- Load simulation data ---

for i = 1:length(filenames)
    try
        load(filenames{i})
        x_b_ddot{i}                 = BUS.Accelerations.x_b_ddot.Data;
        delta_theta_dot_front{i}    = BUS.States.omega_F_L.Data - BUS.Differentials.theta_s_dot_F_L.Data;
        delta_theta_dot_rear{i}     = BUS.States.omega_R_L.Data - BUS.Differentials.theta_s_dot_R_L.Data;
        slip_front{i}               = BUS.States.slip_F_L.Data;
        slip_rear{i}                = BUS.States.slip_R_L.Data;
        x_b{i}                      = BUS.States.x_b.Data;
        slip_ref_front{i}           = slip_ref_front_sim.Data;
        slip_ref_rear{i}            = slip_ref_rear_sim.Data;
        a_b_ref{i}                  = a_b_ref_sim.Data;
        road_profile_front{i}       = roadprofile_front_plot.Data*1e-3;
        road_profile_rear{i}        = roadprofile_rear_plot.Data*1e-3;
        mu_front{i}                 = mu_front_sim.Data;
        mu_rear{i}                  = mu_rear_sim.Data;
        Tm_fr{i}                    = BUS.Traction_forces.Tm_F_R.Data;
        Tm_rr{i}                    = BUS.Traction_forces.Tm_R_R.Data;
        cost_fcn_weights_FL         = squeeze(cost_fcn_weights_FL.Data);
        cost_fcn_weights_RL         = squeeze(cost_fcn_weights_RL.Data);
        Q1_F{i}                     = cost_fcn_weights_FL(1,:);
        Q2_F{i}                     = cost_fcn_weights_FL(2,:);
        R1_F{i}                     = cost_fcn_weights_FL(3,:);
        Q1_R{i}                     = cost_fcn_weights_RL(1,:);
        Q2_R{i}                     = cost_fcn_weights_RL(2,:);
        R1_R{i}                     = cost_fcn_weights_RL(3,:);
    catch
        fprintf('File "%s" not found.\n',filenames{i});
    end
end

%% --- Create figure 1 ---

fig = figure(1);
set(gcf, 'color', [1 1 1], 'units', 'centimeter', 'position', [8, 2, 9.8, 16])

for i = 1:length(filenames)
    try
        % 1 - Road profile
        if i == 1
            subplot(5,2,[1 2])
            set(gca,'FontSize', fontsize_axis)
            yyaxis left
            set(gca, 'ycolor', 'k')
            plot(x_b{i}, road_profile_front{i}, 'Color', color_ref, 'LineWidth', line_width); hold on;
            plot(x_b{i}, road_profile_rear{i}, 'Color', color_ref, 'LineStyle','-.','LineWidth', line_width);
            ylabel('$z_{\mathrm{r}}\,[\mathrm{m}]$', 'interpreter', 'latex', 'FontSize', fontsize_labels)
            ylim([min(road_profile_front{i})-1e-3, max(road_profile_front{i})+1e-3]);
            
            yyaxis right
            set(gca, 'ycolor', 'r')
            plot(x_b{i}, mu_front{i}, 'Color', 'r','LineWidth', line_width);
            plot(x_b{i}, mu_rear{i}, 'Color', 'r', 'LineStyle','-.','LineWidth', line_width);
            ylabel('$\mu\,[-]$', 'interpreter', 'latex', 'FontSize', fontsize_labels)
            ylim([min([mu_front{i}; mu_rear{i}])-0.1, max([mu_front{i}; mu_rear{i}])+0.1]);
            legend('$\mathrm{Front}$', '$\mathrm{Rear}$', 'interpreter', 'latex', 'FontSize', fontsize_legend, 'Location', 'NorthEast');
            xlim([xlim_min, xlim_max])
            grid on; box on;
        end
        
        % 2 - x_b_ddot
        subplot(5,2,[3 4])
        hold on;
        if i == 1
            h1(1) = plot(x_b{i}, a_b_ref{i}, '--', 'Color', color_ref, 'LineWidth', line_width, 'DisplayName', 'Reference');
        end
        h1(i+1) = plot(x_b{i}, x_b_ddot{i}, 'Color', colors{i}, 'LineWidth', line_width, 'DisplayName', legends{i});
        set(gca,'FontSize', fontsize_axis)
        ylabel('$\ddot{x_b}\,[\mathrm{m/s^2}]$', 'interpreter', 'latex', 'FontSize', fontsize_labels)
        xlabel('$x_b\,[\mathrm{m}]$', 'interpreter', 'latex', 'FontSize', fontsize_labels)
        xlim([xlim_min, xlim_max])
        grid on; box on;
        legend(h1, 'Interpreter', 'latex', 'FontSize', fontsize_legend, 'Orientation', 'horizontal', ...
            'NumColumns', 3, 'Position', [0.52 0.97 0 0])
        
        % 3 - Delta theta dot front
        subplot(5,2,5)
        hold on;
        if i == 1
            plot(x_b{i}, zeros(length(x_b{i}),1), '--', 'Color', color_ref, 'LineWidth', line_width);
        end
        plot(x_b{i}, delta_theta_dot_front{i}, 'Color', colors{i}, 'LineWidth', line_width);
        set(gca,'FontSize', fontsize_axis)
        ylabel('$\\{\Delta}{\dot{\theta}}_{fr}\,[1/s]$', 'interpreter', 'latex', 'FontSize', fontsize_labels)
        xlim([xlim_min, xlim_max]);
        grid on; box on;
        
        % 4 - Delta theta dot rear
        subplot(5,2,6)
        hold on;
        if i == 1
            plot(x_b{i}, zeros(length(x_b{i}),1), '--', 'Color', color_ref, 'LineWidth', line_width);
        end
        plot(x_b{i}, delta_theta_dot_rear{i}, 'Color', colors{i}, 'LineWidth', line_width);
        set(gca,'FontSize', fontsize_axis)
        ylabel('$\\{\Delta}{\dot{\theta}}_{rr}\,[1/s]$', 'interpreter', 'latex', 'FontSize', fontsize_labels)
        xlim([xlim_min, xlim_max]);
        grid on; box on;
        
        % 5 - Slip front
        subplot(5,2,7)
        hold on;
        if i == 1
            plot(x_b{i}, slip_ref_front{i}, '--', 'Color', color_ref, 'LineWidth', line_width);
        end
        plot(x_b{i}, slip_front{i}, 'Color', colors{i}, 'LineWidth', line_width);
        set(gca,'FontSize', fontsize_axis)
        ylabel('$\sigma_{fr}\,[-]$', 'interpreter', 'latex', 'FontSize', fontsize_labels)
        xlim([xlim_min, xlim_max]);
        ylim([-0.1, 0.3]);
        grid on; box on;
    
        % 6 - Slip rear
        subplot(5,2,8)
        hold on;
        if i == 1
            plot(x_b{i}, slip_ref_rear{i}, '--', 'Color', color_ref, 'LineWidth', line_width);
        end
        plot(x_b{i}, slip_rear{i}, 'Color', colors{i}, 'LineWidth', line_width);
        set(gca,'FontSize', fontsize_axis)
        ylabel('$\sigma_{rr}\,[-]$', 'interpreter', 'latex', 'FontSize', fontsize_labels)
        xlim([xlim_min, xlim_max]);
        ylim([-0.1, 0.3]);
        grid on; box on;
    
        % 7 - Front left motor torque
        subplot(5,2,9)
        hold on;
        plot(x_b{i}, Tm_fr{i}, 'Color', colors{i}, 'LineWidth', line_width);
        set(gca,'FontSize', fontsize_axis)
        ylabel('$T_{m,fr}\,[Nm]$', 'interpreter', 'latex', 'FontSize', fontsize_labels)
        xlabel('$x_b\,[\mathrm{m}]$', 'interpreter', 'latex', 'FontSize', fontsize_labels)
        xlim([xlim_min, xlim_max]);
        grid on; box on;
    
        % 8 - Rear left motor torque
        subplot(5,2,10)
        hold on;
        plot(x_b{i}, Tm_rr{i}, 'Color', colors{i}, 'LineWidth', line_width);
        set(gca,'FontSize', fontsize_axis)
        ylabel('$T_{m,rr}\,[Nm]$', 'interpreter', 'latex', 'FontSize', fontsize_labels)
        xlabel('$x_b\,[\mathrm{m}]$', 'interpreter', 'latex', 'FontSize', fontsize_labels)
        xlim([xlim_min, xlim_max]);
        grid on; box on;
    end
end
% --- Export ---
set(gcf, 'Renderer', 'painters');
print(gcf, figname, '-dsvg');

%% --- Create Figure 2 ---

fig = figure(2);
set(gcf, 'color', [1 1 1], 'units', 'centimeter', 'position', [8, 2, 9.8, 16])

for i = 2:length(filenames)
    try
        %Q1
        subplot(3,1,1)
        if i == 2
            h2(1) = semilogy(x_b{i}, Q1_F{i}, 'Color', colors{i}, 'LineWidth', line_width, 'DisplayName', 'Front');
            hold on;
            h2(2) = semilogy(x_b{i}, Q1_R{i}, 'Color', colors{i}, 'linestyle', '--', 'LineWidth', line_width, 'DisplayName', 'Rear');
            hold on;
            legend(h2, 'interpreter', 'latex', 'FontSize', fontsize_legend, 'Location', 'Northeast');
        else
            p = semilogy(x_b{i}, Q1_F{i}, 'Color', colors{i}, 'LineWidth', line_width);
            p.Annotation.LegendInformation.IconDisplayStyle = 'off';
            hold on;
            p = semilogy(x_b{i}, Q1_R{i}, 'Color', colors{i}, 'linestyle', '--', 'LineWidth', line_width);
            p.Annotation.LegendInformation.IconDisplayStyle = 'off';
            hold on;
        end
        box on; grid on;
        set(gca,'FontSize', fontsize_axis)
        ylabel('$\\Q_{1}\ \mathrm{[s^2/m]}$', 'interpreter', 'latex', 'FontSize', fontsize_labels)
        xlim([xlim_min,xlim_max]);
        
        %Q2
        subplot(3,1,2)
        h3(i-1) = semilogy(x_b{i}, Q2_F{i}, 'Color', colors{i}, 'LineWidth', line_width, 'DisplayName', legends{i});
        hold on;
        p = semilogy(x_b{i}, Q2_R{i}, 'Color', colors{i}, 'linestyle', '--', 'LineWidth', line_width);
        p.Annotation.LegendInformation.IconDisplayStyle = 'off';
        hold on;
        box on; grid on;
        set(gca,'FontSize', fontsize_axis)
        ylabel('$\\Q_{2}\ \mathrm{[s]}$', 'interpreter', 'latex', 'FontSize', fontsize_labels)
        xlim([xlim_min,xlim_max]);
        
        %R1
        subplot(3,1,3)
        semilogy(x_b{i}, R1_F{i}, 'Color', colors{i}, 'LineWidth', line_width);
        hold on;
        semilogy(x_b{i}, R1_R{i}, 'Color', colors{i}, 'linestyle', '--', 'LineWidth', line_width);
        hold on;
        box on; grid on;
        set(gca,'FontSize', fontsize_axis)
        ylabel('$\\R_{1}\ \mathrm{[-]}$', 'interpreter', 'latex', 'FontSize', fontsize_labels)
        xlabel('$\\x_{b}\ \mathrm{[m]}$', 'interpreter', 'latex', 'FontSize', fontsize_labels)
        xlim([xlim_min,xlim_max]);
        legend(h3, 'interpreter', 'latex', 'FontSize', fontsize_legend, 'NumColumns', 3, 'position',[0.52 0.97 0 0.02])
    end
end
% --- Export ---
set(gcf, 'Renderer', 'painters');
print(gcf, strcat(figname,'_fcn_weights'), '-dsvg');