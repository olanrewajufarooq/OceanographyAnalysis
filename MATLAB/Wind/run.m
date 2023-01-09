clear; clc; close all

wind_data = load('Data/AROME_2022_Oct.mat');

path = "../../Python/CleanDriftersData/Day2/";
drifter_data = read_drifter_data(path);

considered_drifters = ["2052", "0119", "274"];

pause_duration = 0.05; % in seconds

drifters = plot_wind_effect(drifter_data, considered_drifters, wind_data, pause_duration);