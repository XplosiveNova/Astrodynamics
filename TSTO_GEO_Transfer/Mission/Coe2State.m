%{
====================================================================================================
FUNCTION NAME: Coe2State.m
AUTHOR: Julio César Benavides, Ph.D.
EFFECTED: 06/24/2005
REVISED: 12/22/2024
====================================================================================================
FUNCTION DESCRIPTION:
This function calculates the respective states with respect to a central body in an inertial
coordinate system given a set of classical orbital elements.
====================================================================================================
INPUT VARIABLES:
(Coe)|Classical orbital elements matrix.
----------------------------------------------------------------------------------------------------
(Gm)|Central body gravitational parameter.
----------------------------------------------------------------------------------------------------
(Units)|Classical orbital elements angle units.
====================================================================================================
OUTPUT VARIABLES:
(S)|Inertial states matrix.
====================================================================================================
VARIABLE FORMAT, DIMENSIONS, AND UNITS:
(Coe)|Matrix {6 x n}|[km,-,deg,deg,deg,deg] or [km,-,rad,rad,rad,rad].
----------------------------------------------------------------------------------------------------
(Gm)|Scalar {1 x 1}|[km^3/s^2].
----------------------------------------------------------------------------------------------------
(Units)|String. Options are 'Degrees' or 'Radians'.
----------------------------------------------------------------------------------------------------
(S)|Matrix {6 x n}|[km,km/s].
====================================================================================================
USER-DEFINED FUNCTIONS:
(Transformation.m)|This function calculates the matrix needed to rotate a coordinate system about an
axis by a given angle.
====================================================================================================
ABBREVIATIONS:
'COE' = "classical orbital elements".
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

function S = Coe2State(Coe,Gm,Units)

    I = [1; 0; 0];
    % []Inertial coordinate system principle direction.

    K = [0; 0; 1];
    % []Inertial coordinate system tertiary direction.

    %-----------------------------------------------------------------------------------------------
    
    if strcmpi(Units,'Degrees')
        
        Coe(3:6,:) = Coe(3:6,:) * pi / 180;
        % [rad]Converts all angles from degrees to radians.
        
    end

    %-----------------------------------------------------------------------------------------------
    
    n = size(Coe,2);
    % []Returns the dimensions of the COE matrix.
    
    R = zeros(3,n);
    % []Allocates memory for the position vectors.
    
    V = zeros(3,n);
    % []Allocates memory for the velocity vectors.

    %-----------------------------------------------------------------------------------------------
    
    for k = 1:n

        a = Coe(1,k);
        % [km]Semimajor axis.

        e = Coe(2,k);
        % []Eccentricity.

        In = Coe(3,k);
        % [rad]Inclination.

        Om = Coe(4,k);
        % [rad]Right ascension of the ascending node.

        w = Coe(5,k);
        % [rad]Argument of periapsis.

        theta = Coe(6,k);
        % [rad]True anomaly.

        %-------------------------------------------------------------------------------------------
        
        p = a * (1 - e^2);
        % [km]Semi-latus rectum.
        
        r = p / (1 + e * cos(theta));
        % [km]Range WRT the central body.
        
        Rpqw = r * [cos(theta); sin(theta); 0];
        % [km]Position WRT the central body in perifocal coordinates.
        
        Vpqw = sqrt(Gm / p) * [-sin(theta); cos(theta) + e; 0];
        % [km/s]Velocity WRT the central body in perifocal coordinates.

        %-------------------------------------------------------------------------------------------

        T3Om = Transformation(K,Om,'Radians');
        % []Matrix that transforms vectors about the 3-axis by an angle Om.

        T1In = Transformation(I,In,'Radians');
        % []Matrix that transforms vectors about the 1-axis by an angle In.

        T3w = Transformation(K,w,'Radians');
        % []Matrix that transforms vectors about the 3-axis by an angle w.
        
        EciToPqw = T3w * T1In * T3Om;
        % []Matrix that transforms vectors from inertial coordinates to PQW coordinates.

        PqwToEci = transpose(EciToPqw);
        % []Matrix that transforms vectors from PQW coordinates to inertial coordinates.

        %-------------------------------------------------------------------------------------------
        
        R(:,k) = PqwToEci * Rpqw;
        % [km]Position WRT the central body in inertial coordinates.
        
        V(:,k) = PqwToEci * Vpqw;
        % [km/s]Velocity WRT the central body in inertial coordinates.
        
    end
    
    S = [R; V];
    % [km,km/s]States WRT the central body in inertial coordinates.
    
end
%===================================================================================================