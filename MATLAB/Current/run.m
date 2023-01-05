clear; clc; close all

current_data = load('Data/Tbay_current_Wind_data.mat');

%{
depth = "Surface"; % Values: 1m Depth, 60cm Depth, Surface.

long = 6.00;
lat = 43.05;

[LONG, LAT] = plot_trajectory(long, lat, depth, current_data);
%}

longs = [6.0; 5.960; 6.068; 5.9;];
lats = [43.05; 43.059; 43.071; 43.058];
depth = "Surface";

drifters = plot_multi_drifters(longs, lats, depth, current_data);