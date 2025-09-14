function [value, isterminal, direction] = terminate_climb(t, y, Pclimb, hcruise, G, propS)

h = y(2);
value = h - hcruise;
isterminal = 1;
direction = 0;

end