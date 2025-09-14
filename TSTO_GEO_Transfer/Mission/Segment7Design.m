function PM = Segment7Design(S,C,theta2,V2plus)

    S2 = S(5).S(:,end);
    % [km,km/s]Lexicon state WRT the Earth in ECI coordinates at Hohmann transfer arrival.

    S2(4:6) = V2plus;
    % [km/s]Lexicon velocity WRT the Earth in ECI coordinates after Hohmann transfer arrival.

    theta3 = deg2rad(S(6).Coe(6,end));
    % [rad]Jupiter true anomaly after nonplanar Hohmann transfer arrival.

    phi = theta3 + 2.74794281999 - theta2;
    % [rad]Phase angle.

    if phi < 0

        phi = 2 * pi - phi;
        % [rad]Phase angle correction.

    end

    Kp = 1;
    % []Phasing orbits.

    PM = PhasingManeuver(S2,phi,Kp,C.Gm,'Radians');
    % []Lexicon phasing maneuver design.

end
%===================================================================================================