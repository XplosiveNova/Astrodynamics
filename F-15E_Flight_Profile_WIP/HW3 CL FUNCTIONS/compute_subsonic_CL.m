function [CL, CL_alpha] = compute_subsonic_CL(M, AOA, G)

    format long

    AOA = AOA * pi / 180;   % [rad] Angle of Attack
    G.SW_C2 = G.SW_C2 * pi / 180; % [rad] Leading Edge Sweep Angle
    G.Iw = G.Iw * pi / 180; % [rad] Incidence Angle of Wing
    G.A0 = G.A0 * pi / 180; % [rad] Zero-Lift AOA

    [tau, ~] = calculate_tau_and_delta(G);
    % [] Calculates lift slope Factor

    e1 = 1 / (tau + 1);
    % [] Efficiency Factor

    AOA_0L = G.A0 - G.Iw;
    % [rad] Zero Lift AOA Seen by Wing
    
    Num = G.CLA * cos(G.SW_C2);

    if G.AR >= 6 % For High Aspect Ratio

        Denom = sqrt(1 - M^2) + Num/(pi * e1 * G.AR);

        CL_alpha = Num / Denom;
        % [rad^-1] Subsonic Compressible Wing Lift Curve Slope

        CL = CL_alpha * (AOA - AOA_0L);
        % [] Subsonic Compressible Lift Coefficient

    else % For Low Aspect Ratio
        
        Sqrt = sqrt( 1 - M^2 * (cos(G.SW_C2))^2 + (Num/(pi * e1 * G.AR))^2);
        CL_alpha = Num / (Sqrt + Num/(pi * G.AR));
        % [rad^-1] Subsonic Compressible Wing Lift Curve Slope
        
        C1 = interpolate_C1(G.planform_type, G.AR);

        if G.leading_edge_type == "rounded"
    
            C1 = 0.5 * C1;
    
        end

        CL = CL_alpha * (AOA - AOA_0L) + C1 * (AOA - AOA_0L)^2;
        % [] Subsonic Compressible Lift Coefficient

    end

end