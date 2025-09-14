function [CL, CL_Alpha, CD, CDo, CDi, K] = transonic_aero_model(Mach, AOA, G)

    format long
    clc;

    [CL, CL_Alpha] = compute_transonic_CL(Mach, AOA, G);

    [CD, CDo, CDi, K] = compute_transonic_CD(CL, Mach, G);

end