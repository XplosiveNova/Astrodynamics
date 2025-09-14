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

[G, trajS, propS] = climb_constants();

climbOut = simulate_constant_EAS_constant_throttle_climb(trajS, propS, G);

%% PLOTS
% figure(1)
% plot_trajectory_variable(x, h, "Range", "Altitude", [0 1000], [35, 50], "", "")
% figure(2)
% plot_trajectory_variable(MachV, h, "Mach Number", "Altitude", "", "", "", "")
% figure(3)
% plot_trajectory_variable(t, h, "Time", "Altitude", "", "", "", "")
% figure(4)
% plot_trajectory_variable(t, LODV, "Time", "L/D", "", "", "", "")
% figure(5)
% plot_trajectory_variable(x, W, "Range", "Weight", "", "", "", "")
% figure(6)
% plot_trajectory_variable(t, fpaV, "Time", "Flight Path Angle", "", "", "", "")
% figure(7)
% plot_trajectory_variable(t, POWERV, "Time", "Power", "", "", "", "")
% figure(8)
% plot_trajectory_variable(t, SV, "Time", "SFC", "", "", "", "")
% figure(9)
% plot_trajectory_variable(t, Treq_totV, "Time", "Treq", "", "", "")
% % hold on
% % plot_trajectory_variable(t, TcurV, "", "", "", "", "")
% % hold on
% % plot_trajectory_variable(t, TavaV, "", "", "", "", "")
% figure(10)
% plot_trajectory_variable(t, aV, "Time", "Axial Acceleration", "", "", "", "")
% figure(11)
% plot_trajectory_variable(t, AOAV, "Time", "Angle of Attack", "", "", "", "")
% figure(12)
% plot_trajectory_variable(t, LV, "Time", "Lift", "", "", "", "")
% figure(13)
% plot_trajectory_variable(t, DV, "Time", "Drag", "", "", "", "")
% figure(14)
% plot_trajectory_variable(t, QV, "Time", "Dynamic Pressure", "", "", "", "")

