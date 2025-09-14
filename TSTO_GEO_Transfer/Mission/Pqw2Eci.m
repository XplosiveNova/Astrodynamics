function T = Pqw2Eci(Coe,Units)

    I = [1; 0; 0];
    % []One-axis direction.

    K = [0; 0; 1];
    % []Three-axis direction.

    if strcmpi(Units,'Degrees')

        Coe(3:5,:) = Coe(3:5,:) * pi / 180;
        % [rad]Converts all COE angles from degrees to radians.

    end

    R3Om = Rotation(K,Coe(4),'Radians');
    % []Rotation matrix about the three axis by an angle right ascension of the ascending node.

    R1In = Rotation(I,Coe(3),'Radians');
    % []Rotation matrix about the one axis by an angle inclination.

    R3w = Rotation(K,Coe(5),'Radians');
    % []Rotation matrix about the three axis by an angle argument of periapsis.
    
    T = R3Om * R1In * R3w;
    %[] Matrix that transforms vectors from the PQW coordinates to the ECI coordinates.
    
end
%===================================================================================================