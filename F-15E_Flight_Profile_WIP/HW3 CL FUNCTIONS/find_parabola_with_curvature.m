function [a, b, c] = find_parabola_with_curvature(x1, y1, x2, y2, curvature)
    % FIND_PARABOLA_WITH_CURVATURE
    % Find the coefficients of a parabola given two points and a fixed curvature.
    % 
    % Inputs:
    %   x1, y1 - Coordinates of the first point
    %   x2, y2 - Coordinates of the second point
    %   curvature - The fixed curvature ('a' coefficient) of the parabola
    %
    % Outputs:
    %   a - Curvature of the parabola (same as the input curvature)
    %   b - Coefficient of the linear term
    %   c - Constant term

    % Set up the system of linear equations
    A = [x1, 1; 
         x2, 1];
    B = [y1 - curvature * x1^2;
         y2 - curvature * x2^2];

    % Solve for b and c
    coefficients = A \ B;
    b = coefficients(1);
    c = coefficients(2);

    % Return the curvature (a), and the other coefficients (b, c)
    a = curvature;
end