clear; clc; close all

current_data = load('Data/Tbay_current_Wind_data.mat');

longs = [6.1; 5.960; 6.068; 5.9;];
lats = [43.05; 43.059; 43.071; 43.05];

% Give Time in Format: 'yyyy-MM-dd HH:mm:ss.SSS from 12-Oct-2021 00:00:00 to 14-Oct-2021 23:00:00'

deploy_times = ["2021-10-12 10:00:00", "2021-10-12 11:30:00", "2021-10-13 11:00:00", "2021-10-13 15:00:00"];
recov_times = ["2021-10-13 18:00:00", "2021-10-13 20:00:00", "2021-10-14 00:00:00", "2021-10-14 00:03:00"];

depth = 1.0;

drifters = plot_multi_drifters(longs, lats, deploy_times, recov_times, depth, current_data);