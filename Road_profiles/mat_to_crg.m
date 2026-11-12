% From .MAT to .crg 
%clear all; clc;

        Step_selector=3;
        test_distance   = 0:0.01:30;
        z_road=[ones(1,1001), 0.1*ones(1,2000)]';

%%road matrix
road_matrix=[z_road z_road z_road z_road z_road z_road z_road];
road_matrix=round(road_matrix,4)
length(z_road)
test_distance(end)