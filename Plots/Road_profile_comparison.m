clear all; close all; clc;

addpath('..\Road_profiles\mat_files\')

load("A_road_train")
load("B_road_train1")
load("C_road_train")

%% FIGURE 

Fontsize_axis   = 32;
Fontsize_labels = 48;
Fontsize_legend = 40;
line_width      = 2;

figure

xlim_min = 0;
xlim_max = 45;
ylim_min = -0.04;
ylim_max = 0.06;
ylim_min = -Inf;
ylim_max = Inf;

subplot(3,1,1)
set(gca,'FontSize', Fontsize_axis)
grid on; box on; hold on;
h1(1) = plot(A_road_train.distance, A_road_train.height, 'Color', 'r', 'LineWidth', line_width, 'DisplayName', 'A-class');
ylabel('$z_{r}\ \mathrm{[m]}$', 'interpreter', 'latex', 'FontSize', Fontsize_labels)
xlim([xlim_min,xlim_max]);
ylim([ylim_min,ylim_max]);

subplot(3,1,2)
set(gca,'FontSize', Fontsize_axis)
grid on; box on; hold on;
h1(2) = plot(B_road_train1.distance, B_road_train1.height, 'Color', 'g', 'LineWidth', line_width, 'DisplayName', 'B-class');
ylabel('$z_{r}\ \mathrm{[m]}$', 'interpreter', 'latex', 'FontSize', Fontsize_labels)
xlim([xlim_min,xlim_max]);
ylim([ylim_min,ylim_max]);

subplot(3,1,3)
set(gca,'FontSize', Fontsize_axis)
grid on; box on; hold on;
h1(3) = plot(C_road_train.distance, C_road_train.height, 'Color', 'b', 'LineWidth', line_width, 'DisplayName', 'C-class');
ylabel('$z_{r}\ \mathrm{[m]}$', 'interpreter', 'latex', 'FontSize', Fontsize_labels)
xlabel('$\\x_{b}\ \mathrm{[m]}$', 'interpreter', 'latex', 'FontSize', Fontsize_labels)
xlim([xlim_min,xlim_max]);
ylim([ylim_min,ylim_max]);
legend(h1, 'interpreter', 'latex', 'FontSize', Fontsize_legend, 'NumColumns', 3, 'position',[0.5 0.964 0 0])
