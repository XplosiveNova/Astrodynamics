clc; clear; clear all;
format long

% Atmosphere Model Table of Results:
% Produce a table in Word that looks like the table in Appendix A with the same altitudes as given
% in Appendix A (from 0 to 70,000 m), and add columns for (1) 𝜇 in N-s/m2, (2) 𝜈 in 1/(m2-s), (3)
% 𝜃, (4) 𝜎, and (5) 𝛿. See the lecture notes for how to calculate these.

R = 287.0528;
g = 9.806645;
t0 = 288.15;
p0 = 101325;

app = zeros(35, 11);
i = 1;

for alt = linspace(0, 70000, 36)
    atm_model(alt)
    [z, temp, pressure, rho] = atm_model(alt);
    a = sqrt(1.4 * R * temp);
    mu = (1.458e-06) * (temp^1.5) * (1 / (temp + 110.4)); %Dynamic Viscosity
    nu = mu / rho; %Kinematic Viscosity

    theta = temp/t0;
    delta = pressure/p0;
    sigma = rho / (p0/(R*t0));

    
    app(i, :) = [alt, z, temp, pressure, rho, a, mu, nu, theta, delta, sigma];
    i = i + 1;
end 

app = table(app);
filename = 'atm_model.xlsx';
writetable(app,filename,'Sheet',1,'Range','A1')