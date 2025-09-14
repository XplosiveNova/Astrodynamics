function [error] = throttle_solve(POWER, Treq_eng, Mach_inf, alt, units, propS)

[~, Tcurrent, ~, ~, ~, ~, ~] = compute_offdesign_ideal_AB_TJ_performance(Mach_inf,alt,POWER, units, propS.ABswitch, propS);
error = Tcurrent - Treq_eng;

end