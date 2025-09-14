function [CD, CDo, CDi, K] = compute_subsonic_CD(CL, Mach, G)

    clc;
    format long;
    
    G.SW_C4 = G.SW_C4 * pi / 180; % [rad] Qauter Chord Sweep Angle

    e = (1 - 0.045 * G.AR^0.68) * (1 - 0.227 * G.SW_C4^1.615);
    % [] Planform Efficiency Factor

    K = 1/(pi * G.AR * e);
    % [] Viscous and Inviscid Lift Induced Lift Drag Factor

    CDi = K * CL^2;
    % [] Lift Induced Drag Coefficient

    if Mach <= 0.8
        CDo = -0.0017*Mach + 0.028;
    elseif Mach > 0.8 && Mach <= 0.9
        CDo = 0.0508*Mach - 0.0146;
    end
    % [] Zero-Lift Drag Coefficient

    CD = CDo + K * CL^2;
    % [] Total Drag Coefficient

end