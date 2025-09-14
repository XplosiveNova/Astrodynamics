function [r_eci, v_eci] = COE_ECI(coe)

% Transforms a set of Classical Orbital Elements into a Position and Velocity Vector

u = 398600.435;

p = coe(1) * (1-coe(2)^2);
den = 1 + coe(2)*cosd(coe(6));
r_pqw = [p * cosd(coe(6)) / den; p * sind(coe(6)) / den; 0];
v_pqw = [sqrt(u/p) * -sind(coe(6)); sqrt(u/p) * (cosd(coe(6)) + coe(2)); 0];

EP_M1 = [cosd(coe(5)), sind(coe(5)), 0 ; -sind(coe(5)), cosd(coe(5)), 0; 0, 0, 1];
EP_M2 = [1, 0, 0 ; 0, cosd(coe(3)), sind(coe(3)) ; 0, -sind(coe(3)), cosd(coe(3))];
EP_M3 = [cosd(coe(4)), sind(coe(4)), 0 ; -sind(coe(4)), cosd(coe(4)), 0; 0, 0, 1];
T_EP =  EP_M1 * EP_M2 * EP_M3;
T_PE = transpose(T_EP);

r_eci = T_PE * r_pqw;
v_eci = T_PE * v_pqw;

end