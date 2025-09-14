format long; clc; clear; close all;

currentFolder = fileparts(mfilename('fullpath'));
HW1Path = fullfile(currentFolder, '..', 'HW1 ATM MODEL');
addpath(HW1Path);
HW3Path = fullfile(currentFolder, '..', 'HW3 CL FUNCTIONS');
addpath(HW3Path);
HW4Path = fullfile(currentFolder, '..', 'HW4 F15 PERFORMANCE');
addpath(HW4Path);

alt_range = [0, 10000, 25000, 35000, 50000];
Mach_range = linspace(0, 2, 41);

POWER = 1;
units = "EN";
ABswitch = "OFF";

% propS.mdot_oR = 1.27719e+02; FOR Problem 5.3

propS.mdot_oR = 1.15e+03;
propS.h_pr = 18400;
propS.Cp = .24;
propS.gamma = 1.4;
propS.pi_cR = 8;
propS.To4R = 2600;
propS.To7 = 3000;
propS.tau_cR = (propS.pi_cR) ^ ((propS.gamma-1)/propS.gamma);

F_matrix = zeros(10,41);
SFC_matrix = zeros(10,41);

i=1;
j=1;

for altitude = alt_range   

    [~, propS.ToR, propS.PoR, ~] = atm_model(altitude, units);

    for Mach = Mach_range

        % DEFINE CONSTNATS

        propS.tau_rR = 1 + 0.5 * (propS.gamma - 1) * Mach^2;
        propS.pi_rR = propS.tau_rR & (propS.gamma/(propS.gamma-1));
        propS.To2R = propS.ToR * propS.tau_rR;

        if Mach > 1
            propS.pi_dR = 0.9 * (1 - 0.075 * (Mach - 1) ^ 1.35);
        else
            propS.pi_dR = 1;
        end

        % FUNCTION

        [~, F, SFC, ~, ~, ~, ~] = ...
            compute_offdesign_ideal_AB_TJ_performance(Mach, altitude, POWER, units, ABswitch, propS);

        F_matrix(i,j) = F;
        SFC_matrix(i,j) = SFC;
        j = j+1;

    end
    j=1;
    i = i+1;
end

figure(1)
plot(Mach_range, F_matrix(1:5,:))
title('Uninstalled Thrust vs Mach Number | AB = OFF', "FontSize", 20, 'FontWeight', 'bold', 'FontName', 'Arial')
xlabel("Mach Number", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
xticks(0:0.25:Mach_range(end))
ylabel("F _{(lbf)}", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
grid on
legend({'Alt = 0 ft', 'Alt = 10,000 ft', 'Alt = 25,000 ft', 'Alt = 35,000 ft', 'Alt = 50,000 ft'}, ...
    'Location','best');
theme 'light'

figure(2)
plot(Mach_range, SFC_matrix(1:5,:))
title('SFC vs Mach Number | AB = OFF', "FontSize", 20, 'FontWeight', 'bold', 'FontName', 'Arial')
xlabel("Mach Number", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
xticks(0:0.25:Mach_range(end))
ylabel("SFC _{(lbm/hr-lbf)}", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
grid on
legend({'Alt = 0 ft', 'Alt = 10,000 ft', 'Alt = 25,000 ft', 'Alt = 35,000 ft', 'Alt = 50,000 ft'}, ...
    'Location','best');
theme 'light'

%% AB = ON

ABswitch = "ON";

for altitude = alt_range   
    
    [~, propS.ToR, propS.PoR, ~] = atm_model(altitude, units);

    for Mach = Mach_range
    
        % DEFINE CONSTNATS
        
        propS.tau_rR = 1 + 0.5 * (propS.gamma - 1) * Mach^2;
        propS.pi_rR = propS.tau_rR & (propS.gamma/(propS.gamma-1));
        propS.To2R = propS.ToR * propS.tau_rR;
        
        if Mach > 1
            propS.pi_dR = 0.9 * (1 - 0.075 * (Mach - 1) ^ 1.35);
        else
            propS.pi_dR = 1;
        end
        
        % FUNCTION
        
        [~, F, SFC, ~, ~, ~, ~] = ...
            compute_offdesign_ideal_AB_TJ_performance(Mach, altitude, POWER, units, ABswitch, propS);
        
        F_matrix(i,j) = F;
        SFC_matrix(i,j) = SFC;
        j = j+1;

    end
    j=1;
    i = i+1;
end

figure(3)
plot(Mach_range, F_matrix(6:10,:))
title('Uninstalled Thrust vs Mach Number | AB = ON', "FontSize", 20, 'FontWeight', 'bold', 'FontName', 'Arial')
xlabel("Mach Number", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
xticks(0:0.25:Mach_range(end))
ylabel("F _{(lbf)}", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
grid on
legend({'Alt = 0 ft', 'Alt = 10,000 ft', 'Alt = 25,000 ft', 'Alt = 35,000 ft', 'Alt = 50,000 ft'}, ...
    'Location','best');
theme 'light'

figure(4)
plot(Mach_range, SFC_matrix(6:10,:))
title('SFC vs Mach Number | AB = ON', "FontSize", 20, 'FontWeight', 'bold', 'FontName', 'Arial')
xlabel("Mach Number", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
xticks(0:0.25:Mach_range(end))
ylabel("SFC _{(lbm/hr-lbf)}", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
grid on
legend({'Alt = 0 ft', 'Alt = 10,000 ft', 'Alt = 25,000 ft', 'Alt = 35,000 ft', 'Alt = 50,000 ft'}, ...
    'Location','best');
theme 'light'