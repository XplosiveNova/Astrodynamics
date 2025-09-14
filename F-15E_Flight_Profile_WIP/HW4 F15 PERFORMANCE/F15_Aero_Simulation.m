%% (CONSTANTS)

tic
format long
clc; clear; close all;

currentFolder = fileparts(mfilename('fullpath'));
HW1Path = fullfile(currentFolder, '..', 'HW1 ATM MODEL');
addpath(HW1Path);
HW3Path = fullfile(currentFolder, '..', 'HW3 CL FUNCTIONS');
addpath(HW3Path);

R = 287.05;
gamma = 1.4;
alt = 3 * 10^4;     % [ft] altitude

G.AR = 3.02;        % [] Aspect Ratio
G.TR = 0.25;        % [] Taper Ratio
G.SW_LE = 45;       % [deg] Leading Edge Sweep Angle
G.SW_C4 = atand( tand(G.SW_LE) - (1 - G.TR) / (G.AR * (1 + G.TR)) );     % [deg] Converting Sweep Angle from LE to C/4
G.SW_C2 = atand( tand(G.SW_LE) - 2 * (1 - G.TR) / (G.AR * (1 + G.TR)) ); % [deg] Half Chord Sweep Angle
G.CLA = 2*pi;       % [rad^-1] Lift-Curve Slope of 2D Airfoil
G.Iw = 0;           % [deg] Incidence Angle of Wing
G.A0 = -0.5;        % [deg] Zero-Lift AOA
G.S = 608;          % [ft] Reference Area
G.planform_type = "delta";
G.leading_edge_type = "sharp";
G.M_CR = 0.9;
G.M_SS = 1.3;
G.units = 'EN';
j=1;

%% (1-3)

aoarange = linspace(0, 15, 61);
n = size(aoarange);
CL_range = zeros(1,n(2));

for M = [0.6, 0.9, 1.3]

    [~, ~, Q, ~] = flight_condition(alt, "", M, G.units);
    i=1;

    for alpha = aoarange
        [~, ~, CL, ~, ~, ~, ~, ~] = aero_conflict_func(M, alpha, Q, G);
        CL_range(1,i) = CL;
        i = i+1;
    end

    figure(j)
    plot(aoarange,CL_range, '.-black', 'MarkerSize', 8)
    title('C_L vs {\alpha}', "FontSize", 20, 'FontWeight', 'bold', 'FontName', 'Arial')
    xlabel("{\alpha} _{(deg)}", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
    xlim([0, 15])
    xticks(0:1:n(2))
    ylabel("C_L", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
    ylim([0, 1.25])
    yticks(0:.125:1.25)
    grid on
    theme 'light'

    j = j+1;

end

%% (4-5)

CD_range = zeros(1,n(2));
e_range = zeros(1,n(2));

for M = [0.9, 2]

    [~, ~, Q, ~] = flight_condition(alt, "na", M, G.units);
    i=1;

    for alpha = aoarange
        [~, ~, CL, ~, CD, ~, ~, K] = aero_conflict_func(M, alpha, Q, G);
        CL_range(1,i) = CL;
        CD_range(1,i) = CD;
        e_range(1,i) = 1 /(K * pi * G.AR);
        i = i+1;
    end

    figure(j)
    plot(CD_range(1,:),CL_range(1,:), '.-black', 'MarkerSize', 8)
    title('C_L vs C_D', "FontSize", 20, 'FontWeight', 'bold', 'FontName', 'Arial')
    xlabel("C_D", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
    ylabel("C_L", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
    grid on
    theme 'light'

    j = j+1;

    if M > 1
        break
    else
        figure(j)
        plot(G.AR, mean(e_range), '.black', 'MarkerSize', 16)
        xlabel("AR", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
        xlim([0, 40])
        xticks(0: 5 : 40)
        ylabel("e", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
        ylim([0, 1])
        yticks(0: .1: 1)
        grid on
        theme 'light'
        j = j+1;

    end
end

%% (6-8)

alpha = 7.5;
Mach_range = linspace(0, 2.2, 45);
n = size(Mach_range);
CLa_range = zeros(1,n(2));
CDo_range = zeros(1,n(2));
CDi_range = zeros(1,n(2));
K_range = zeros(1,n(2));
i = 1;

for M = Mach_range

    [~, ~, Q, ~] = flight_condition(alt, "na", M, G.units);

    [~, ~, ~, CLa, ~, CDo, CDi, K] = aero_conflict_func(M, alpha, Q, G);
    CLa_range(1,i) = CLa;
    CDo_range(1,i) = CDo;
    CDi_range(1,i) = CDi;
    K_range(1,i) = K;
    i = i+1;

end

figure(j)
plot(Mach_range,CLa_range, '.-k', 'MarkerSize', 8)
title('C_L_A vs Mach', "FontSize", 20, 'FontWeight', 'bold', 'FontName', 'Arial')
xlabel("Mach Number", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
ylabel("C_L_A", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
grid on
theme 'light'

j = j + 1;

figure(j)
plot(Mach_range(1,:),CDo_range(1,:), '.-black', 'MarkerSize', 8)
title('C_D_o vs Mach', "FontSize", 20, 'FontWeight', 'bold', 'FontName', 'Arial')
xlabel("Mach Number", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
ylabel("C_D_o", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
grid on
theme 'light'

j = j + 1;

figure(j)
plot(Mach_range(1,:),CDi_range(1,:), '.-black', 'MarkerSize', 8)
title('C_D_i vs Mach', "FontSize", 20, 'FontWeight', 'bold', 'FontName', 'Arial')
xlabel("Mach Number", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
ylabel("C_D_i", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
grid on
theme 'light'

j = j + 1;

figure(j)
plot(Mach_range(1,:),K_range(1,:), '.-black', 'MarkerSize', 8)
title('K vs Mach', "FontSize", 20, 'FontWeight', 'bold', 'FontName', 'Arial')
xlabel("Mach Number", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
ylabel("K", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
grid on
theme 'light'

j = j + 1;

%% (10)

Mach_range = linspace(0.2, 2.2, 11);
aoarange = linspace(0, 15, 61);
n = size(aoarange);
CL_range = zeros(1,n(2));

for M = Mach_range

    [~, ~, Q, ~] = flight_condition(alt, "na", M, G.units);

    i=1;

    for alpha = aoarange
        [~, ~, CL, ~, ~, ~, ~, ~] = aero_conflict_func(M, alpha, Q, G);
        CL_range(1,i) = CL;
        i = i+1;
    end

    figure(j)
    plot(aoarange,CL_range, '.-', 'MarkerSize', 8)
    title('C_L vs {\alpha}', "FontSize", 20, 'FontWeight', 'bold', 'FontName', 'Arial')
    xlabel("{\alpha} _{(deg)}", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
    xlim([0, 15])
    xticks(0:1:n(2))
    ylabel("C_L", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
    ylim([0, 1.25])
    yticks(0:.125:1.25)
    grid on
    lgd = legend({'M = 0.2', 'M = 0.4', 'M = 0.6', 'M = 0.8', 'M = 1.0', 'M = 1.2', ...
        'M = 1.4', 'M = 1.6', 'M = 1.8', 'M = 2.0', 'M = 2.0'}, ...
    'Location','northwest');
    lgd.NumColumns = 3;
    hold on
    theme 'light'

end

j = j+1;

%% (11)

CD_range = zeros(1,n(2));

for M = Mach_range

    [~, ~, Q, ~] = flight_condition(alt, "na", M, G.units);

    i=1;

    for alpha = aoarange
        [~, ~, ~, ~, CD, ~, ~, ~] = aero_conflict_func(M, alpha, Q, G);
        CD_range(1,i) = CD;
        i = i+1;
    end

    figure(j)
    plot(aoarange,CD_range, '.-', 'MarkerSize', 8)
    title('C_D vs {\alpha}', "FontSize", 20, 'FontWeight', 'bold', 'FontName', 'Arial')
    xlabel("{\alpha} _{(deg)}", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
    xlim([0, 15])
    xticks(0:1:n(2))
    ylabel("C_D", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
    ylim([0, .5])
    yticks(0:.05:.5)
    grid on
    lgd = legend({'M = 0.2', 'M = 0.4', 'M = 0.6', 'M = 0.8', 'M = 1.0', 'M = 1.2', ...
        'M = 1.4', 'M = 1.6', 'M = 1.8', 'M = 2.0', 'M = 2.0'}, ...
    'Location','northwest');
    lgd.NumColumns = 3;
    hold on
    theme 'light'

end

toc