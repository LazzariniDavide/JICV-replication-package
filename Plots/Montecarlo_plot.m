clear all; close all; clc;

addpath("../Results/Fig13_sim_data/")

% figname         = 'Fig13_monteCarlo_NMPCcm';
% filenames       = {'Fig13_speedBump_passive','Fig13_speedBump_NMPCcm'};
% deleted_data    = [];
% ref             = [19.95, 14.30];
% legends         = {'NMPC$_\mathrm{cm}$'};
% colors          = {[0.41 0.91 0.05]};
% marker          = {'o'};

% figname         = 'Fig13_monteCarlo_NMPCtc';
% filenames       = {'Fig13_speedBump_passive','Fig13_speedBump_NMPCtc'};
% deleted_data    = [62 107 214 220 234 244 270 277 299 340 352 377 470 500];
% ref             = [-106.18, 98.16];
% legends         = {'NMPC$_\mathrm{tc}$'};
% colors          = {'c'};
% marker          = {'o'};

% figname         = 'Fig13_monteCarlo_NMPCin';
% filenames       = {'Fig13_speedBump_passive','Fig13_speedBump_NMPCin'};
% deleted_data    = [21 96 102 375 401];
% ref             = [39.35, 97.51];
% legends         = {'NMPC$_\mathrm{in}$'};
% colors          = {'b'};
% marker          = {'o'};

figname         = 'Fig13_monteCarlo';
filenames       = {'Fig13_speedBump_passive','Fig13_speedBump_NMPCcm','Fig13_speedBump_NMPCtc','Fig13_speedBump_NMPCin'};
deleted_data    = [];
ref             = [19.95, 14.30; -106.18, 98.16; 39.35, 97.51];
legends         = {'NMPC$_\mathrm{cm}$','NMPC$_\mathrm{tc}$','NMPC$_\mathrm{in}$'};
colors          = {[0.41 0.91 0.05],'C','b'};
marker          = {'o','d','s'};

%% --- Styling Parameters ---
fontsize_axis   = 18;
fontsize_labels = 24;
fontsize_legend = 24;
            
%% --- Load simulation data ---

for i = 1:length(filenames)
    try
        load(filenames{i})
        KPIs_all{i} = KPIs;
        if i > 1
            KPIs_improvement{i-1} = (1 - KPIs_all{i}./KPIs_all{1})*100;
            negative_improvement_idx{i-1} = find(KPIs_improvement{i-1}(:,1) < 0);
            deleted_data_idx{i-1} = find(KPIs_improvement{i-1}(:,5) < 80);
            KPIs_improvement{i-1}(deleted_data,:) = [];
        end
    catch
        fprintf('File "%s" not found.\n',filenames{i});
    end
end

%% FIGURE

figure;

set(gcf,'Units','centimeters','Position',[1 1 30 30])
set(gca,'FontSize', fontsize_axis)
grid on; box on; hold on;

for i = 1:length(filenames)-1
    try
        h1(i) = plot(KPIs_improvement{i}(:,1), KPIs_improvement{i}(:,5), 'Color', colors{i}, 'LineStyle', 'none', 'Marker', marker{i},'MarkerSize',8,'MarkerFaceColor', colors{i}, 'DisplayName', legends{i});
    end
end
for i = 1:length(filenames)-1
    try
        plot(ref(i,1),ref(i,2),'Color','r','LineStyle','none','Marker',marker{i},'MarkerSize', 8,'MarkerFaceColor','r');
    end
end
xlabel('$I\ddot{x}_{b,\mathrm{RMSE}}\ [\%]$', 'interpreter', 'latex', 'fontname', 'Times New Roman', 'FontSize', fontsize_labels)
ylabel('$I\sigma_{v,\mathrm{max}}\ [\%]$', 'interpreter', 'latex', 'fontname', 'Times New Roman', 'FontSize', fontsize_labels)
legend(h1,'interpreter', 'latex', 'fontname', 'Times New Roman', 'FontSize', fontsize_legend, 'NumColumns', 3, 'position',[0.5 0.965 0 0])

% --- Export ---
set(gcf, 'Renderer', 'painters');
print(gcf, figname, '-dsvg');

cd('..\Results\Fig13_sim_data')
save('negative_improvement_idx','negative_improvement_idx');
cd('..\..\Plots')