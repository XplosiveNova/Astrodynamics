%{
====================================================================================================
FUNCTION NAME: LaunchConstants.m
AUTHOR: Julio César Benavides, Ph.D.
INITIATED: 11/19/2024
LAST REVISION: 01/19/2025
====================================================================================================
FUNCTION DESCRIPTION:
This function loads all the constants and launch parameters used during the launch simulation.
====================================================================================================
INPUT VARIABLES:
None.
====================================================================================================
OUTPUT VARIABLES:
(C)|Launch constants and parameters structure.
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
(LaunchEvent.m)|This function determines the numerical integration stop condition.
====================================================================================================
ABBREVIATIONS:
'ECEF' = "Earth-centered, Earth-fixed".
----------------------------------------------------------------------------------------------------
'ECI' = "Earth-centered inertial".
----------------------------------------------------------------------------------------------------
'MECO' = "Main-engine cutoff".
----------------------------------------------------------------------------------------------------
'SECO' = "Second-engine cutoff".
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

function C = LaunchConstants

    C.UTC = [2025, 3, 1, 3, 1, 23];
    % [yyyy,MM,dd,HH,mm,ss]Coordinated universal time at mission commencement.

    C.JD = juliandate(C.UTC);
    % [solar days]Julian date at mission commencement.

    %-----------------------------------------------------------------------------------------------

    C.Lat = (28 + 36 / 60 + 30.2 / 3600) * pi / 180;
    % [rad]Ground station latitude (Launch Complex 39A, Florida).

    C.Long = -(80 + 36 / 60 + 15.6 / 3600) * pi / 180;
    % [rad]Ground station longitude (Launch Complex 39A, Florida).

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

    C.hgs = 0;
    % [km]Ground station altitude above mean equator.

    C.Rgse = (C.Re + C.hgs) * [cos(C.Lat) * cos(C.Long); cos(C.Lat) * sin(C.Long); sin(C.Lat)];
    % [km]Ground station position WRT the Earth in ECEF coordinates.

    C.Vgse = cross(C.We,C.Rgse);
    % [km/s]Ground station velocity WRT the Earth in ECEF coordinates.

    %-----------------------------------------------------------------------------------------------

    C.hf = 200;
    % [km]Rocket altitude above mean equator at orbit insertion.

    C.rf = C.Re + C.hf;
    % [km]Rocket range WRT the Earth at orbit insertion.

    %-----------------------------------------------------------------------------------------------

    C.S1.Me = 25600;
    % [kg]Stage 1 empty mass.

    C.S1.Mp = 395700;
    % [kg]Stage 1 propellant mass.

    C.S1.Ispo = 283;
    % [s]Stage 1 specific impulse at sea level.

    C.S1.Ispf = 312;
    % [s]Stage 1 specific impulse in a vacuum.

    C.S1.To = 7686;
    % [kN]Stage 1 thrust at sea level.

    C.S1.Tf = 8227;
    % [kN]Stage 1 thrust in a vacuum.

    C.S1.tb = 162;
    % [s]Stage 1 burn time.

    C.S1.Tdot = (C.S1.Tf - C.S1.To) / C.S1.tb;
    % [kN/s]Stage 1 thrust rate.

    %-----------------------------------------------------------------------------------------------

    C.S2.Me = 3900;
    % [kg]Stage 2 empty mass.

    C.S2.Mp = 92670;
    % [kg]Stage 2 propellant mass.

    C.S2.Isp = 348;
    % [s]Stage 2 specific impulse.

    C.S2.T = 981;
    % [kN]Stage 2 thrust.

    C.S2.tb = 397;
    % [s]Stage 2 burn time.

    %-----------------------------------------------------------------------------------------------

    C.S3.Mplf = 1900;
    % [kg]Payload fairing mass.

    C.S3.Mpay = 23000;
    % [kg]Payload mass.

    %-----------------------------------------------------------------------------------------------

    C.t = zeros(1,7);
    % []Allocates memory for the event time vector.

    C.t(2) = C.S1.tb;
    % [s]Stage 1 MECO.

    C.t(3) = C.t(2) + 5;
    % [s]Stage 1 jettison time.

    C.t(4) = C.t(3) + 5;
    % [s]Stage 2 ignition time.

    C.t(6) = C.t(4) + C.S2.tb;
    % [s]Stage 2 SECO.

    C.t(7) = C.t(6) + 5;
    % [s]Stage 2 jettison time.

    %-----------------------------------------------------------------------------------------------

    C.M(1) = C.S1.Me + C.S1.Mp + C.S2.Me + C.S2.Mp + C.S3.Mplf + C.S3.Mpay;
    % [kg]Rocket mass at launch.

    C.M(2) = C.S1.Me + C.S2.Me + C.S2.Mp + C.S3.Mplf + C.S3.Mpay;
    % [kg]Rocket mass at MECO.

    C.M(3) = C.S2.Me + C.S2.Mp + C.S3.Mplf + C.S3.Mpay;
    % [kg]Rocket mass at Stage 1 jettison.

    C.M(4) = C.M(3);
    % [kg]Rocket mass at Stage 2 ignition.

    C.M(6) = C.S2.Me + C.S3.Mplf + C.S3.Mpay;
    % [kg]Rocket mass at SECO.

    C.M(7) = C.S3.Mplf + C.S3.Mpay;
    % [kg]Rocket mass at Stage 2 jettison.

    %-----------------------------------------------------------------------------------------------

    C.S1.mdot = (C.M(2) - C.M(1)) / C.S1.tb;
    % [kg/s]Stage 1 mass flow rate.

    C.S2.mdot = (C.M(6) - C.M(4)) / C.S2.tb;
    % [kg/s]Stage 2 mass flow rate.

    %-----------------------------------------------------------------------------------------------

    C.R.Cd = 1.16;
    % []Rocket drag coefficient.

    C.R.r = 2.6 / 1000;
    % [km]Rocket radius.

    C.R.Ar = pi * C.R.r^2;
    % [km^2]Rocket reference area.

    %-----------------------------------------------------------------------------------------------

    C.Tu = C.JD - 2451545;
    % [solar days]Solar days since the J2000 epoch at launch.

    C.ERA = 2 * pi * (0.7790572732640 + 1.00273781191135448 * C.Tu);
    % [rad]Earth rotation angle at launch.

    EciToEcef = [ ...
         cos(C.ERA), sin(C.ERA), 0; ...
        -sin(C.ERA), cos(C.ERA), 0; ...
                  0,          0, 1];
    % []Matrix that transforms vectors from ECI coordinates to ECEF coordinates at launch.

    EcefToEci = transpose(EciToEcef);
    % []Matrix that transforms vectors from ECEF coordinates to ECI coordinates at launch.

    C.Ro = EcefToEci * C.Rgse;
    % [km]Rocket position WRT the Earth in ECI coordinates at launch.

    C.Vo = EcefToEci * C.Vgse;
    % [km/s]Rocket velocity WRT the Earth in ECI coordinates at launch.

    C.So = [C.Ro; C.Vo];
    % [km,km/s]Rocket state WRT the Earth in ECI coordinates at launch.

    %-----------------------------------------------------------------------------------------------

    C.Options = odeset('RelTol',1e-10,'Event',@(t,S)LaunchEvent(t,S,C));
    % []Adjusts the accuracy of the numerical integrator.

end
%===================================================================================================