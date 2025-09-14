function [CL, CL_alpha] = compute_supersonic_CL(M, AOA, G)

    format long

    AOA = AOA * pi / 180;   % [rad] Angle of Attack
    G.SW_LE = G.SW_LE * pi / 180; % [rad] LE Sweep Angle
    G.Iw = G.Iw * pi / 180; % [rad] Incidence Angle of Wing
    G.A0 = G.A0 * pi / 180; % [rad] Zero-Lift AOA

    B = sqrt(M^2 - 1);
    CL_alpha = interpolate_for_CNa(B, G.SW_LE);
    % [rad^-1] Supersonic Lift Curve Slope

    CL = CL_alpha * (AOA + G.Iw - G.A0);
    % [] Supersonic Compressible Lift Coefficient

end