function PM = PhasingManeuver(S,phi,Kp,Gm,Units)

    R = S(1:3);
    % [km]Position WRT the Earth at phasing maneuver commencement.

    r = norm(R);
    % [km]Range WRT the Earth at phasing maneuver commencement.

    V = S(4:6);
    % [km/s]Velocity WRT the Earth at phasing maneuver commencement.
    
    H = cross(R,V);
    % [km^2/s]Specific angular momentum WRT the Earth in ECI coordinates.
    
    h = norm(H);
    % [km^2/s]Specific angular momentum magnitude WRT the Earth.

    %-----------------------------------------------------------------------------------------------

    Coe = State2Coe(S,Gm,'Radians');
    % [km,-,rad,rad,rad,rad]Chase COE WRT the Earth at phasing maneuver commencement.
    
    a = Coe(1);
    % [km]Semimajor axis.
    
    e = Coe(2);
    % []Eccentricity.
    
    theta = Coe(6);
    % [rad]True anomaly at phasing maneuver commencement.

    if strcmpi(Units,'Degrees')

        phi = deg2rad(phi);
        % [rad]Converts the phase angle from degrees to radians.

    end

    %-----------------------------------------------------------------------------------------------
    
    Et = 2 * atan(sqrt((1 - e) / (1 + e)) * tan((theta + phi) / 2));
    % [rad]Target eccentric anomaly at phasing maneuver commencement.
    
    Ec = 2 * atan(sqrt((1 - e) / (1 + e)) * tan(theta / 2));
    % [rad]Chase eccentric anomaly at phasing maneuver commencement.
    
    n = sqrt(Gm / a^3);
    % [rad/s]Mean angular speed.
    
    dtct = (Et - Ec - e * (sin(Et) - sin(Ec))) / n;
    % [s]Time it would take the chase to reach the target position at phasing maneuver commencement.
    
    T = 2 * pi / n;
    % [s]Orbital period.
    
    if dtct < 0
        
        dtct = dtct + T;
        % [s]Makes the time it would take the chase to reach the target position at phasing maneuver
        % commencement positive if necessary.
        
    end

    %-----------------------------------------------------------------------------------------------
    
    Kt = Kp - 1 + round(dtct / T);
    % []Orbits completed by the target during the phasing maneuver.
    
    lambdap = ((Kt + 1) / Kp - dtct / (T * Kp))^(2 / 3);
    % []Phase multiplier.
    
    ap = lambdap * a;
    % [km]Phasing orbit semimajor axis.
    
    vplus = sqrt(2 * Gm / r - Gm / ap);
    % [km/s]Chase speed WRT the Earth after phasing maneuver commencement.
    
    Rhat = R / r;
    % []Chase radial direction WRT the Earth in ECI coordinates at phasing maneuver commencement.
    
    That = cross(H,R) / norm(cross(H,R));
    % []Chase tangential direction WRT the Earth in ECI coordinates at phasing maneuver commencement.
    
    gamma = atan(dot(R,V) / h);
    % [rad]Flight path angle at phasing maneuver commencement.
    
    Vplus = vplus * (sin(gamma) * Rhat + cos(gamma) * That);
    % [km/s]Chase velocity WRT the Earth in ECI coordinates after phasing maneuver commencement.
    
    PM.dVp = Vplus - V;
    % [km/s]Delta-v vector in ECI coordinates needed to initiate the phasing maneuver.
    
    PM.dvp = norm(PM.dVp);
    % [km/s]Delta-v needed to initiate the phasing maneuver.
    
    PM.dvm = 2 * PM.dvp;
    % [km/s]Total phasing maneuver delta-v.
    
    PM.dtm = 2 * pi * Kp * sqrt(ap^3 / Gm);
    % [s]Phasing maneuver time of flight.
    
end
%===================================================================================================