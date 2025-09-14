function dSdt = NbpEom(t,S,C)

    JD = C.JDo + t / 86400;
    % [solar days]Julian date.

    %-----------------------------------------------------------------------------------------------

    R1cm = transpose(interp1(C.Sun.JD,transpose(C.Sun.R),JD));
    % [km]Sun position WRT the CM in ECI coordinates.

    R2cm = transpose(interp1(C.Earth.JD,transpose(C.Earth.R),JD));
    % [km]Earth position WRT the CM in ECI coordinates.

    R3cm = transpose(interp1(C.Moon.JD,transpose(C.Moon.R),JD));
    % [km]Moon position WRT the CM in ECI coordinates.

    R4cm = transpose(interp1(C.Mars.JD,transpose(C.Mars.R),JD));
    % [km]Mars position WRT the CM in ECI coordinates.

    R5cm = transpose(interp1(C.Jupiter.JD,transpose(C.Jupiter.R),JD));
    % [km]Jupiter position WRT the CM in ECI coordinates.

    R6cm = transpose(interp1(C.Ganymede.JD,transpose(C.Ganymede.R),JD));
    % [km]Ganymede position WRT the CM in ECI coordinates.

    R7cm = transpose(interp1(C.Callisto.JD,transpose(C.Callisto.R),JD));
    % [km]Callisto position WRT the CM in ECI coordinates.

    R8cm = transpose(interp1(C.Io.JD,transpose(C.Io.R),JD));
    % [km]Io position WRT the CM in ECI coordinates.

    R9cm = transpose(interp1(C.Europa.JD,transpose(C.Europa.R),JD));
    % [km]Europa position WRT the CM in ECI coordinates.

    R10cm = S(1:3);
    % [km]Satellite position WRT the CM in ECI coordinates.

    %-----------------------------------------------------------------------------------------------

    dSdt = zeros(6,1);
    % []Allocates memory for the state vector derivative.

    dSdt(1:3) = S(4:6);
    % [km/s]Satellite velocity WRT the CM in ECI coordinates.

    dSdt(4:6) = ...
        C.Gm(1) * (R1cm - R10cm) / norm(R1cm - R10cm)^3 + ...
        C.Gm(2) * (R2cm - R10cm) / norm(R2cm - R10cm)^3 + ...
        C.Gm(3) * (R3cm - R10cm) / norm(R3cm - R10cm)^3 + ...
        C.Gm(4) * (R4cm - R10cm) / norm(R4cm - R10cm)^3 + ...
        C.Gm(5) * (R5cm - R10cm) / norm(R5cm - R10cm)^3 + ...
        C.Gm(6) * (R6cm - R10cm) / norm(R6cm - R10cm)^3 + ...
        C.Gm(7) * (R7cm - R10cm) / norm(R7cm - R10cm)^3 + ...
        C.Gm(8) * (R8cm - R10cm) / norm(R8cm - R10cm)^3 + ...
        C.Gm(9) * (R9cm - R10cm) / norm(R9cm - R10cm)^3;
    % [km/s^2]Satellite acceleration WRT the CM in ECI coordinates.

end
%===================================================================================================