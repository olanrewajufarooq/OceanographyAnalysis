clear; clc; close all

wind_data = load('Data/AROME_2022_Oct.mat');

path = "../../Python/CleanDriftersData/Day2/";
drifter_data = read_drifter_data(path);

% The surface Drifters for Day 2
considered_drifters = ["8436", "0119", "2052"];

pause_duration = 0.3; % in seconds

drifters = plot_wind_effect(drifter_data, considered_drifters, wind_data, pause_duration);