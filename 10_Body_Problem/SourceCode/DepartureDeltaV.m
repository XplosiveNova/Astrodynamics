function dv = DepartureDeltaV(Solution,Optimal,C)

    Recm = transpose(interp1(C.Earth.JD,transpose(C.Earth.R),Optimal.JD));
    % [km]Earth position WRT the CM in ECI coordinates at mission commencement.

    Vecm = transpose(interp1(C.Earth.JD,transpose(C.Earth.V),Optimal.JD));
    % [km/s]Earth position WRT the CM in ECI coordinates at mission commencement.

    Rsatcm = Solution.y(1:3,1);
    % [km]Satellite position WRT the CM in ECI coordinates at mission commencement.

    Vsatcm = Solution.y(4:6,1);
    % [km/s]Satellite velocity WRT the CM in ECI coordinates at mission commencement.

    R = Rsatcm - Recm;
    % [km]Satellite position WRT the Earth in ECI coordinates at mission commencement.

    Vplus = Vsatcm - Vecm;
    % [km/s]Satellite velocity WRT the Earth in ECI coordinates at mission commencement.

    H = cross(R,Vplus);
    % [km^2/s]Satellite specific angular momentum in ECI coordinates at mission commencement.

    Vhat = cross(H,R) / norm(cross(H,R));
    % []Satellite velocity direction WRT the Earth in ECI coordinates before mission commencement.

    Vminus = sqrt(C.Gm(2) / norm(R)) * Vhat;
    % [km/s]Satellite velocity WRT the Earth in ECI coordinates before mission commencement.

    dv = norm(Vplus - Vminus);
    % [km/s]Departure delta-v.

    r = norm(R);

end
%===================================================================================================