format long; clc; clear;

M = [0.9, 2.0]; % [] Range of Plotting Mach Numbers
AOA = 0;        % [deg] AOA

G.AR = 3.02;    % [] Aspect Ratio
G.SW_LE = 45;   % [deg] Leading Edge Sweep Angle
G.Iw = 0;       % [deg] Incidence Angle of Wing
G.A0 = 0;       % [deg] Zero-Lift AOA
G.TR = 0.25;    % [] Taper Ratio
G.S = 608;      % [ft] Reference Area
G.SW_C4 = atand( tand(G.SW_LE) - (1 - G.TR) / (G.AR * (1 + G.TR)) ); % [deg] Converting Sweep Angle from LE to C/4
G.SW_C2 = atand( tand(G.SW_LE) - 2 * (1 - G.TR) / (G.AR * (1 + G.TR)) ); % [deg] Half Chord Sweep Angle
G.CLA = 2*pi;   % [rad^-1] Lift-Curve Slope of 2D Airfoil
G.M_CR = 0.9;       % [] Critical Mach Number
G.M_SS = 1.3;       % [] Transonic->Supersonic Mach Number
G.planform_type = "delta";
G.leading_edge_type = "sharp";

plot_lift_curve_slope(AOA, G)
plot_lift(M, G)