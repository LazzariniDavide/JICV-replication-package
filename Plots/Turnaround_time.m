clear all; close all; clc;

warning('off')

rmpath(genpath('../Results/'))

addpath('..\Results\Fig14_sim_data\')

%% --- Figure settings ---

Fontsize_axis   = 24;
Fontsize_labels = 28;
Fontsize_legend = 28;
line_width      = 2;
markersize      = 10;
xlim_min        = 0;
xlim_max        = 3;

figname_a       = 'Fig14a_real_time_KPIs';
figname_b       = 'Fig14b_real_time_KPIs2';

% Markers
marker_type = {'dk', 'ob', 'xb', 'db', 'or', 'xr', 'dr', 'og', 'xg', 'dg'};

%% --- Data ---

filenames   = {'Fig10_step_passive','Fig10_step_NMPCin', ...
    'Fig14_step_NMPCin2_N1','Fig14_step_NMPCin2_N2','Fig14_step_NMPCin2_N3', ...
    'Fig14_step_NMPCin3_N1','Fig14_step_NMPCin3_N2','Fig14_step_NMPCin3_N3', ...
    'Fig14_step_NMPCin4_N1','Fig14_step_NMPCin4_N2','Fig14_step_NMPCin4_N3'};

% Turnaround time
t_ta        = [0.0123, ...
    0.0017 0.0034 0.0052, ...
    0.0031 0.0062 0.0092, ...
    0.0038 0.0075 0.0115];

% Control action sampling time
t_s         = [0.005, ...
    0.005 0.005 0.005, ...
    0.005 0.005 0.005, ...
    0.010 0.010 0.010];

% Real time factor (<1 --> real time)
lf          = t_ta ./ t_s;

%% --- Load KPIs ---

for i = 1:length(filenames)
    try
        load(filenames{i})
        x_b_ddot_rms(i) = KPIs.RMSE_x_b_ddot;
        x_b_ddot_vdv(i) = KPIs.VDV_x_b_ddot;
        delta_w_max(i)  = KPIs.max_delta_omega;
        slip_rms(i)     = KPIs.RMS_slip_viol_F;
        slip_max(i)     = KPIs.slip_viol_max;
    catch
        fprintf('File "%s" not found.\n',filenames{i});
    end
end

%% --- Percentage improvement w.r.t. first file ---

for i = 2:length(filenames)
    try
        pi_xbrms(i-1)   = (1-(x_b_ddot_rms(i)/x_b_ddot_rms(1)))*100;
        pi_xbvdv(i-1)   = (1-(x_b_ddot_vdv(i)/x_b_ddot_vdv(1)))*100;
        pi_dw(i-1)      = (1-(delta_w_max(i)/delta_w_max(1)))*100;
        pi_sliprms(i-1) = (1-(slip_rms(i)/slip_rms(1)))*100;
        pi_slipmax(i-1)   = (1-(slip_max(i)/slip_max(1)))*100;
    catch
        fprintf('File "%s" not found.\n',filenames{i});
    end
end

%% --- Create figure a ---

fig = figure(1);
set(gcf,'Position',[0 0 1000 800])

for i = 2:length(filenames)
    try
        subplot(1,2,1)
        set(gca,'FontSize', Fontsize_axis)
        grid on; box on; hold on;
        p = xline(1,'LineWidth',line_width);
        p.Annotation.LegendInformation.IconDisplayStyle = 'off';
        p = plot(lf(i-1), pi_xbrms(i-1), marker_type{i-1},'MarkerSize', markersize,'LineWidth',line_width);
        p.Annotation.LegendInformation.IconDisplayStyle = 'off';
        if i == 2
            h1(1) = plot(-5, -5, 'ok','MarkerSize', markersize,'LineWidth',line_width, 'DisplayName', '$\mathrm{1\ iter}$');
            h1(2) = plot(-5, -5, 'xk','MarkerSize', markersize,'LineWidth',line_width, 'DisplayName', '$\mathrm{2\ iter}$');
            h1(3) = plot(-5, -5, 'dk','MarkerSize', markersize,'LineWidth',line_width, 'DisplayName', '$\mathrm{3\ iter}$');
        legend(h1, 'interpreter', 'latex', 'FontSize', 15, 'location','southeast')
        end
        ylabel('$I\ddot{x}_{b,\mathrm{RMSE}}\ [\%]$', 'interpreter', 'latex', 'FontSize', Fontsize_labels)
        xlabel('$t_{ta}/t_c\ \mathrm{[-]}$', 'interpreter', 'latex', 'FontSize', Fontsize_labels)
        xlim([xlim_min,xlim_max]);
        ylim([min(pi_xbrms)-1,min(100,max(pi_xbrms)+1)]);

        subplot(1,2,2)
        set(gca,'FontSize', Fontsize_axis)
        grid on; box on; hold on;
        p = xline(1,'LineWidth',line_width);
        p.Annotation.LegendInformation.IconDisplayStyle = 'off';
        p = plot(lf(i-1), pi_xbvdv(i-1), marker_type{i-1},'MarkerSize', markersize,'LineWidth',line_width);
        p.Annotation.LegendInformation.IconDisplayStyle = 'off';
        if i == 2
            h2(1) = plot(zeros(1,2), zeros(1,2), 'k','LineWidth',line_width,'DisplayName','$\mathrm{NMPC_{in}}$');
            h2(2) = plot(zeros(1,2), zeros(1,2), 'b','LineWidth',line_width,'DisplayName','$\mathrm{NMPC_{in,2}}$');
            h2(3) = plot(zeros(1,2), zeros(1,2), 'r','LineWidth',line_width,'DisplayName','$\mathrm{NMPC_{in,3}}$');
            h2(4) = plot(zeros(1,2), zeros(1,2), 'g','LineWidth',line_width,'DisplayName','$\mathrm{NMPC_{in,4}}$');
        legend(h2, 'interpreter', 'latex', 'FontSize', Fontsize_legend, 'NumColumns', 4, 'position',[0.5 0.965 0 0])
        end
        ylabel('$I\Delta \ddot{x}_{\mathrm{VDV}}\ [\%]$', 'interpreter', 'latex', 'FontSize', Fontsize_labels)
        xlabel('$t_{ta}/t_c\ \mathrm{[-]}$', 'interpreter', 'latex', 'FontSize', Fontsize_labels)
        xlim([xlim_min,xlim_max]);
        ylim([min(pi_xbvdv)-1,min(100,max(pi_xbvdv)+1)]);
    end
end 

% --- Export ---
set(gcf, 'Renderer', 'painters');
print(gcf, figname_a, '-dsvg');

%% --- Create figure b ---

fig = figure(2);
set(gcf,'Position',[0 0 1800 800])

for i = 2:length(filenames)
    try
        subplot(1,3,1)
        set(gca,'FontSize', Fontsize_axis)
        grid on; box on; hold on;
        xline(1,'LineWidth',line_width);
        plot(lf(i-1), pi_dw(i-1), marker_type{i-1},'MarkerSize', markersize,'LineWidth',line_width);
        ylabel('$I\Delta \dot{\theta}_{\mathrm{max}}\ [\%]$', 'interpreter', 'latex', 'FontSize', Fontsize_labels)
        xlabel('$t_{ta}/t_c\ \mathrm{[-]}$', 'interpreter', 'latex', 'FontSize', Fontsize_labels)
        xlim([xlim_min,xlim_max]);
        ylim([min(pi_dw)-1,min(100,max(pi_dw)+1)]);

        subplot(1,3,2)
        set(gca,'FontSize', Fontsize_axis)
        grid on; box on; hold on;
        xline(1,'LineWidth',line_width);
        plot(lf(i-1), pi_sliprms(i-1), marker_type{i-1},'MarkerSize', markersize,'LineWidth',line_width);
        ylabel('$I\sigma_{v,\mathrm{RMS},f}\ [\%]$', 'interpreter', 'latex', 'FontSize', Fontsize_labels)
        xlabel('$t_{ta}/t_c\ \mathrm{[-]}$', 'interpreter', 'latex', 'FontSize', Fontsize_labels)
        xlim([xlim_min,xlim_max]);
        ylim([min(pi_sliprms)-1,min(100,max(pi_sliprms)+1)]);

        subplot(1,3,3)
        set(gca,'FontSize', Fontsize_axis)
        grid on; box on; hold on;
        xline(1,'LineWidth',line_width);
        plot(lf(i-1), pi_slipmax(i-1), marker_type{i-1},'MarkerSize', markersize,'LineWidth',line_width);
        ylabel('$I\sigma_{v,\mathrm{max}}\ [\%]$', 'interpreter', 'latex', 'FontSize', Fontsize_labels)
        xlabel('$t_{ta}/t_c\ \mathrm{[-]}$', 'interpreter', 'latex', 'FontSize', Fontsize_labels)
        xlim([xlim_min,xlim_max]);
        ylim([min(pi_slipmax)-1,min(100,max(pi_slipmax)+1)]);
    end
end 

% --- Export ---
set(gcf, 'Renderer', 'painters');
print(gcf, figname_b, '-dsvg');