function [CD, CDo, CDi, K] = compute_transonic_CD(CL, Mach, G)

    clc;
    format long;

    [~, ~, ~, K_Sub] = compute_subsonic_CD(CL, G.M_CR, G);
    x1 = G.M_CR;
    y1 = K_Sub;

    [~, ~, ~, K_Sup] = compute_supersonic_CD(CL, G.M_SS, G);
    x2 = G.M_SS;
    y2 = K_Sup;

    [a, b, c] = find_parabola_with_curvature_hw4(x1, y1, x2, y2, 0.1);
    K = a * Mach^2 + b*Mach + c;

    CDi = K * CL^2;
    % [] Lift Induced Drag Coefficient

    if Mach > 0.9 && Mach <= 1.05
        CDo = 0.1623*Mach - 0.1165;
    elseif Mach > 1.05 && Mach <= 1.2
        CDo = -0.1736 * Mach^2 + 0.4465 * Mach - 0.2231;
    elseif Mach > 1.2 && Mach <= 1.3
        CDo = 0.0227 * Mach + 0.0357;
    end
    % [] Zero-Lift Drag Coefficient

    CD = CDo + K * CL^2;
    % [] Total Drag Coefficient

end