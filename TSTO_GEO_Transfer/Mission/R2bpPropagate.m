%{
====================================================================================================
FUNCTION NAME: R2bpPropagate.m
AUTHOR: Julio César Benavides, Ph.D.
INITIATED: 07/07/2005
LAST REVISION: 01/23/2025
====================================================================================================
FUNCTION DESCRIPTION:
This function numerically integrates the relative two-body problem and saves the resulting orbital
data in a structure.
====================================================================================================
INPUT VARIABLES:
(to)|Modeling time.
----------------------------------------------------------------------------------------------------
(So)|Initial state vector.
----------------------------------------------------------------------------------------------------
(C)|Structure containing all constants, initial conditions, and parameters needed to solve the
relative two-body problem.
====================================================================================================
OUTPUT VARIABLES:
(S)|Orbital data structure.
====================================================================================================
VARIABLE FORMAT, DIMENSIONS, AND UNITS:
(to)|Row Vector {1 x n}|(s).
----------------------------------------------------------------------------------------------------
(So)|Column Vector {6 x 1}|(km,km/s).
----------------------------------------------------------------------------------------------------
(C)|Structure {-}|(-).
----------------------------------------------------------------------------------------------------
(S)|Structure {-}|(-).
====================================================================================================
USER-DEFINED FUNCTIONS:
(R2bp.Eom.m)|Description.
----------------------------------------------------------------------------------------------------
(UserDefinedFunction2.m)|Description.
====================================================================================================
ABBREVIATIONS:
'Abbreviation1' = "Description".
----------------------------------------------------------------------------------------------------
'Abbreviation2' = "Description".
====================================================================================================
ADDITIONAL COMMENTS:
This section includes information that will help the user understand the code better.
====================================================================================================
PERMISSION:
Any use of this code, either in part or in full, must first be approved by Dr. Julio César
Benavides, Founder and Curator of the Astronautical Engineering Archives (AEA).  For permission to
use this code, Dr. Benavides may be contacted at aea.engineer.com.
====================================================================================================
%}

function S = R2bpPropagate(to,So,C)

    [t,S.S] = ode45(@(t,S)R2bpEom(t,S,C),to,So,C.Options);
    %[s,km,km/s]Numerically integrates the relative two-body problem.

    S.t = linspace(t(1),t(end),1000);
    % [s]Updated time vector.

    S.S = interp1(t,S.S,S.t,'Spline');
    % [km,km/s]Updated state matrix.

    S.S = transpose(S.S);
    % [km,km/s]Transpose of the state matrix.

    S.R = S.S(1:3,:);
    % [km]Position vectors WRT the central body in inertial coordinates.

    S.V = S.S(4:6,:);
    % [km/s]Velocity vectors WRT the central body in inertial coordinates.

    S.JD = C.JD + S.t / 86400;
    % [solar days]Julian date vector.

    UTC = datetime(S.JD,'ConvertFrom','JulianDate','Format','yyyy:MM:dd:HH:dd:ss');
    % [yyyy,MM,dd,HH,dd,ss]Coordinated universal time as a datetime value.

    S.UTC = datevec(UTC);
    % [yyyy,MM,dd,HH,dd,ss]Coordinated universal time as a 6 x 1 row vector.

    S.Coe = State2Coe(S.S,C.Gm,'Degrees');
    % [km,-,deg,deg,deg,deg]Classical orbital elements.

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

        S.r(k) = norm(S.R(:,k));
        % [km]Range WRT the Earth.

        S.v(k) = norm(S.V(:,k));
        % [km/s]Speed WRT the Earth.

        S.h(k) = S.r(k) - C.Re;
        % [km]Altitude above mean equator.

        EciToEcef = [ ...
             cos(ERA(k)), sin(ERA(k)), 0; ...
            -sin(ERA(k)), cos(ERA(k)), 0; ...
                       0,           0, 1];
        % []Matrix that transforms vectors from ECI coordinates to ECEF coordinates.
        
        R = EciToEcef * S.R(:,k);
        % [km]Position WRT the Earth in ECEF coordinates.
        
        S.Lat(k) = asin(R(3) / norm(R)) * 180 / pi;
        % [deg]Latitude.
        
        S.Long(k) = atan2(R(2),R(1)) * 180 / pi;
        % [deg]Longitude.

    end

    %-----------------------------------------------------------------------------------------------

    S = orderfields(S,{'UTC','JD','t','h','r','v','Lat','Long','R','V','S','Coe'});
    % []Reorders the output structure fields.

end
%===================================================================================================