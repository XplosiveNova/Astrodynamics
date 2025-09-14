function [tau, delta] = calculate_tau_and_delta(G)
    % ABOUT:
    %     Program to calculate the tau and delta finite-wing corrections.
    %
    % BACKGROUND:
    %     This method has been developed from Phillips text, Eqs. 1.8.10 to 1.8.14.
    %
    % APPLICATION AND ASSUMPTIONS:
    %     For a wing of any planform having no sweep, no dihedral, no geometric twist, and no aerodynamic twist.

    % Extract inputs
    AR  = G.AR;   % wing aspect ratio
    TR  = G.TR;   % wing taper ratio
    S   = G.S;    % total wing planform area
    CLA  = G.CLA;   % airfoil section lift-curve slope

    b   = sqrt(AR * S);    % wing span
    N   = 99;              % number of Fourier coefficients

    % Initialize coefficient matrix C
    C = zeros(N, N);
    rows = (1:N)';
    cols = (1:N);

    C(1, :) = cols.^2;
    C(end, :) = (-1).^(cols+1) .* cols.^2;
    
    % Compute Thetai and ctheta
    Thetai = ((rows(2:end-1) - 1) * pi) / (N - 1);
    ctheta = 2 * b / (AR * (1 + TR)) .* (1 - (1 - TR) .* abs(cos(Thetai)));
    
    % Populate matrix C for interior rows
    C(2:end-1, :) = ((4 * b) ./ (CLA * ctheta) + (cols ./ sin(Thetai))) .* sin(cols .* Thetai);

    % Invert matrix C and solve for an
    InvC = inv(C);
    an = InvC * ones(N, 1);
    n_vector = (1:N)';

    % Compute delta and tau
    delta = sum(n_vector(2:N) .* (an(2:N).^2) / an(1)^2);
    tau = (1 - (1 + pi * AR / CLA) * an(1)) / ((1 + pi * AR / CLA) * an(1));
  
end