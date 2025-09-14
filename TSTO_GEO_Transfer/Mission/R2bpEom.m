%{
====================================================================================================
FUNCTION NAME: R2bpEom.m
AUTHOR: Julio César Benavides, Ph.D.
INITIATED: 06/24/2005
LAST REVISION: 12/22/2024
====================================================================================================
FUNCTION DESCRIPTION:
This function calculates the equation of motion for the relative two-body problem in state form.
====================================================================================================
INPUT VARIABLES:
(S)|State with respect to a central body in an inertial coordinate system.
----------------------------------------------------------------------------------------------------
(mu)|Gravitational parameter of the central body.
====================================================================================================
OUTPUT VARIABLES:
(dSdt)|Relative two-body problem in state form.
====================================================================================================
VARIABLE FORMAT:
(S)|Column Vector {6 x 1}.
----------------------------------------------------------------------------------------------------
(mu)|Scalar {1 x 1}.
----------------------------------------------------------------------------------------------------
(dSdt)|Column Vector {6 x 1}.
====================================================================================================
AUXILIARY FUNCTIONS:
%None.
====================================================================================================
COMMENTS:
%None.
====================================================================================================
%}

function dSdt = R2bpEom(~,S,C)
    
    R = S(1:3);
    % [km]Position WRT the central body in an inertial coordinates.
    
    V = S(4:6);
    % [km/s]Velocity WRT the central body in an inertial coordinates.
    
    r = norm(R);
    % [km]Range WRT the central body.

    %-----------------------------------------------------------------------------------------------
    
    dSdt = zeros(6,1);
    % []Allocates memory for the state vector derivative.
    
    dSdt(1:3) = V;
    % [km/s]Velocity WRT the central body in an inertial coordinates.
    
    dSdt(4:6) = -C.Gm * R / r^3;
    % [km/s^2]Acceleration WRT the central body in an inertial coordinates.
    
end
%===================================================================================================
