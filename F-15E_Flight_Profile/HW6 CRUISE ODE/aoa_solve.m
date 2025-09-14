function [error] = aoa_solve(AOA, W, Mach_inf, Q_inf, G)

[L, ~, ~, ~, ~, ~ , ~] = aero_conflict_func(Mach_inf, AOA, Q_inf, G);
error = L - W;

end