function dydt = cruise_eom(t, y, Vcruise, Rcruise, AOAcruise, G, propS)

x = y(1);
p = y(2);
h = y(3);
W = y(4);

[~, Tinf, Pinf, ~] = atm_model(h, G.units);
[~, Mach, Q, ~, ~, ~, ~] = flight_condition(h, Vcruise, "option", G.units);
[~, D, CL, ~, ~, ~, ~, ~] = aero_conflict_func(Mach, AOAcruise, Q, G);

Treq = D / cosd(AOAcruise + G.ep0);
Treq_eng = Treq / G.N_eng;

POWER_guess = 0.8;
POWER = fsolve(@(POWER) throttle_solve(POWER, Treq_eng, Mach, h, G.units, propS), POWER_guess);

[~, T_eng, SFC, ~, ~, ~, ~] = compute_offdesign_ideal_AB_TJ_performance(Mach, h, POWER, G.units, propS.ABswitch, propS);
SFC = SFC/3600;

dxdt = Vcruise;
dWdt = -SFC * T_eng * G.N_eng;
dpdt = (2 * propS.R * Tinf) / (Vcruise^2 * CL * G.S) * dWdt;
dpdh = -propS.g0 * Pinf / (propS.R * Tinf);
dhdt = dpdt / dpdh;

dydt = [dxdt; dpdt; dhdt; dWdt];

end