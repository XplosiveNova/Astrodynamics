format long; close all; clc; clear;

currentFolder = fileparts(mfilename('fullpath'));
HW1Path = fullfile(currentFolder, '..', 'HW1 ATM MODEL');
addpath(HW1Path);
HW3Path = fullfile(currentFolder, '..', 'HW3 CL FUNCTIONS');
addpath(HW3Path);
HW4Path = fullfile(currentFolder, '..', 'HW4 F15 PERFORMANCE');
addpath(HW4Path);
HW5Path = fullfile(currentFolder, '..', 'HW5 ENGINE DESIGN');
addpath(HW5Path);

[G, trajS, propS] = cruise_constants();

[cruiseOut] = simulate_constant_velocity_constant_CL_cruise_climb(trajS, propS, G);

figure(1)
plot(cruiseOut.xV / 1000, cruiseOut.hV / 1000, 'k')
title('Cruise-Climb Trajectory Profile', 'FontSize', 20, 'FontName', 'Arial')
xlabel('Range (kft)', 'FontSize', 16, 'FontName', 'Arial', 'FontWeight', 'bold')
ylabel("Altitude (kft)", 'FontSize', 16, 'FontName', 'Arial', 'FontWeight', 'bold')
theme 'light'
