function S = Cr3bpPropagate(to,So,C)

    [t,S3cm] = ode45(@(t,S)Cr3bpEom(t,S,C),to,So,C.IvpOptions);
    % [s,km,km/s]Numerically integrates the CR3BP equations of motion.

    S.t = linspace(t(1),t(end),2000);
    % [s]Updated time vector.

    S.S3cm = interp1(t,S3cm,S.t,'Spline');
    % [km,km/s]Updated satellite relative states WRT the CM in CR3BP coordinates.

    S.S3cm = transpose(S.S3cm);
    % [km,km/s]Transpose of the satellite relative states WRT the CM in CR3BP coordinates.

    S.R3cm = S.S3cm(1:3,:);
    % [km]Satellite relative positions WRT the CM in CR3BP coordinates.

    S.V3cm = S.S3cm(4:6,:);
    % [km/s]Satellite relative velocities WRT the CM in CR3BP coordinates.

    %-----------------------------------------------------------------------------------------------

    [S.R31,S.V31,S.S31] = Cr3bp2Eci(S.t,S.S3cm,C);
    % [km,km/s,km,km/s]Satellite positions, velocities, and states WRT the Earth in ECI coordinates.

    %-----------------------------------------------------------------------------------------------

    S.JD = C.JD + S.t / 86400;
    % [solar days]Julian date vector.

    UTC = datetime(S.JD,'ConvertFrom','JulianDate','Format','yyyy:MM:dd:HH:dd:ss');
    % [yyyy,MM,dd,HH,dd,ss]Coordinated universal time as a datetime value.

    S.UTC = datevec(UTC);
    % [yyyy,MM,dd,HH,dd,ss]Coordinated universal time as a 6 x 1 row vector.

    %-----------------------------------------------------------------------------------------------

    Tu = S.JD - 2451545;
    % [solar days]Number of solar days since the J2000 epoch.

    ERA = 2 * pi * (0.7790572732640 + 1.00273781191135448 * Tu);
    % [rad]Earth rotation angles for all modeling times.

    %-----------------------------------------------------------------------------------------------

    n = numel(S.t);
    % []Number of elements in the time vector.

    S.r = zeros(1,n);
    % []Allocates memory for the range vector.

    S.v = zeros(1,n);
    % []Allocates memory for the speed vector.

    S.h = zeros(1,n);
    % []Allocates memory for the altitude above mean equator vector.

    S.Lat = zeros(1,n);
    % []Allocates memory for the latitude vector.

    S.Long = zeros(1,n);
    % []Allocates memory for the longitude vector.

    for k = 1:n

        S.r(k) = norm(S.R31(:,k));
        % [km]Range WRT the Earth.

        S.v(k) = norm(S.V31(:,k));
        % [km/s]Speed WRT the Earth.

        S.h(k) = S.r(k) - C.Re;
        % [km]Altitude above mean equator.

        EciToEcef = [ ...
             cos(ERA(k)), sin(ERA(k)), 0; ...
            -sin(ERA(k)), cos(ERA(k)), 0; ...
                       0,           0, 1];
        % []Matrix that transforms vectors from ECI coordinates to ECEF coordinates.
        
        R = EciToEcef * S.R31(:,k);
        % [km]Position WRT the Earth in ECEF coordinates.
        
        S.Lat(k) = asin(R(3) / norm(R)) * 180 / pi;
        % [deg]Latitude.
        
        S.Long(k) = atan2(R(2),R(1)) * 180 / pi;
        % [deg]Longitude.

    end

    %-----------------------------------------------------------------------------------------------

    S = orderfields(S, ...
        {'UTC','JD','t','h','r','v','Lat','Long','R31','V31','S31','R3cm','V3cm','S3cm'});
    % []Reorders the output structure fields.


end
%===================================================================================================