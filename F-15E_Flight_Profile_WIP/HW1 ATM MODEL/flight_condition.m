function [V, Mach, Q, Re_L, theta, delta, sigma] = flight_condition(alt, V, Mach, units)

format long

R = 287.0528;

[~, temp0, p0, rho0] = atm_model(0, units);
[~, temp, p, rho] = atm_model(alt, units);

theta = temp/temp0;
delta = p/p0;
sigma = rho/rho0;

if units == "EN"
    gc_1 = 0.3048;  % [FT/M]
    gc_2 = 1.8;     % [R/K]
    gc_3 = 0.0019403203;    % [slug/ft3 / kg/m3]
else
    gc_1 = 1;
    gc_2 = 1;
    gc_3 = 1;
end

numV = isnumeric(V);
numMach = isnumeric(Mach);

%V == "option" || V == "OPTION" || V == "options" ||
%Mach == "option" || Mach == "OPTION" || Mach == "options" || 

if numV == false
    V = Mach * sqrt(1.4 * R * temp / gc_2) / gc_1;
elseif numMach == false
    Mach = V * gc_1 /sqrt(1.4 * R * temp / gc_2);
end

mu = (1.458e-06) * ((temp / gc_2)^1.5) * (1 / ((temp / gc_2) + 110.4));
Q = .5 * rho * V^2;
Re_L = (rho / gc_3) * (V / gc_1) / mu;

end