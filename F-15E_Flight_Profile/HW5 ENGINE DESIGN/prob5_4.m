format long; clc; clear; close all;

W = 366918; %lbf
S = 4600;
Mach = 2;
units = "EN";
ABswitch = "ON";

[~, V, Q, ~] = flight_condition(0, "", 2);
CL = W * 4.448 / (Q * S * 0.3048^2);
CD = 0.91185/100;
D = Q * S * 0.3048^2 * CD * 0.224809;

%% CONSTANTS

[~, propS.ToR, propS.PoR, ~] = atm_model(0);
propS.mdot_oR = 1.15e+03;
propS.h_pr = 18400;
propS.Cp = .24;
propS.gamma = 1.4;
propS.pi_cR = 8;
propS.To4R = 2600;
propS.To7 = 3000;
propS.tau_cR = (propS.pi_cR) ^ ((propS.gamma-1)/propS.gamma);

propS.tau_rR = 1 + 0.5 * (propS.gamma - 1) * Mach^2;
propS.pi_rR = propS.tau_rR & (propS.gamma/(propS.gamma-1));
propS.To2R = propS.ToR * propS.tau_rR;
propS.pi_dR = 0.9 * (1 - 0.075 * (Mach - 1) ^ 1.35);

% FUNCTION

POWER = 1;

[~, F, SFC, ~, ~, ~, ~] = ...
    compute_offdesign_ideal_AB_TJ_performance(Mach, 0, POWER, units, ABswitch, propS);

fprintf("Drag = %.2f\nThrust = %.2f\nPOWER = %.2f\n", D, F, POWER)