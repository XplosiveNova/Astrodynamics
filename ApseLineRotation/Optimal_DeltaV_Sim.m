%% GIVEN:
format long; clc; clear; close all;

u = 398600.435; 
% [km^3/s^2] Gravitational Parameter of the Earth

UTC1 = [2025, 12, 13, 14, 15, 16];
% [yyyy, MM, dd, hh, mm, ss] Initial Time in UTC Format

a1 = 6978.137;
% [km] Initial Given Semi-Major Axis

e1 = 5.494e-02;
% [] Initial Given Eccentricity

a2 = 26619.179;
% [km] Final Given Semi-Major Axis

e2 = 9.113e-02;
% [] Final Given Eccentricity

w1 = 270.117;
% [deg] Final Arugment of Periapsis

w2 = 307.373;
% [deg] Final Arugment of Periapsis

theta_range = linspace(0, 360, 3601);
% [deg] Range of True Anomolies

dv_vec = zeros(3600, 1);
% [km/s] Initialize Delta-V Comparison Vector

dt_vec = zeros(3600, 1);
% [s] Initialize Time Comparison Vector

%% CALCULATIONS:

p1 = a1 * (1 - e1^2);
% [km] Initial Semi-Latus Rectum

p2 = a2 * (1 - e2^2);
% [km] Final Semi-Latus Rectum

phi = w2 - w1;
% [deg] Phase Angle

for theta1 = theta_range
    theta2 = theta1 + 180 - phi;
    % [deg] Final True Anomoly
    
    T_vec = [-sind(theta1); cosd(theta1); 0];
    % [] Tangential Vector of Satellite WRT Earth in PQW Coordinates
    
    PQW2ToPQW1 = [cosd(phi), -sind(phi), 0; sind(phi), cosd(phi), 0; 0, 0, 1]; 
    % [] Transformation Matrix from Final PQW (PQW2) Coordinates To Initial PQW (PQW 1) Coordinates
    
    r1_vec = p1 / (1 + e1 * cosd(theta1)) * [cosd(theta1); sind(theta1); 0];
    % [km] Initial Position Vector WRT Earth In PQW 1 Coordinates

    v1i_vec = sqrt(u/p1) * [-sind(theta1); cosd(theta1) + e1; 0];
    % [km/s] Initial Velocity Vector Pre-Burn WRT Earth In PQW 1 Coordinates

    v1i = norm(v1i_vec);
    % [km/s] Initial Total Velocity Pre-Burn
    
    r2_vec = p2 / (1 + e2 * cosd(theta2)) * [cosd(theta2); sind(theta2); 0];
    % [km] Final Position Vector WRT Earth In PQW 2 Coordinates

    v2f_vec = sqrt(u/p2) * [-sind(theta2); cosd(theta2) + e2; 0];
    % [km/s] Final Velocity Vector Post-Burn WRT Earth In PQW 2 Coordinates
    
    r2_vec = PQW2ToPQW1 * r2_vec;
    % [km] Final Position Vector WRT Earth In PQW 1 Coordinates

    v2f_vec = PQW2ToPQW1 * v2f_vec;
    % [km] Final Velocity Vector Post-Burn WRT Earth In PQW 1 Coordinates

    v2f = norm(v2f_vec);
    % [km/s] Final Total Velocity Post-Burn
    
    r1 = norm(r1_vec);
    % [km] Initial Total Linear Range

    r2 = norm(r2_vec);
    % [km] Final Total Linear Range

    a_ht = (r1+r2)/2;
    % [km] Semi-Major Axis of Orbital Transfer
    
    v1f = sqrt(2*u/r1 - u/a_ht);
    % [km/s] Initial Total Velocity Post-Burn

    v1f_vec = v1f * T_vec;
    % [km/s] Initial Velocity Vector Post-Burn WRT Earth In PQW 1 Coordinates

    v2i = sqrt(2*u/r2 - u/a_ht);
    % [km/s] Final Total Velocity Pre-Burn

    v2i_vec = -v2i * T_vec;
    % [km/s] Final Total Velocity Vector Pre-Burn WRT Earth In PQW 1 Coordinates

    dv = norm(v2f_vec - v2i_vec) + norm(v1f_vec - v1i_vec);
    % [km/s] Total Delta-V of the Mission

    dv_vec(theta1 * 10 + 1) = dv;
    % [km/s] Store Delta-V in Vector

    dt = pi * sqrt(a_ht^3/u);
    % [s] Optimal Time of the Mission

    dt_vec(theta1 * 10 + 1) = dt;
    % [s] Store Time in Vector

end

[dv_opt, index] = min(dv_vec);
% [km/s, ] Optimal Delta-V for Mission | Index for Said Optimal Delta-V

dt_opt = dt_vec(index);

E_orbit1 = 2*atan(sqrt((1-e1)/(1+e1)) * tan(theta_range(index) * pi / 360));
% [rad] Eccentric Anomoly of Initial Mission Orbit until Burn Point

n = sqrt(u/a1^3);
% [s] Mean Motion of Initial Satellite Orbit

orbit_time = (E_orbit1 - e1*sin(E_orbit1))/n;
% [s] Time of Initial Satellite Orbit until Burn Point

% CONVERTS UTC TO datetime OBJECT

current_datetime = datetime(UTC1, 'Format', 'yyyy-MM-dd HH:mm:ss', 'TimeZone', 'UTC');
updated_datetime = current_datetime + seconds(dt_opt);
UTC2 = datetime(updated_datetime, 'Format','yyyy:MM:dd:HH:mm:ss.SSS');

%% PRINT OUTPUTS:

fprintf("Orbit Time to Burn Location = %.3f seconds\n", orbit_time)
fprintf("Optimal Delta-V = %.3f km/s \n", dv_opt);
fprintf("Total Mission Time = %.3f seconds\n", dt_opt);
fprintf("Final UTC Time = [%s]\n", UTC2)

%% PLOT OUTPUTS:

plot(theta_range, dv_vec, '.', 'Color', 'black', 'MarkerSize', 6); hold on;
plot(theta_range(index), dv_opt, "r.", 'MarkerSize', 16)
title('Mission {\Delta}v Analysis', "FontSize", 20, 'FontWeight', 'bold', 'FontName', 'Arial')
xlabel("{\theta}_i (^{o})", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
xlim([0, 360])
xticks(0:15:360)
ylabel("{\Delta}v (km/s)", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
ylim([3, 3.5])
yticks(3.0:0.05:3.5)
string = sprintf('Optimal Delta-V = %.2f km/s @ True Anomoly: %.2f degrees', dv_opt, theta_range(index));
text(theta_range(index), dv_opt - .025, string)
theme 'light'

% FORMAT GRAPH AS PDF IN LANDSCAPE
set(gcf, 'PaperOrientation', 'landscape');
set(gcf, 'PaperPosition', [0.25 0.25 10.5 8]);
print -bestfit -dpdf 'Mission_DeltaV_Analysis.pdf';
