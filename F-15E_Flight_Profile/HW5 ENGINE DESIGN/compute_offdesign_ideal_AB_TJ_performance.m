function [F_specific, F, SFC, mdot_fuel, u_th, u_p, u_o] = compute_offdesign_ideal_AB_TJ_performance(Mach, alt, POWER, units, ABswitch, propS)

format long

if units == "EN"
    gc_1 = 25037;
    gc_2 = 32.174;
    gc_3 = 60^2;
    % gc_4 = 0.3048;
    % gc_5 = 1.8;
else
    gc_1 = 1000;
    gc_2 = 1;
    gc_3 = 1;
    % gc_4 = 1;
    % gc_5 = 1;
end

[~, To, Po, ~] = atm_model(alt, 'EN');

R = propS.Cp * (propS.gamma-1)/propS.gamma;
a0 = sqrt(propS.gamma * R * To * gc_1);
tau_r = 1 + (propS.gamma-1)/2 * Mach^2;

To2 = To * tau_r;
To4 = POWER * propS.To4R;

tau_l = To4/To;
tau_ab = propS.To7/To;
pi_r = tau_r ^ ((propS.gamma-1)/propS.gamma);

tau_c = 1 + (propS.tau_cR - 1) * ( (To4/To2) / (propS.To4R/propS.To2R) );
pi_c = (1 + (tau_c - 1)) ^ (propS.gamma/(propS.gamma - 1));
tau_t = 1 - ((tau_r/tau_l) * (tau_c - 1));

if Mach <= 1
    u_gamma = 1;
else
    u_gamma = 1 - 0.075 * (Mach - 1) ^ 1.35;
end

pi_d = 0.9 * u_gamma;
mdot_o = propS.mdot_oR * (Po * pi_r * pi_d * pi_c) / (propS.PoR * propS.pi_rR * propS.pi_dR * propS.pi_cR) * sqrt(propS.To4R/To4);

if ABswitch == "OFF"
    V9ratio = sqrt(2/(propS.gamma-1) * tau_l/(tau_c * tau_r) * (tau_r * tau_c * tau_t - 1));
    F_specific = a0 * (V9ratio - Mach) / gc_2;
    F = F_specific * mdot_o;
    
    f = (tau_l - tau_r * tau_c) / (propS.h_pr/(propS.Cp * To) - tau_l);
    SFC = f/F_specific * gc_3;
    mdot_fuel = SFC * F / gc_3;

    u_th = 1 - 1/(tau_r * tau_c);

elseif ABswitch == "ON"
    V9ratio = sqrt(2/(propS.gamma-1) * tau_ab * (1 - (tau_l/(tau_r * tau_c) / (tau_l - tau_r * (tau_c - 1)) )));
    F_specific = a0 * (V9ratio - Mach) / gc_2;
    F = F_specific * mdot_o;
    
    fo = (tau_l - tau_r * tau_c) / (propS.h_pr/(propS.Cp * To) - tau_l);
    f_ab = (tau_ab - tau_l * tau_t) / (propS.h_pr/(propS.Cp * To) - tau_ab);
    f = fo + f_ab;
    SFC = f/F_specific * gc_3;
    mdot_fuel = SFC * F / gc_3;

    u_th = ((propS.gamma - 1) * propS.Cp * To * ( (V9ratio)^2 - Mach^2)) / (2 * f * propS.h_pr);
end

u_p = 2*Mach / (V9ratio + Mach);
u_o = u_th * u_p;

end