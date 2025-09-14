function [H1,H2,Lambda,dt] = Segment3Design(S,C)

    R1 = S(1).R(:,end);
    % [km]Lexicon position WRT the Earth in ECI coordinates at orbit insertion.

    V1 = S(1).V(:,end);
    % [km]Lexicon velocity WRT the Earth in ECI coordinates at orbit insertion.

    H1 = cross(R1,V1);
    % [km^2/s]Lexicon specific angular momentum in ECI coordinates.

    %-----------------------------------------------------------------------------------------------

    R2 = S(2).R(:,end);
    % [km]Jupiter position WRT the Earth in ECI coordinates at mission commencement.

    V2 = S(2).V(:,end);
    % [km/s]Jupiter position WRT the Earth in ECI coordinates at mission commencement.

    H2 = cross(R2,V2);
    % [km^2/s]Jupiter specific angular momentum in ECI coordinates.

    %-----------------------------------------------------------------------------------------------

    Lambda = cross(H1,H2);
    % [km^4/s^2]Line of intersection vector in ECI coordinates.

    Lambda = Lambda / norm(Lambda);
    % []Line of intersection direction in ECI coordinates.

    Pqw1ToEci = Pqw2Eci(S(1).Coe(:,end),'Degrees');
    % []Matrix that transforms vectors from Lexicon's PQW coordinates to ECI coordinates.

    EciToPqw1 = transpose(Pqw1ToEci);
    % []Matrix that transforms vectors from ECI coordinates to Lexicon's PQW coordinates.

    Lambda_Pqw1 = EciToPqw1 * Lambda;
    % []Line of intersection direction in Lexicon's PQW coordinates.

    %-----------------------------------------------------------------------------------------------

    theta0 = S(1).Coe(6,end) * pi / 180;
    % [rad]Lexicon true anomaly at orbit insertion.

    theta1 = atan2(Lambda_Pqw1(2),Lambda_Pqw1(1));
    % [rad]Nonplanar Hohmann transfer departure point 1.

    %-----------------------------------------------------------------------------------------------

    a = S(1).Coe(1,end);
    % [km]Lexicon semimajor axis at orbit insertion.

    e = S(1).Coe(2,end);
    % []Lexicon eccentricity at orbit insertion.

    n = sqrt(C.Gm / a^3);
    % [rad/s]Lexicon mean orbital speed at orbit insertion.

    %-----------------------------------------------------------------------------------------------

    E0 = 2 * atan(sqrt((1 - e) / (1 + e)) * tan(theta0 / 2));
    % [rad]Lexicon eccentric anomaly at orbit insertion.

    E1 = 2 * atan(sqrt((1 - e) / (1 + e)) * tan(theta1 / 2));
    % [rad]Lexicon eccentric anomaly at nonplanar Hohmann transfer initiation.

    %-----------------------------------------------------------------------------------------------

    t0 = (E0 - e * sin(E0)) / n;
    % [s]Lexicon time since periapsis passage at orbit insertion.

    t1 = (E1 - e * sin(E1)) / n;
    % [s]Lexicon time since periapsis passage at nonplanar Hohmann transfer initiation.

    %-----------------------------------------------------------------------------------------------

    dt = t1 - t0;
    % [s]Segment 2 propagation time.

    if dt < 0

        T = 2 * pi / n;
        % [s]Lexicon orbital period.

        dt = dt + T;
        % [s]Segment 2 propagation time correction.

    end

end
%===================================================================================================