function [F_specific, F, SFC, mdot_fuel, V9, u_th, u_p, u_o] = compute_ondesign_ideal_AB_TJ_performance(Mach, alt, Cp, gamma, h_pr, pi_c, To_4, To_7, mdot_o, units, ABswitch)

format long

if units == "EN"
    gc_1 = 25037;
    gc_2 = 32.2;
    gc_3 = 60^2;
    gc_4 = 1.8;
    gc_5 = 4.1868;
else
    gc_1 = 1000;
    gc_2 = 1;
    gc_3 = 1;
    gc_4 = 1;
end

[~, To, ~, ~] = atm_model(alt, units);
To = To * gc_4;
Cp = Cp * gc_5;

R = Cp * (gamma-1)/gamma;
a0 = sqrt(gamma*R*To*gc_4);
tau_r = 1 + (gamma-1)/2 * Mach^2;
tau_l = To_4 /To;
tau_ab = To_7/To;
tau_c = pi_c ^ ((gamma-1)/gamma);
tau_t = 1 - tau_r/tau_l * (tau_c - 1);

if ABswitch == "OFF"
    V9ratio = sqrt(2/(gamma-1) * tau_l/(tau_c * tau_r) * (tau_r * tau_c * tau_t - 1));
    F_specific = a0 * (V9ratio - Mach) / gc_2;
    F = F_specific * mdot_o;
    
    f = Cp * To/h_pr * (tau_l - tau_r * tau_c);
    SFC = f/F_specific * gc_3;
    mdot_fuel = SFC * F / gc_3;

    u_th = 1 - 1/(tau_r * tau_c);

elseif ABswitch == "ON"
    V9ratio = sqrt(2/(gamma-1) * tau_ab * (1 - (tau_l/(tau_r * tau_c) / (tau_l - tau_r * (tau_c - 1)) )));
    F_specific = a0 * (V9ratio - Mach) / gc_2;
    F = F_specific * mdot_o;
    
    f = Cp * To/h_pr * (tau_ab - tau_r);
    SFC = f/F_specific * gc_3;
    mdot_fuel = SFC * F / gc_3;

    u_th = ((gamma - 1) * Cp * To * ( (V9ratio)^2 - Mach^2)) / (2 * f * h_pr);
end

V9 = V9ratio * a0;
u_p = 2*Mach / (V9ratio + Mach);
u_o = u_th * u_p;

end