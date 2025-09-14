function HT = HohmannNonPlanar(R1,R2,H1,H2,Gm)
    
    r1 = norm(R1);
    %[km]Initial orbital range.
    
    r2 = norm(R2);
    %[km]Final orbital range.
    
    sigma = r1 / r2;
    %[]Ratio of orbital ranges.
    
    emin = (1 - sigma) / (1 + sigma);
    %[]Eccentricity.
    
    if r1 < r2
        
        e = emin;
        %[]Eccentricity.
        
        p = r1 * (1 + e);
        %[km]Semiparameter.
        
        V1plus_Pqw = sqrt(Gm / p) * [0; e + 1; 0];
        %[km/s]Departure velocity WRT the Earth in the transfer orbit's PQW coordinate system.
        
        V2minus_Pqw = sqrt(Gm / p) * [0; e - 1; 0];
        %[km/s]Arrival velocity WRT the Earth in the transfer orbit's PQW coordinate system.
        
        Weci = H1 / norm(H1);
        %[]Third direction in the transfer orbit's PQW coordinates expressed in ECI coordinates.
        
        Peci = R1 / r1;
        %[]First direction in the transfer orbit's PQW coordinates expressed in ECI coordinates.
        
    elseif r1 > r2
        
        e = -emin;
        %[]Eccentricity.
        
        p = r1 * (1 - e);
        %[km]Semiparameter.
        
        V1plus_Pqw = sqrt(Gm / p) * [0; e - 1; 0];
        %[km/s]Departure velocity WRT the Earth in the transfer orbit's PQW coordinate system.
        
        V2minus_Pqw = sqrt(Gm / p) * [0; e + 1; 0];
        %[km/s]Arrival velocity WRT the Earth in the transfer orbit's PQW coordinate system.
        
        Weci = H2 / norm(H2);
        %[]Third direction in the transfer orbit's PQW coordinates expressed in ECI coordinates.
        
        Peci = R2 / r2;
        %[]First direction in the transfer orbit's PQW coordinates expressed in ECI coordinates.
        
        
    end
    
    Qeci = cross(Weci,Peci);
    %[]Second direction in the transfer orbit's PQW coordinates expressed in ECI coordinates.
    
    PqwToEci = [Peci, Qeci, Weci];
    %[]Matrix that transforms vectors from the transfer orbit's PQW to ECI coordinates.
    
    HT.V1plus = PqwToEci * V1plus_Pqw;
    %[km/s]Departure velocity WRT the Earth in ECI coordinates.
    
    HT.V2minus = PqwToEci * V2minus_Pqw;
    %[km/s]Arrival velocity WRT the Earth in ECI coordinates.
    
    a = p / (1 - e^2);
    %[km]Hohmann transfer semimajor axis.
    
    HT.dt = pi * sqrt(a^3 / Gm);
    %[s]Hohman transfer time of flight.
    
end
%===================================================================================================