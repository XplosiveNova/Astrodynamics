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
plot(cruiseOut.xV, cruiseOut.hV)
figure(2)
plot(cruiseOut.MachV, cruiseOut.hV)
figure(3)
plot(cruiseOut.tV, cruiseOut.hV)
figure(4)
plot(cruiseOut.tV, cruiseOut.xV)
figure(5)
plot(cruiseOut.xV, cruiseOut.WV)
figure(6)
plot(cruiseOut.tV, cruiseOut.fpaV)

figure(7)
plot_trajectory_variable(cruiseOut.tV, cruiseOut.POWERV, "Time", "Power", "", "", "", "")
figure(8)
plot_trajectory_variable(cruiseOut.tV, cruiseOut.SV, "Time", "SFC", "", "", "", "")
figure(9)
plot_trajectory_variable(cruiseOut.tV, cruiseOut.tVreq_engV, "Time", "Treq", "", "", "")
figure(10)
plot_trajectory_variable(cruiseOut.tV, cruiseOut.TV, "Time", "Thrust CUrrent", "", "", "", "")
figure(11)
plot_trajectory_variable(cruiseOut.tV, cruiseOut.Treq_totV, "Time", "Ttot", "", "", "", "")