clear all; close all; clc;

addpath('friction_crg_files\')

%% crg generate

test_matrix = [
    1 330 0.1 10 10
    2 350 0.2 11 11
    3 350 0.25 12 12
    4 340 0.2 8 8
    5 320 0.15 10 6
    6 350 0.1 12 8
    7 350 0.2 9 9
    8 350 0.1 10 10
    9 350 0.15 12 14
    10 350 0.1 11 11
    1 340 0.2 10 9
    2 320 0.15 9 9
    3 340 0.2 11 10
    4 350 0.25 8 12
    5 330 0.2 8 6
    6 330 0.1 8 10
    7 350 0.25 10 10
    8 350 0.2 12 9
    9 350 0.1 14 8
    10 350 0.15 8 13
    1 350 0.1 8 8
    2 330 0.1 13 13
    3 340 0.2 9 9
    4 340 0.1 10 8
    5 340 0.1 8 6
    6 330 0.1 10 7
    7 340 0.2 11 9
    8 350 0.1 11 11
    9 350 0.1 15 14
    10 350 0.2 17 17
    1 350 0.1 8 8
    2 340 0.15 12 11
    3 350 0.2 13 13
    4 350 0.1 7 5
    5 350 0.25 10 8
    6 330 0.15 9 7
    7 330 0.1 11 13
    8 350 0.2 14 10
    9 350 0.1 10 8
    10 350 0.2 11 9];

%%
for i=1:40
mu_mag=test_matrix(i,3); 
d_mu=test_matrix(i,5);

filename = sprintf('handmade_fric_test%d.crg', i);
copyfile('template.crg', filename);

test_distance   = 0:0.01:30;
mu_road         = [ones(1,100*d_mu) mu_mag*ones(1,length(test_distance)-100*d_mu)]';
road_matrix     = [mu_road mu_road mu_road mu_road mu_road mu_road mu_road];
road_matrix     = round(road_matrix,4);

%% read lines from the new file
lines = readlines(filename);

%modify specific lines

    if contains(lines(81), '$$$$$$$$10$$$$$$$$20$$$$$$$$30$$$$$$$$40$$$$$$$$50$$$$$$$$60$$$$$$$$70$$$$$$$$80 [matrix]')
        lines(81) = "$$$$$$$$10$$$$$$$$20$$$$$$$$30$$$$$$$$40$$$$$$$$50$$$$$$$$60$$$$$$$$70$$$$$$$$80 " + strjoin(compose("%.4f", road_matrix(1,:)), '    ');
    end
    for j=82:(length(road_matrix(:,1))-1)
        lines(j) = "    " + strjoin(compose("%.4f", road_matrix(j - 80,:)), '    ');
    end

%% write the modified lines back
writelines(lines, filename);
end