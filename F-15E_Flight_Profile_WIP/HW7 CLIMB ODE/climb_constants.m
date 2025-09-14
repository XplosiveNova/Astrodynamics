function [G, trajS, propS] = climb_constants()

format long

currentFolder = fileparts(mfilename('fullpath'));
HW1Path = fullfile(currentFolder, '..', 'HW1 ATM MODEL');
addpath(HW1Path);

%% GEOMETRY STRUCTURE

G.AR = 3.02;        % [] Aspect Ratio
G.TR = 0.25;        % [] Taper Ratio
G.SW_LE = 45;       % [deg] Leading Edge Sweep Angle
G.SW_C4 = atand( tand(G.SW_LE) - (1 - G.TR) / (G.AR * (1 + G.TR)) );     % [deg] Converting Sweep Angle from LE to C/4
G.SW_C2 = atand( tand(G.SW_LE) - 2 * (1 - G.TR) / (G.AR * (1 + G.TR)) ); % [deg] Half Chord Sweep Angle
G.CLA = 2*pi;       % [rad^-1] Lift-Curve Slope of 2D Airfoil
G.Iw = 0;           % [deg] Incidence Angle of Wing
G.A0 = -0.5;        % [deg] Zero-Lift AOA
G.S = 608;          % [ft] Reference Area
G.M_CR = 0.9;       % [] Critical Mach Number
G.M_SS = 1.3;       % [] Transonic->Supersonic Mach Number
G.ep0 = 0;          % [deg] Installation Angle
G.N_eng = 2;        % [] Number of Engines
G.planform_type = "delta";
G.leading_edge_type = "sharp";
G.units = "EN";

%% TRAJECTORY STRUCTURE

trajS.xi = 0;        % [ft] Initial Position
trajS.hi = 2000;     % [ft] Initial Height
trajS.Wi = 70000;    % [lbf] Initial Weight
trajS.ti = 0;        % [s] Initial Time
trajS.fpai = 55 * pi/180; % [rad] Initial Flight Path Angle
trajS.Veas = 861;       % [ft/s] Constant equivalent airpseed (510 knots)
trajS.N_step = 40;      % [] Number of Iterations
trajS.hcruise = 45000;  % [ft] cruise altitude
trajS.Powerclimb = 0.9;     % [] Throttle during climb

[~, trajS.T0, trajS.P0, trajS.rho0] = atm_model(0, G.units);
trajS.Q = .5 * trajS.rho0 * trajS.Veas^2;

[~, trajS.Tempi, trajS.Pi, trajS.rho_i] = atm_model(trajS.hi, G.units);
trajS.Vi = sqrt(2 * trajS.Q/trajS.rho_i); % [ft/s] initial velocity
% [~, trajS.MachCruise, ~, ~, ~, ~, ~] = flight_condition(trajS.hcruise, trajS.Vi , "", G.units);

[~, ~, ~, rhocruise] = atm_model(trajS.hcruise, G.units); % rhocruise = 0.0148730567472338
trajS.Vcruise = sqrt(2 * trajS.Q / rhocruise);   % [ft/s] Cruise Velocity
[~, trajS.MachCruise, ~, ~, ~, ~, ~] = flight_condition(trajS.hcruise, trajS.Vcruise , "", G.units);


%% PROPULSION STRUCTURE

propS.R = 1716.45;  % [ft-lb/slug-R]
propS.g0 = 32.17;   % [ft/s^2]
propS.gamma = 1.4;  % [] Specific Heat Ratio
propS.Cp = 0.24;     % []
propS.h_pr = 18400; % [Btu/(lbm-R)]
propS.To7 = 3000;   % [R]
propS.To4R = 2600;  % [R]
propS.pi_cR = 15;
propS.ABswitch = "ON";
propS.mdot_oR = 300; % [lbm/s] Inlet Mass Flow Rate
[~, propS.ToR, propS.PoR, ~] = atm_model(trajS.hcruise, G.units);

propS.tau_cR = (propS.pi_cR) ^ ((propS.gamma-1)/propS.gamma);
propS.tau_rR = 1 + 0.5 * (propS.gamma - 1) * trajS.MachCruise^2;
propS.pi_rR = propS.tau_rR ^ (propS.gamma/(propS.gamma-1));
propS.pi_dR = 0.9 * (1 - 0.075 * (trajS.MachCruise - 1) ^ 1.35);
propS.To2R = propS.ToR * propS.tau_rR;

end