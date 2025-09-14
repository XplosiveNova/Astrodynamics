function [error] = aoa_solve_climb(AOA, W, fpa, dVdt, Mach_inf, Q_inf, T, G, g0)

[~, D, ~, ~, ~, ~, ~, ~] = aero_conflict_func(Mach_inf, AOA, Q_inf, G);
error = T * G.N_eng * cosd(AOA + G.ep0) - D - W*sin(fpa) - dVdt * W / g0;

end