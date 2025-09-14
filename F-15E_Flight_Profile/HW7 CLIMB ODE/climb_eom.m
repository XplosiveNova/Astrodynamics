function dydt = climb_eom(t, y, Pclimb, hcruise, G, propS)

format long

x = y(1);
h = y(2);
V = y(3);
W = y(4);
fpa = y(5);

g0 = propS.g0;
R = propS.R;
RE = 20855532; % [ft]

[z, ~, ~, ~] = atm_model(h, G.units);
[~, Machinf, ~, ~, theta, ~, sigma] = flight_condition(h, V , "", G.units);
Qinf = 881.020341262156;
Veas = 861;

[~, F, S, ~, ~, ~, ~] = compute_offdesign_ideal_AB_TJ_performance(Machinf, h, Pclimb, G.units, propS.ABswitch, propS);
SFC = S/3600;

if h < 36089
    % Ti_prime = (-6.5/1000)*1.8/3.28083; % R/ft 
    dsigmadh = (4.2559)*((theta)^3.2559)*(-.0065/288.15);
elseif h >= 36089
    Ti = 216.65*(9/5); % Rankine
    PI = 22636.049*0.020885; % lbf/ft^2
    zi = 11000 * 3.28083; % ft
    % dsigmadh = (0.2971)*(exp(1.7346-(0.0001577*z)))*(-0.0001577)*(RE^2/(RE+h)^2);
    dsigmadh = (PI/(R*Ti*0.002376892982290)) * exp(-g0*(z-zi)/(R*Ti)) * (-g0/(R*Ti)) * ((RE^2)/((RE+h)^2));
end

dxdt = V * cos(fpa);
dhdt = V * sin(fpa);
dVdh = - Veas/(2*sigma^(1.5)) * dsigmadh;
dVdt = dVdh * dhdt;

alpha_guess = 2;
aoa = fsolve( @(aoa) aoa_solve_climb(aoa, W, fpa, dVdt, Machinf, Qinf, F, G, g0), alpha_guess);

[L, ~, ~, ~, ~, ~, ~, ~] = aero_conflict_func(Machinf, aoa, Qinf, G);

dWdt = -SFC * F * G.N_eng;
dfpadt = (g0/ (W * V)) * (F * G.N_eng * sind(aoa + G.ep0) + L - W*cos(fpa));

dydt = [dxdt; dhdt; dVdt; dWdt; dfpadt];

end