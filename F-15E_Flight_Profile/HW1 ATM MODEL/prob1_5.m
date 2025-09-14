clc; clear; clear all;
format long


% Using the developed flight condition function, plot altitude on the y-axis vs velocity on the x-axis
% for three Mach numbers, namely, Mach 2, Mach 5, and Mach 10. The plot below is an example
% of how your plot will look like. Your plot will only contain three lines, and it will be in SI units.

app = zeros(420, 2);
i = 1;

for mach = [2, 5, 10]
    for alt = linspace(0, 70000, 501)
        [~, V, ~, ~] = flight_condition(alt, "NA", mach);
        app(i, :) = [V, alt];
        i = i+1;
    end
end

plot(app(1:501, 1), app(1:501, 2), "Color", "k", "LineWidth", 1.5)
hold on
plot(app(502:1002, 1), app(502:1002, 2), "Color", "b", "LineWidth", 1.5)
hold on
plot(app(1003:1503, 1), app(1003:1503, 2), "Color", "r", "LineWidth", 1.5)
hold on
title('Altitude vs Velocity', "FontSize", 20, 'FontWeight', 'bold', 'FontName', 'Arial')
xlabel("Velocity (m/s)", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
xlim([0, 4800])
xticks(0:400:4800)
ylabel("Altitude (m)", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
ylim([0, 75000])
yticks(0:5000:75000)
grid("on")
ax = gca;
ax.LineWidth = 1;
legend('Mach 2','Mach 5', 'Mach 10', "Location", "northeast")