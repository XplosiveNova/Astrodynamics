format long; clc; clear; close all;

currentFolder = fileparts(mfilename('fullpath'));
HW1Path = fullfile(currentFolder, '..', 'HW1 ATM MODEL');
addpath(HW1Path);
HW3Path = fullfile(currentFolder, '..', 'HW3 CL FUNCTIONS');
addpath(HW3Path);
HW4Path = fullfile(currentFolder, '..', 'HW4 F15 PERFORMANCE');
addpath(HW4Path);

Mach = 2;
alt = 50000;
h_pr = 18400;
Cp = .24;
gamma = 1.4;
mdot_o = 44.093;

W = 366918; %lbf
G.S = 4600;
To7 = 3000;
units = "EN";
ABswitch = "OFF";

[~, V, Q, ~] = flight_condition(alt * 0.3048, "", Mach);
CL = W * 4.448 / (Q * G.S * 0.3048^2);
CD = 0.91185/100;
D = Q * G.S * 0.3048^2 * CD * 0.224809;

pi_c_range = linspace(5, 15, 11);
To4_range = linspace(2000, 3000, 11);
F_spec_matrix = zeros(11:11);
SFC_matrix = zeros(11:11);
i = 1;
j = 1;

for pi_c = pi_c_range
    for To4 = To4_range
        [F_spec, ~, SFC, ~, ~, ~, ~] = compute_ondesign_ideal_AB_TJ_performance(...,
            Mach, alt, Cp, gamma, h_pr, pi_c, To4, To7, mdot_o, units, ABswitch);
        F_spec_matrix(i,j) = F_spec;
        SFC_matrix(i,j) = SFC;
        i = i +1;

    end
    i = 1;
    j = j + 1;
end

plot(F_spec_matrix, SFC_matrix)

hold on

for i = linspace(1, 11, 11)
    line(F_spec_matrix(i,:), SFC_matrix(i,:), 'LineStyle', '--')
    hold on
end

yline(1.05, 'Color', 'black')
title('SFC vs F/ṁ', "FontSize", 20, 'FontWeight', 'bold', 'FontName', 'Arial')
xlabel("F/ṁ _{lbf/(lbm/sec)}", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
ylabel("SFC _{(lbm/hr)/lbf}", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
grid on
lgd = legend({'π = 5', 'π = 6', 'π = 7', 'π = 8', 'π = 9', 'π = 10', ...
    'π = 11', 'π = 12', 'π = 13', 'π = 14', 'π = 15', ...
    'Tt4 = 2000', 'Tt4 = 2100', 'Tt4 = 2200', 'Tt4 = 2300', 'Tt4 = 2400', 'Tt4 = 2500', ...
    'Tt4 = 2600', 'Tt4 = 2700', 'Tt4 = 2800', 'Tt4 = 2900', 'Tt4 = 3000'}, ...
    'Location','northwest', 'NumColumns', 2);

To4_max = 2600;
To4_eff = To4_range(7);
pi_c_eff = pi_c_range(4);
F_spec_eff = F_spec_matrix(6,4);
SFC_eff = SFC_matrix(6,4);
N_eng = 4;

F = D/N_eng;
mdot_o = F/F_spec_eff;