function [theta2,V2plus,HT] = Segment5Design(S,C,H1,H2,Lambda)

    R1 = S(3).R(:,end);
    % [km]Lexicon position WRT the Earth in ECI coordinates at nonplanar Hohmann transfer
    % commencment.

    %-----------------------------------------------------------------------------------------------

    Pqw2ToEci = Pqw2Eci(S(4).Coe(:,end),'Degrees');
    % []Matrix that transforms vectors from Jupiter's PQW coordinates to ECI coordinates.

    EciToPqw2 = transpose(Pqw2ToEci);
    % []Matrix that transforms vectors from ECI coordinates to Jupiter's PQW coordinates.

    Lambda_Pqw2 = EciToPqw2 * Lambda;
    % []Line of intersection direction in Jupiter's PQW coordinates.

    %-----------------------------------------------------------------------------------------------

    theta2 = atan2(Lambda_Pqw2(2),Lambda_Pqw2(1)) + pi;
    % [rad]Jupiter true anomaly at nonplanar Hohmann transfer arrival.

    a = S(4).Coe(1,end);
    % [km]Jupiter semimajor axis.

    e = S(4).Coe(2,end);
    % []Jupiter eccentricity.

    p = a * (1 - e^2);
    % [km]Jupiter semi-latus rectum.

    r2 = p / (1 + e * cos(theta2));
    % [km]Jupiter range WRT the Earth at nonplanar Hohmann transfer arrival.

    %-----------------------------------------------------------------------------------------------

    R2_pqw2 = r2 * [cos(theta2); sin(theta2); 0];
    % [km]Jupiter position WRT the Earth in Jupiter's PQW coordinates at nonplanar Hohmann transfer arrival.

    V2plus_pqw2 = sqrt(C.Gm / p) * [-sin(theta2); cos(theta2) + e; 0];
    % [km/s]Jupiter velocity WRT the Earth in Jupiter's PQW coordinates after nonplanar Hohmann transfer
    % arrival.

    %-----------------------------------------------------------------------------------------------

    R2 = Pqw2ToEci * R2_pqw2;
    % [km]Jupiter position WRT the Earth in ECI coordinates at nonplanar Hohmann transfer arrival.

    V2plus = Pqw2ToEci * V2plus_pqw2;
    % [km/s]Jupiter velocity WRT the Earth in ECI coordinates after nonplanar Hohmann transfer arrival.

    %-----------------------------------------------------------------------------------------------

    HT = HohmannNonPlanar(R1,R2,H1,H2,C.Gm);
    % []Nonplanar Hohmann transfer design.

end
%===================================================================================================