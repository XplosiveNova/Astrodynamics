clc; clear; format long;

%% CONSTANTS
tic
results = [];
temp_results = {};
viable_design_count = 0;
Minf = 3.0;
% [] Freestream Mach Number

chord = 1;
% [m] Airfoil Chord Length

%% SENSITIVITIES
nsu = 50;
% [] Number of Line Segments on Upper side of Airfoil

nsl = nsu;
% [] Number of Line Segments on Lower side of Airfoil

% Other sensitivities were chosen to not be tested for a high-fidelity optimization run time

aoa_sense = nsu;
xtu_sens = nsu;
xtl_sens = nsu;
tu_sens = nsu;

yu = zeros(1, nsu+1);
% [m] Initialize Positive Vertical Position Vector of Airfoil

yl = zeros(1, nsl+1);
% [m] Initialize Negative Vertical Position Vector of Airfoil

%% VARIABLE RANGES
alpha_space = linspace(0,10, aoa_sense+1);
xtu_space = linspace(1/3, 2/3, xtu_sens);
xtl_space = linspace(1/3, 2/3, xtl_sens);
tu_space = linspace(0.0001, .1, tu_sens);
x_space = linspace(0,chord, nsu+1);

%OPTIMIZATION FOR-LOOP
for tu = tu_space
    tl = -abs(.1-tu);
    if (tu + abs(tl) >= 0.1)
        for xtl = xtl_space
            for xtu = xtu_space
                %AIRFOIL EQN. CONSTANTS
                a1 = (tu / (xtu^2));
                a2 = (tl / (xtl^2));
                b1 = 1-2*xtu;
                b2 = 1-2*xtl;
                c1 = 3*xtu^2 - 1;
                c2 = 3*xtl^2 - 1;
                d1 = xtu * (2 - 3*xtu);
                d2 = xtl * (2 - 3*xtl);
                e1 = (1-xtu)^2;
                e2 = (1-xtl)^2;

                for i = 1:length(x_space)
                    yu(i) = (x_space(i) * a1/e1) * (b1 * x_space(i)^2 + c1 * x_space(i) + d1);
                    yl(i) = (x_space(i) * a2/e2) * (b2 * x_space(i)^2 + c2 * x_space(i) + d2);
                end

                %P CODE
                for alphad = alpha_space
                    [cl, cd, cm, xmu, cpu, xml, cpl] = clcdcms(Minf, alphad, nsu, x_space, yu, nsl, x_space, yl);

                    %CM & L/D VALUE
                    if abs(cm) <= .1 && cl >= .3
                        LD = cl/cd;
                        specs = [alphad, tu, tl, xtu, xtl, cl, cd, cm, LD];
                        temp_results{end + 1} = specs;
                    end
                end
            end
        end
    end
end     

results = unique(cell2mat(temp_results'), 'rows');
viable_design_count = length(results);

%FINDS MAXIMUM L/D
[max_LD, max_index] = max(results(:, 9));
optimal_design = results(max_index, :); 
%SORTED VIA: ALPHA = 1, TU=2, TL=3, XTU=4, XTL=5, CL=6, CD=7, CM=8, LD=9

%PLOT AIRFOIL SHAPE
tu = optimal_design(2);
tl = optimal_design(3);
xtu = optimal_design(4);
xtl = optimal_design(5);
LD_max = optimal_design(9);

airfoil_plot(tu, tl, xtu, xtl, LD_max, 1)
time = toc; %ENDS TIME MEASUREMENT
fprintf('Number of Viable Designs: %d\n', viable_design_count)
fprintf('Time Elapsed: %.2f seconds\n', time)
fprintf('Max L/D = %.3f\n', LD_max)
