function [CD, CDo, CDi, K] = compute_supersonic_CD(CL, Mach, G)

    clc;
    format long;

    [~, CLa] = compute_supersonic_CL(Mach, 0, G);
    % [1/rad] Calculates Lift Curve Slope

    K = 1/CLa;

    CDi = K * CL^2;
    % [] Lift Induced Drag Coefficient

    if Mach >= 1.3 && Mach <= 1.5
        CDo = 0.0655;
    elseif Mach > 1.5 && Mach <= 2
        CDo = -0.0106 * Mach + 0.0816;
    elseif Mach > 2.0
        CDo = -0.0106 * Mach + 0.0816;
    end
    % [] Zero-Lift Drag Coefficient

    CD = CDo + K * CL^2;
    % [] Total Drag Coefficient

end