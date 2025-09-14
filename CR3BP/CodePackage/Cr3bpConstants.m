function C = Cr3bpConstants

    R21 = [ ...
        292616.599949313; ...
        190386.955760891; ...
        111835.622190628];
    % [km]Lunar position WRT the Earth in ECI coordinates at UTC.

    V21 = [ ...
        -0.67840247136205; ...
         0.737657606687282; ...
         0.373593679974482];
    % [km/s]Lunar velocity WRT the Earth in ECI coordinates at UTC.

    H21 = cross(R21,V21);
    % [km^2/s]Lunar specific angular momentum WRT the Earth in ECI coordinates at UTC.

    %-----------------------------------------------------------------------------------------------

    C.UTC = [2025, 12, 30, 0, 0, 0];
    % [year,month,day,hour,minute,second]Coordinated universal time at mission commencement.

    C.JD = juliandate(C.UTC);
    % [solar days]Julian date at mission commencement.

    %-----------------------------------------------------------------------------------------------

    C.Re = PlanetaryRadii({'Earth'});
    % [km]Mean equatorial radius of the Earth.

    C.Rm = PlanetaryRadii({'Moon'});
    % [km]Mean equatorial radius of the Moon.

    C.Rp = 6356.752;
    % [km]Mean polar radius of the Earth.

    %-----------------------------------------------------------------------------------------------

    C.Gm = GravitationalParameters({'Earth','Moon'});
    % [km^3/s^2]Gravitational parameters of the Earth and the Moon.

    C.lambda = C.Gm(2) / sum(C.Gm);
    % []Ratio of the gravitational parameters.

    C.r12 = 384400;
    % [km]Constant distance between the Earth and the Moon.

    %-----------------------------------------------------------------------------------------------

    C.wcm = sqrt(sum(C.Gm) / C.r12^3);
    % [rad/s]CR3BP coordinate system rotational speed.

    C.Wcm = C.wcm * [0; 0; 1];
    % [rad/s]CR3BP coordinate system rotational velocity in CR3BP coordinates.

    %-----------------------------------------------------------------------------------------------

    C.R1cm = -C.lambda * C.r12 * [1; 0; 0];
    % [km]Earth position WRT the CM in CR3BP coordinates.

    C.V1cm = cross(C.Wcm,C.R1cm);
    % [km/s]Earth velocity WRT the CM in CR3BP coordinates.

    %-----------------------------------------------------------------------------------------------

    C.R2cm = (1 - C.lambda) * C.r12 * [1; 0; 0];
    % [km]Lunar position WRT the CM in CR3BP coordinates.

    C.V2cm = cross(C.Wcm,C.R2cm);
    % [km/s]Lunar velocity WRT the CM in CR3BP coordinates.

    %-----------------------------------------------------------------------------------------------

    C.L1cm = [0.83691513; 0; 0] * C.r12;
    % [km]First Lagrange point position WRT the CM in CR3BP coordinates.

    C.L2cm = [1.15568216; 0; 0] * C.r12;
    % [km]Second Lagrange point position WRT the CM in CR3BP coordinates.

    C.L3cm = [-1.00506265; 0; 0] * C.r12;
    % [km]Third Lagrange point position WRT the CM in CR3BP coordinates.

    C.L4cm = [0.5 - C.lambda; sqrt(3) / 2; 0] * C.r12;
    % [km]Fourth Lagrange point position WRT the CM in CR3BP coordinates.

    C.L5cm = [0.5 - C.lambda; -sqrt(3) / 2; 0] * C.r12;
    % [km]Fifth Lagrange point position WRT the CM in CR3BP coordinates.

    %-----------------------------------------------------------------------------------------------

    C.ihato = R21 / norm(R21);
    % []Initial primary CR3BP direction in ECI coordinates.

    C.khat = H21 / norm(H21);
    % []Tertiary CR3BP direction in ECI coordinates.

    C.jhato = cross(H21,R21) / norm(cross(H21,R21));
    % []Initial secondary CR3BP direction in ECI coordinates.

    %-----------------------------------------------------------------------------------------------

    C.IvpOptions = odeset('RelTol',1E-10);
    % []Initial value problem options.

    C.BvpOptions = bvpset('RelTol',1E-6,'Nmax',77777);
    % []Boundary value problem options.

end
%===================================================================================================