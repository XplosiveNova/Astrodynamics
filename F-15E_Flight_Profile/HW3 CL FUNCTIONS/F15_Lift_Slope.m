format long; clc; clear;

M = [0.9, 2.0]; % [] Range of Plotting Mach Numbers
AOA = 0;        % [deg] AOA

G.AR = 3.02;    % [] Aspect Ratio
G.SW = 45;      % [deg] Leading Edge Sweep Angle
G.CLA = 2*pi;   % [rad^-1] Lift-Curve Slope of 2D Airfoil
G.Iw = 0;       % [deg] Incidence Angle of Wing
G.A0 = 0;       % [deg] Zero-Lift AOA
G.TR = 0.25;    % [] Taper Ratio
G.S = 608;      % [ft] Reference Area
G.planform_type = "delta";
G.leading_edge_type = "sharp";

plot_lift_curve_slope(AOA, G)
plot_lift(M, G)