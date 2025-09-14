%% GIVEN:
format long; clear; clc; close all;

u = 398600.435;
% [km^3/s^2] Gravitational Parameter of the Earth

coe_1 = [6978.137; 5.494e-02; 29.258; 37.464; 270.117; 0];
% [km, , deg, deg, deg, deg] Initial Classical Orbital Elements

coe_2 = [26619.179; 2.113e-02; 31.157; 53.189; 307.371; 180];
% [km, , deg, deg, deg, deg] Initial Classical Orbital Elements

UTC1 = [2025, 12, 13, 14, 15, 16];
% [yyyy, MM, dd, hh, mm, ss] Initial Time in UTC Format

dv_vec = zeros(2, 1);
% [km/s] Initialize Delta-V Comparison Vector

dt_vec = zeros(2, 2);
% [s] Initialize Time Comparison Vector. First Column is Time until Transfer and Second Column is Transfer Time

%% CALCULATIONS:

[r1_eci_initial, v1_eci_initial] = COE_ECI(coe_1);
% [km, km/s] Initial State Vector in ECI Coordinates WRT Earth

[r2_eci_initial, v2_eci_initial] = COE_ECI(coe_2);
% [km, km/s] Final State Vector in ECI Coordinates WRT Earth

h1 = cross(r1_eci_initial, v1_eci_initial);
% [km^2/s] Initial Angular Momentum Vector in ECI Coordinates WRT Earth

h2 = cross(r2_eci_initial, v2_eci_initial);
% [km^2/s] Initial Angular Momentum Vector in ECI Coordinates WRT Earth

p1 = norm(h1)^2/u;
p2 = norm(h2)^2/u;
e1 = coe_1(2);
e2 = coe_2(2);

n = sqrt(u/coe_1(1)^3);
% [rad/s] Mean Motion of Initial Satellite Orbit

LOI_ECI = cross(h1, h2) / norm(cross(h1, h2));
% [] Line of Intersection Directional Vector Between Orbital Planes in ECI Coordinates WRT Earth


% Calculates the Transformation Matrix from ECI to Initial PQW Coordinates

e2_vctr = 1/u * cross(v1_eci_initial, h1) - r1_eci_initial/norm(r1_eci_initial);
P_vctr = e2_vctr/norm(e2_vctr);
W_vctr = h1/norm(h1);
Q_vctr = cross(W_vctr, P_vctr);
PQW1ToEci = [P_vctr, Q_vctr, W_vctr];
EciToPQW1 = transpose([P_vctr, Q_vctr, W_vctr]);

LOI_PQW1 = EciToPQW1 * LOI_ECI;
% [] Line of Intersection Directional Vector Between Orbital Planes in PQW1 Coordinates WRT Earth

theta1 = atan2d(LOI_PQW1(2), LOI_PQW1(1)); 
% [deg] Primary Departure Theta

if theta1 < 0
    theta1 = theta1 + 360;
end

theta3 = theta1 + 180;
% [deg] Secondary Departure Theta


% Calculates the Transformation Matrix from ECI to Final PQW Coordinates

e2_vctr = 1/u * cross(v2_eci_initial, h2) - r2_eci_initial/norm(r2_eci_initial);
P_vctr = e2_vctr/norm(e2_vctr);
W_vctr = h2/norm(h2);
Q_vctr = cross(W_vctr, P_vctr);
PQW2ToECI = [P_vctr, Q_vctr, W_vctr];
ECIToPQW2 = transpose([P_vctr, Q_vctr, W_vctr]);

LOI_PQW2 = ECIToPQW2 * LOI_ECI; 
% [] Line of Intersection Directional Vector Between Orbital Planes in PQW2 Coordinates WRT Earth

theta2 = atan2d(LOI_PQW2(2), LOI_PQW2(1)); 
% [deg] PRIMARY ARRIVAL THETA

if theta2 < 0
    theta2 = theta2 + 360; 
end

theta4 = theta2+180;
% [deg] Secondary Arrival Theta

theta_departure_range = [theta1, theta3];
theta_arrival_range = [theta2, theta4];

i = 1;

for theta_depart = theta_departure_range

    theta_arrival = theta_arrival_range(i);
    T_vec = [-sind(theta_depart); cosd(theta_depart); 0];

    r1_eci = p1 / (1 + e1 * cosd(theta_depart)) * PQW1ToEci * [cosd(theta_depart); sind(theta_depart); 0];
    r2_eci = p2 / (1 + e2 * cosd(theta_arrival)) * PQW2ToECI * [cosd(theta_arrival); sind(theta_arrival); 0];
    r1 = norm(r1_eci);
    r2 = norm(r2_eci);
    a_ht = (r1 + r2)/2;

    v1i_eci = sqrt(u/p1) * PQW1ToEci * [-sind(theta_depart); cosd(theta_depart) + e1; 0];
    v2f_eci = sqrt(u/p2) * PQW2ToECI * [-sind(theta_arrival); cosd(theta_arrival) + e2; 0];
    v1i = norm(v1i_eci);
    v2f = norm(v2f_eci);

    v1f = sqrt(2*u/r1 - u/a_ht);
    v2i = sqrt(2*u/r2 - u/a_ht);

    v1f_eci = v1f * PQW1ToEci * T_vec;
    v2i_eci = v2i * PQW1ToEci * T_vec;

    E = 2*atan(sqrt((1+e1)/(1-e1)) * tand(theta_depart/2));
    % [rad] Eccentric Anomoly of Orbit before Transfer

    dt_vec(i,1) = (E - e1*sin(E))/n;
    % [s] Time until Transfer Departure

    dt_vec(i, 2) = pi * sqrt(a_ht^3/u);
    % [s] Transfer Mission Time

    dv_vec(i) = norm(v2f_eci - v2i_eci) + norm(v1f_eci - v1i_eci);
    % [km/s] Store Total Mission Delta-V

    i = i+1;
end

[dv_opt, index] = min(dv_vec);
% [km/s, -] Optimal Delta-V for Non-Planar Hohmann Transfer

total_time = abs(dt_vec(index, 1)) + dt_vec(index, 2);

current_datetime = datetime(UTC1, 'Format', 'yyyy-MM-dd HH:mm:ss', 'TimeZone', 'UTC');
updated_datetime = current_datetime + seconds(total_time);
UTC2 = datetime(updated_datetime, 'Format','yyyy:MM:dd:HH:mm:ss.SSS');

fprintf("Optimal Delta-V = %.3f km/s\n", min(dv_vec))
fprintf("Mission Time = %.3f hr\n", dt_vec(index,2) / 3600)
fprintf("Total Mission Time = %.3f hr\n", total_time / 3600)
fprintf("Final UTC Time = [%s]\n", UTC2)