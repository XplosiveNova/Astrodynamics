format long; clc; clear;

Mach = 2;
To = 216.65;
h_pr = 42800;
Cp = 1.004;
gamma = 1.4;
pi_c = 20;
To4 = 1800;
To7 = 2000;
mdot_o = 20;
units = "SI";
ABswitch = "OFF";

[F_spec, F, SFC, mdot_f, V9, u_th, u_p, u_o] = compute_ondesign_ideal_AB_TJ_performance(...,
    Mach, To, Cp, gamma, h_pr, pi_c, To4, To7, mdot_o, units, ABswitch)

ABswitch = "ON";

[F_spec, F, SFC, mdot_f, V9, u_th, u_p, u_o] = compute_ondesign_ideal_AB_TJ_performance(...,
    Mach, To, Cp, gamma, h_pr, pi_c, To4, To7, mdot_o, units, ABswitch);

%%ENGLISH UNITS

Mach = 2;
To = 389.97;
h_pr = 18400;
Cp = 0.24;
gamma = 1.4;
pi_c = 20;
To4 = 3240;
To7 = 3600;
mdot_o = 44.093;
units = "EN";
ABswitch = "OFF";

[F_spec, F, SFC, mdot_f, V9, u_th, u_p, u_o] = compute_ondesign_ideal_AB_TJ_performance(...,
    Mach, To, Cp, gamma, h_pr, pi_c, To4, To7, mdot_o, units, ABswitch);

ABswitch = "ON";

[F_spec, F, SFC, mdot_f, V9, u_th, u_p, u_o]= compute_ondesign_ideal_AB_TJ_performance(...,
    Mach, To, Cp, gamma, h_pr, pi_c, To4, To7, mdot_o, units, ABswitch);