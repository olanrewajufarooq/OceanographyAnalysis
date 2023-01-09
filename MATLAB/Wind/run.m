clear; clc; close all

wind_data = load('Data/AROME_2022_Oct.mat');

path = "../../Python/CleanDriftersData/Day1/";
drifter_data = read_drifter_data(path);

pause_duration = 0.05; % in seconds

drifters = plot_multi_drifters(drifter_data, wind_data, pause_duration);