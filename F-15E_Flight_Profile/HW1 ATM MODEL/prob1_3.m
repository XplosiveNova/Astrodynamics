clc; clear; clear all;
format long

% Atmosphere Model Plotting:
% Plot and show the following atmospheric properties with the geometric altitude on the y-axis:
% (1) Altitude vs temperature
% (2) Altitude vs pressure
% (3) Altitude vs density
% (4) Altitude vs speed of sound
% (5) Altitude vs dynamic viscosity

R = 287.0528;
g = 9.806645;
t0 = 288.15;
p0 = 101325;

app = zeros(35, 11);
i = 1;

for alt = linspace(0, 70000, 500)
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

figure(1)
plot(app(:,3),app(:,1), "Color", "k")
title('Altitude vs Temperature', "FontSize", 20, 'FontWeight', 'bold', 'FontName', 'Arial')
xlabel("Temperature (K)", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
xlim([200, 300])
xticks(200:10:300)
ylabel("Altitude (m)", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
ylim([0, 75000])
yticks(0:5000:75000)
grid("on")
ax = gca;
ax.LineWidth = 1;

figure(2)
plot(app(:,4),app(:,1), "Color", "k")
title('Altitude vs Pressure', "FontSize", 20, 'FontWeight', 'bold', 'FontName', 'Arial')
xlabel("Pressure (Pa)", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
xlim([0, 105000])
xticks(0:10000:105000)
ylabel("Altitude (m)", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
ylim([0, 75000])
yticks(0:5000:75000)
grid("on")
ax = gca;
ax.LineWidth = 1;

figure(3)
plot(app(:,5),app(:,1), "Color", "k")
title('Altitude vs Density', "FontSize", 20, 'FontWeight', 'bold', 'FontName', 'Arial')
xlabel("Density (kg/m^{3})", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
xlim([0, 1.25])
xticks(0:.125:1.25)
ylabel("Altitude (m)", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
ylim([0, 75000])
yticks(0:5000:75000)
grid("on")
ax = gca;
ax.LineWidth = 1;

figure(4)
plot(app(:,6),app(:,1), "Color", "k")
title('Altitude vs Speed of Sound', "FontSize", 20, 'FontWeight', 'bold', 'FontName', 'Arial')
xlabel("Speed of Sound (m/s)", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
xlim([275, 350])
xticks(275:15:350)
ylabel("Altitude (m)", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
ylim([0, 75000])
yticks(0:5000:75000)
grid("on")
ax = gca;
ax.LineWidth = 1;

figure(5)
plot(app(:,7),app(:,1), "Color", "k")
title('Altitude vs Dynamic Viscosity', "FontSize", 20, 'FontWeight', 'bold', 'FontName', 'Arial')
xlabel("Dynamic Viscosity (N-s/m^{2})", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
xlim([1.25e-05, 2e-05])
xticks(1.25e-05:1e-06:2e-05)
ylabel("Altitude (m)", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
ylim([0, 75000])
yticks(0:5000:75000)
grid("on")
ax = gca;
ax.LineWidth = 1;