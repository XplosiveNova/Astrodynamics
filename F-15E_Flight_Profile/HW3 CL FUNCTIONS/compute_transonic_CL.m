function [CL, CL_Alpha] = compute_transonic_CL(Mach, AOA, G)

    format long

    AOA = AOA * pi / 180;   % [rad] Angle of Attack
    G.SW_LE = G.SW_LE * pi / 180; % [rad] LE Sweep Angle
    G.Iw = G.Iw * pi / 180; % [rad] Incidence Angle of Wing
    G.A0 = G.A0 * pi / 180; % [rad] Zero-Lift AOA
    
    [~, CLa_Sub] = compute_subsonic_CL(G.M_CR, AOA, G);
    x1 = G.M_CR;
    y1 = CLa_Sub;

    [~, CLa_Sup] = compute_supersonic_CL(G.M_SS, AOA, G);
    x2 = G.M_SS;
    y2 = CLa_Sup;

    [a, b, c] = find_parabola_with_curvature(x1, y1, x2, y2, -4);
    CL_Alpha = a * Mach^2 + b*Mach + c;
    
    CL = CL_Alpha * (AOA + G.Iw - G.A0);
    % [] Transonic Compressible Lift Coefficient

end