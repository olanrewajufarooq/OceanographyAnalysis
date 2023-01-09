clear; clc; close all

current_data = load('Data/Tbay_current_Wind_data.mat');

longs = [5.9535; 6.0003; 5.9852; 5.9702];
lats = [43.0932; 43.0799; 43.0800; 43.0801];

% Give Time in Format: 'yyyy-MM-dd HH:mm:ss.SSS from 12-Oct-2021 00:00:00 to 14-Oct-2021 23:00:00'

deploy_times = ["2021-10-12 08:31:00", "2021-10-12 09:13:00", "2021-10-12 09:07:00", "2021-10-12 08:59:00"];
recov_times = ["2021-10-12 12:36:00", "2021-10-12 12:01:00", "2021-10-12 12:42:00", "2021-10-12 11:41:00"];

depth = 1.0;

pause_duration = 0.05; % in seconds

drifters = plot_multi_drifters(longs, lats, deploy_times, recov_times, depth, current_data, pause_duration);