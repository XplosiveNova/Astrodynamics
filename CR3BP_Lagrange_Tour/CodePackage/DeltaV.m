function dv = DeltaV(S,C)

    R = S.R31(:,1);
    % [km]Position WRT the Earth in ECI coordinates at mission commencement.

    V = S.V31(:,1);
    % [km/s]Velocity WRT the Earth in ECI coordinates at mission commencement.

    H = cross(R,V);
    % [km^2/s]Specific angular momentum WRT the Earth in ECI coordinates at mission commencement.

    Vhat = cross(H,R) / norm(cross(H,R));
    % []Velocity direction WRT the Earth in ECI coordinates before mission commencement.

    r = norm(R);
    % [km]Range WRT the Earth at mission commencement.

    v = sqrt(C.Gm(1) / r);
    % [km/s]Speed WRT the Earth before mission commencement.

    Vc = v * Vhat;
    % [km/s]Velocity WRT the Earth in ECI coordinates before mission commencement.

    dv = norm(V - Vc);
    % [km/s]Departure delta-v.
    
end
%===================================================================================================