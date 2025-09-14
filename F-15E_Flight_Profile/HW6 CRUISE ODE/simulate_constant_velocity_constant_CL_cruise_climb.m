function [cruiseOutput] = simulate_constant_velocity_constant_CL_cruise_climb(trajS, propS, G)

format long

% Define initial conditions

xi = trajS.xi;
Pi = trajS.PresCruisei;
hi = trajS.hi;
Wi = trajS.Wi;
y0 = [xi;Pi;hi;Wi];
Rcruise = trajS.RangeCruise;
MachCruise = trajS.MachCruise;
R = propS.R;
g0 = propS.g0;

[Vi, ~, q, ~, ~, ~, ~] = flight_condition(trajS.hi, "option" , MachCruise, G.units);

Vcruise = Vi;
ti = trajS.ti;
tmax = Rcruise * 6076.12/Vcruise + 20*60;
t_span = [ti, ti + tmax];

% Solve for alphaCruise

alpha_guess = 1; % degrees
alphaCruise = fsolve(@(alpha) aoa_solve(alpha, Wi, MachCruise, q, G), alpha_guess);

% Integrate functions

opts = odeset('Events', @(t, y) terminate_range(t, y, Vcruise, Rcruise, alphaCruise, G, propS));
[t, Y] = ode45(@(t, y) cruise_eom(t, y, Vcruise, Rcruise, alphaCruise, G, propS), t_span, y0, opts);

% Now you have output vectors for x, p, h, W, and t
cruiseOutput.xV = Y(:, 1);
cruiseOutput.pV = Y(:, 2);
cruiseOutput.hV = Y(:, 3);
cruiseOutput.WV = Y(:, 4);
tV = t;

cruiseOutput.POWERV = zeros(length(tV), 1);
cruiseOutput.aV = zeros(length(tV), 1);
cruiseOutput.dxdtV = zeros(length(tV), 1);
cruiseOutput.dwdtV = zeros(length(tV), 1);
cruiseOutput.dpdtV = zeros(length(tV), 1);
cruiseOutput.dhdtV = zeros(length(tV), 1);
cruiseOutput.fpaV = zeros(length(tV), 1);
cruiseOutput.LV = zeros(length(tV), 1);
cruiseOutput.DV = zeros(length(tV), 1);
cruiseOutput.LODV = zeros(length(tV), 1);
cruiseOutput.TcurV = zeros(length(tV), 1);
cruiseOutput.Treq_engV = zeros(length(tV), 1);
cruiseOutput.Treq_totV = zeros(length(tV), 1);
cruiseOutput.TavaV = zeros(length(tV), 1);
cruiseOutput.SV = zeros(length(tV), 1);
cruiseOutput.IspV = zeros(length(tV), 1);
cruiseOutput.MachV = zeros(length(tV), 1);
cruiseOutput.AOAV = zeros(length(tV), 1);
cruiseOutput.QV = zeros(length(tV), 1);
cruiseOutput.dVdtV = zeros(length(tV), 1);
cruiseOutput.anV = zeros(length(tV), 1);
%following are set to 0
cruiseOutput.dfpadt = zeros(length(tV), 1);
cruiseOutput.dsigmaV = zeros(length(tV), 1);
cruiseOutput.dVdhV = zeros(length(tV), 1);

cruiseOutput.tV = t;

for i = 1:length(tV)
    x = cruiseOutput.xV(i);
    p = cruiseOutput.pV(i);
    h = cruiseOutput.hV(i);
    W = cruiseOutput.WV(i);

    % Call flight condition function
    
    [~, Tinf, ~, ~] = atm_model(h, "EN");
    [~, Mach, q, ~, ~, ~, ~] = flight_condition(h, Vcruise , "option" , G.units);
    a = Vcruise / Mach;
    
    % Call aerodynamics conflict function
    
    [L, D, CL, ~, ~, ~, ~] = aero_conflict_func(alphaCruise, Mach, q, G);
    
    Treq_tot = D / cosd(alphaCruise + G.ep0);
    Treq_eng = Treq_tot / G.N_eng;
    
    % Solve for throttle to match thrust to drag
    POWER_guess = 0.8;
    POWER = fsolve(@(POWER) throttle_solve(POWER, Treq_eng, Mach, h, G.units, propS), POWER_guess);
    
    % Get available thrust (throttle setting P = 1 for Tavail)
    [~, Tava, ~, ~, ~, ~, ~] = compute_offdesign_ideal_AB_TJ_performance(Mach, h, 1, G.units,propS.ABswitch, propS);
    
    % Calculate thrust and specific fuel consumption (SFC) at the current throttle setting
    [~, T, S, ~, ~, ~, ~] = compute_offdesign_ideal_AB_TJ_performance(Mach,h,POWER,G.units,propS.ABswitch, propS);
    S = S / 3600;   % (lbm/sec/lbf) uninstalled SFC per engine
    
    % Equations of Motion (from page 67 in Miele)
    
    dxdt = Vcruise;
    dwdt = -S * T * G.N_eng;
    dpdt = (2 * R * Tinf * dwdt) / (Vcruise^2 * CL * G.S);
    dhdt = dpdt / (-g0 * p / (R * Tinf));
    fpa = (dhdt / Vcruise) * (180 / pi);
    
    cruiseOutput.POWERV(i) = POWER;
    cruiseOutput.aV(i) = (T * cosd(alphaCruise + G.ep0) - D) * g0/W;
    cruiseOutput.dxdtV(i) = dxdt;
    cruiseOutput.dwdtV(i) = dwdt;
    cruiseOutput.dpdtV(i) = dpdt;
    cruiseOutput.dhdtV(i) = dhdt;
    cruiseOutput.fpaV(i) = fpa;
    cruiseOutput.LV(i) = L;
    cruiseOutput.DV(i) = D;
    cruiseOutput.LODV(i) = L / D;
    cruiseOutput.TcurV(i) = T;
    cruiseOutput.Treq_engV(i) = Treq_eng;
    cruiseOutput.Treq_totV(i) = Treq_tot;
    cruiseOutput.TavaV(i) = Tava;
    cruiseOutput.SV(i) = S * 3600; % SFC in lbm/hr/lbf
    cruiseOutput.IspV(i) = 3600 / S; % Specific Impulse (sec)
    cruiseOutput.MachV(i) = Vcruise / a;
    cruiseOutput.AOAV(i) = alphaCruise;

    cruiseOutput.QV(i) = q;
    cruiseOutput.dVdtV = cruiseOutput.aV(i);
    cruiseOutput.anV = (T * G.N_eng * sind(alphaCruise + G.ep0) + L - W*cos(fpa)) * g0/W;
end

end