function [CL, CL_Alpha, CD, CDo, CDi, K] = subsonic_aero_model(Mach, AOA, G)

    format long
    clc;

    [CL, CL_Alpha] = compute_subsonic_CL(Mach, AOA, G);

    [CD, CDo, CDi, K] = compute_subsonic_CD(CL, Mach, G);

end