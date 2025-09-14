function [climbOutput] = simulate_constant_EAS_constant_throttle_climb(trajS, propS, G)

% Define initial conditions

ep0 = G.ep0;
Neng = G.N_eng;

hcruise = trajS.hcruise;
Powerclimb = trajS.Powerclimb;
Vcruise = trajS.Vcruise;

R = propS.R;
g0 = propS.g0;
T0 = trajS.T0;
P0 = trajS.P0;
Rho0 = (P0/(R*T0));

xi = trajS.xi;
hi = trajS.hi;
Vi = trajS.Vi;
Wi = trajS.Wi;
fpai = trajS.fpai;
y0 = [xi;hi;Vi; Wi; fpai];

ti = trajS.ti;
tmax = 5000;
tspan = [ti, ti + tmax];

% Integrate functions

opts = odeset('RelTol', 1e-6, 'Events', @(t, y) terminate_climb(t, y, Powerclimb, hcruise, G, propS));

[t, Y] = ode45(@(t, y) climb_eom(t, y, Powerclimb, hcruise, G, propS), tspan, y0, opts);

% Now you have output vectors for x, h, V, W, and FPA
climbOutput.xV = Y(:, 1);
climbOutput.hV = Y(:, 2);
climbOutput.VV = Y(:, 3);
climbOutput.WV = Y(:, 4);
climbOutput.fpaV = Y(:, 5);
tV = t;

% EOM in Vector State
% need dpdtv
climbOutput.pV = zeros(length(tV), 1);
climbOutput.POWERV = zeros(length(tV), 1);
climbOutput.aV = zeros(length(tV), 1);
climbOutput.anV = zeros(length(tV), 1);
climbOutput.dVdtV = zeros(length(tV), 1);
climbOutput.dxdtV = zeros(length(tV), 1);
climbOutput.dwdtV = zeros(length(tV), 1);
climbOutput.dhdtV = zeros(length(tV), 1);
climbOutput.dfpadtV = zeros(length(tV), 1);
climbOutput.dsigmadhV = zeros(length(tV), 1);
climbOutput.dVdhV = zeros(length(tV), 1);
climbOutput.LV = zeros(length(tV), 1);
climbOutput.DV = zeros(length(tV), 1);
climbOutput.LODV = zeros(length(tV), 1);
climbOutput.TcurV = zeros(length(tV), 1);
climbOutput.Treq_engV = zeros(length(tV), 1);
climbOutput.Treq_totV = zeros(length(tV), 1);
climbOutput.TavaV = zeros(length(tV), 1);
climbOutput.SV = zeros(length(tV), 1);
climbOutput.IspV = zeros(length(tV), 1);
climbOutput.MachV = zeros(length(tV), 1);
climbOutput.AOAV = zeros(length(tV), 1);
climbOutput.QV = zeros(length(tV), 1);

climbOutput.tV = tV;

for i = 1:length(tV)
    h = climbOutput.hV(i);
    V = climbOutput.VV(i);
    W = climbOutput.WV(i);
    fpa = climbOutput.fpaV(i);

    % Call flight condition function
    
    [~, Tinf, Pinf, Rhoinf] = atm_model(h, "EN");
    theta = Tinf/T0;
    sigma = Rhoinf/Rho0;
    
    [~, Mach, ~, ~, ~, ~, ~] = flight_condition(h, Vcruise , "" , G.units);
    q = 881;
    a = sqrt(propS.gamma * R * Tinf);
    
    Veas = sqrt(2*q/Rho0);
    
    % Get available thrust (throttle setting P = 1 for Tavail)
    [~, Tava, ~, ~, ~, ~, ~] = compute_offdesign_ideal_AB_TJ_performance(Mach, h, 1, G.units,propS.ABswitch, propS);
    
    % Calculate thrust and specific fuel consumption (SFC) at the current throttle setting
    [~, T_eng, S, ~, ~, ~, ~] = compute_offdesign_ideal_AB_TJ_performance(Mach,h,Powerclimb,G.units,propS.ABswitch, propS);  % Uninstalled thrust per engine
    T = T_eng * Neng;
    S = S / 3600;   % (lbm/sec/lbf) uninstalled SFC per engine

    if h < 36089 && h >= 0
        Ti_prime = (-6.5/1000)*1.8/3.28083; % R/ft 
        dsigmadh = (-g0/(R*Ti_prime) -1) * theta^(-g0/(R*Ti_prime) - 2) * (Ti_prime/T0);
    elseif h >= 36089 && h < 65617
        Ti = 216.65*(9/5); % Rankine
        Pi = 22636.049*0.020885; % lbf/ft^2
        zi = 11000 * 3.28083; % ft
        z = RE*h/(RE+h); % geopotential altitude equation
        dsigmadh = (Pi/(R*Ti*rho_o)) * exp(-g0*(z-zi)/(R*Ti)) * (-g0/(R*Ti)) * ((RE^2)/((RE+h)^2));
    else
        return;
    end
    
    % Equations of Motion (from page 67 in Miele)
    
    dVdh =  - Veas/(2*sigma^1.5) * dsigmadh;
    dhdt = V * sin(fpa);
    dVdt = dVdh * dhdt;
    
    % Call aerodynamics conflict function
    
    aoa_guess = 4;
    aoa = fsolve(@(aoa) aoa_solve_climb(aoa,W,fpa,dVdt,Mach,q, T_eng, G, g0), aoa_guess);
    
    [L, D, ~, ~, ~, ~, ~, ~]  = aero_conflict_func(Mach, aoa, q, G);
    Treq_tot = (D + W*sin(fpa)) / cosd(aoa + ep0);
    Treq_eng = Treq_tot/Neng;
    
    dfpadt = g0/ (W * V) * (T * sind(aoa + ep0) + L - W*cos(fpa));
    dxdt = V * cos(fpa);
    dWdt = -S * T;

    climbOutput.POWERV(i) = Powerclimb;
    climbOutput.aV(i) = ((T * cosd(aoa + ep0)) - D - W*sin(fpa)) / W;
    climbOutput.anV(i) = V*dfpadt/g0;
    climbOutput.dVdtV(i) = dVdt;
    climbOutput.dxdtV(i) = dxdt;
    climbOutput.dwdtV(i) = dWdt;
    climbOutput.dhdtV(i) = dhdt;
    climbOutput.dfpadtV(i) = dfpadt;
    climbOutput.dsigmadhV(i) = dsigmadh;
    climbOutput.dVdhV(i) = dVdh;
    climbOutput.LV(i) = L;
    climbOutput.DV(i) = D;
    climbOutput.LODV(i) = L/D;
    climbOutput.TcurV(i) = T;
    climbOutput.Treq_engV(i) = Treq_eng;
    climbOutput.Treq_totV(i) = Treq_tot;
    climbOutput.TavaV(i) = Tava;
    climbOutput.SV(i) = S*3600;             % SFC in lbm/hr/lbf
    climbOutput.IspV(i) = 3600 / S; 
    climbOutput.MachV(i) = V / a; 
    climbOutput.AOAV(i) = aoa;
    climbOutput.QV = q;
    climbOutput.pV = Pinf;


end

end