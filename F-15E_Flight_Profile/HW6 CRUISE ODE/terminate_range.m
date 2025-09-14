function [value, isterminal, direction] = terminate_range(t, y, Vcruise, Rcruise, AOAcruise, G, propS)

x = y(1);
value = x/6076.12 - Rcruise;
isterminal = 1;
direction = 0;

end