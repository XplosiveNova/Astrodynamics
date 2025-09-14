function [L, D, CL, CL_Alpha, CD, CDo, CDi, K] = aero_conflict_func(Mach, AOA, Q, G)

    Mach = abs(Mach);
    
    if Mach <= G.M_CR && round(Mach,2) >= 0
        [CL, CL_Alpha, CD, CDo, CDi, K] = subsonic_aero_model(Mach, AOA, G);
    elseif Mach > G.M_CR && Mach < G.M_SS
        [CL, CL_Alpha, CD, CDo, CDi, K] = transonic_aero_model(Mach, AOA, G);
    elseif Mach >= G.M_SS && Mach <= 4.0
        [CL, CL_Alpha, CD, CDo, CDi, K] = supersonic_aero_model(Mach, AOA, G);
    end
    
    L = Q * CL * G.S;
    D = Q * CD * G.S;

end