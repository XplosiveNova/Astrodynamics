function [CL, CL_Alpha, CD, CDo, CDi, K] = supersonic_aero_model(Mach, AOA, G)

    format long
    clc;
    
    [CL, CL_Alpha] = compute_supersonic_CL(Mach, AOA, G);

    [CD, CDo, CDi, K] = compute_supersonic_CD(CL, Mach, G);

end