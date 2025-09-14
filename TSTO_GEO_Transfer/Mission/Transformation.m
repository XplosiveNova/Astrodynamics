%{
====================================================================================================
FUNCTION NAME: Transformation.m
AUTHOR: Julio César Benavides, Ph.D.
INITIATED: 12/19/2024
LAST REVISION: 12/19/2024
====================================================================================================
FUNCTION DESCRIPTION:
This function calculates the matrix needed to rotate a coordinate system about an axis by a given
angle.
====================================================================================================
INPUT VARIABLES:
(u)|Rotation axis.
----------------------------------------------------------------------------------------------------
(theta)|Rotation angle.
----------------------------------------------------------------------------------------------------
(Units)|Angle units.
====================================================================================================
OUTPUT VARIABLES:
(T)|Rotation matrix.
====================================================================================================
VARIABLE FORMAT, DIMENSIONS, AND UNITS:
(u)|Column Vector {3 x 1}|().
----------------------------------------------------------------------------------------------------
(theta)|Scalar {1 x 1}|(deg) or (rad).
----------------------------------------------------------------------------------------------------
(Units)|String. Options are 'Degrees' or 'Radians'.
----------------------------------------------------------------------------------------------------
(T)|Matrix {3 x 3}|().
====================================================================================================
USER-DEFINED FUNCTIONS:
None.
====================================================================================================
ABBREVIATIONS:
None.
====================================================================================================
ADDITIONAL COMMENTS:
The rotation axis (u) should have a magnitude of 1.
====================================================================================================
PERMISSION:
Any use of this code, either in part or in full, must first be approved by Dr. Julio César
Benavides, Founder and Curator of the Astronautical Engineering Archives (AEA).  For permission to
use this code, Dr. Benavides may be contacted at aea.engineer.com.
====================================================================================================
%}

function T = Transformation(u,theta,Units)

    if strcmpi(Units,'Degrees') == true
        
        theta = theta * pi / 180;
        % [rad]Converts the rotation angle from degrees to radians.
        
    end

    %-----------------------------------------------------------------------------------------------
    
    ux = [0, -u(3), u(2); u(3), 0, -u(1); -u(2), u(1), 0];
    % []Skew symetric matrix.
    
    uxu = u * transpose(u);
    % []Tensor product.
    
    T = transpose(cos(theta) * eye(3,3) + sin(theta) * ux + (1 - cos(theta)) * uxu);
    % []Transformation matrix.

end
%===================================================================================================