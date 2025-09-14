%{
====================================================================================================
FUNCTION NAME: R2bpConstants.m
AUTHOR: Julio César Benavides, Ph.D.
INITIATED: 12/19/2024
LAST REVISION: 01/23/2025
====================================================================================================
FUNCTION DESCRIPTION:
This function defines all of the constants, parameters, and initial conditions needed to solve the
relative two-body problem.
====================================================================================================
INPUT VARIABLES:
None.
====================================================================================================
OUTPUT VARIABLES:
(C)|Structure containing all constants, initial conditions, and parameters needed to solve the
relative two-body problem.
====================================================================================================
VARIABLE FORMAT, DIMENSIONS, AND UNITS:
(C)|Structure {-}|(-).
====================================================================================================
USER-DEFINED FUNCTIONS:
(GravitationalParameters.m)|This function returns the respective gravitational parameters for a set
of solar system bodies given a cell that specifies the bodies of interest.
----------------------------------------------------------------------------------------------------
(PlanetaryRadii.m)|This function returns the respective planetary radii for a set of solar system
bodies given a cell that specifies the bodies of interest.
----------------------------------------------------------------------------------------------------
(Coe2State.m)|This function calculates the respective states with respect to a central body in an
inertial coordinate system given a set of classical orbital elements.
====================================================================================================
ABBREVIATIONS:
'ECEF' = "Earth-centered, Earth-fixed".
----------------------------------------------------------------------------------------------------
'ECI' = "Earth-centered inertial".
----------------------------------------------------------------------------------------------------
'WRT' = "with respect to".
====================================================================================================
ADDITIONAL COMMENTS:
None.
====================================================================================================
PERMISSION:
Any use of this code, either in part or in full, must first be approved by Dr. Julio César
Benavides, Founder and Curator of the Astronautical Engineering Archives (AEA).  For permission to
use this code, Dr. Benavides may be contacted at aea.engineer.com.
====================================================================================================
%}

function [C,S,dv] = R2bpConstants

    load('LaunchData.mat','S','dv');
    % []Loads the launch segment data.

    %-----------------------------------------------------------------------------------------------

    C.Gm = GravitationalParameters({'Earth'});
    % [km^3/s^2]Gravitational parameter of the Earth.

    C.Re = PlanetaryRadii({'Earth'});
    % [km]Mean equatorial radius of the Earth.

    C.Rp = 6356.752;
    % [km]Mean polar radius of the Earth.

    C.we = 2 * pi / 86164.1;
    % [rad/s]Rotational speed of the Earth.

    C.We = C.we * [0; 0; 1];
    % [rad/s]Rotational velocity of the Earth in ECI and ECEF coordinates.

    C.g = 9.80665 / 1000;
    % [km/s^2]Standard acceleration due to gravity.

    %-----------------------------------------------------------------------------------------------

    C.UTC = S.UTC(1,:);
    % [yyyy,MM,dd,HH,mm,ss]Coordinated universal time at orbit insertion.

    C.JD = juliandate(C.UTC);
    % [solar days]Julian date at mission commencement.

    C.SLo = S.S(:,end);
    % [km,km/s]Lexicon initial state vector WRT the Earth in ECI coordinates.

    %-----------------------------------------------------------------------------------------------

    Tu = C.JD - 2451545;
    % [solar days]Number of solar days since the J2000 epoch.

    ERA = mod(2 * pi * (0.7790572732640 + 1.00273781191135448 * Tu), 2*pi);
    
    EciToEcef = [cos(ERA), sin(ERA), 0; ...
                -sin(ERA), cos(ERA), 0; ...
                 0,           0,     1];

    Long = -100;
    % [dd]
    
    r = (C.Gm / C.we^2)^(1/3);

    R = r * [cosd(Long); sind(Long); 0];

    V = cross(C.We, R);

    R = EciToEcef \ R;

    V = EciToEcef \ V;

    C.SJo = [R; V];

    C.CoeJ = State2Coe(C.SJo,C.Gm,'Degrees');
    % [km,-,rad,rad,rad,rad]HST initial COE.

    %-----------------------------------------------------------------------------------------------

    C.Options = odeset('RelTol',1e-10);
    % []Adjusts the accuracy of the numerical integrator.

end
%===================================================================================================