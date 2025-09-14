tic;
% [s]Starts the program timer.

clc;
% []Clears the command window.

clear;
% []Clears the variable workspace.

format('Compact');
% []Formats the command window output to single-spaced output.

format('LongG');
% []Formats the command window output to print 16 digits for double-precision variables.

close('All');
% []Closes all figures;

%% CONSTANTS:

C = Cr3bpConstants;
% []Loads the CR3BP constants.

r12 = C.r12;
% [km]Earth-Moon range.

I = [1; 0; 0];
% []Primary direction in the CR3BP coordinate system.

%% OPTIMIZATION:

dx = 100;
% []Grid density.

theta = deg2rad(-135);
% [rad]Earth departure angle.

R3cmo = C.R1cm + (C.Re + 200) * [cos(theta); sin(theta); 0];
% [km]Initial relative position WRT the CM in CR3BP coordinates.

R3cmf = C.R2cm + (C.Rm + 100) * [1; 0; 0];
% [km]Final relative position WRT the CM in CR3BP coordinates.

%---------------------------------------------------------------------------------------------------

t = linspace(172800,345600,dx);
% [s]Time vector.

phi = zeros(1,dx);
% []Allocates memory for the delta-v matrix.

%---------------------------------------------------------------------------------------------------

parfor k = 1:dx

    to = linspace(0,t(k),10);
    % [s]Modeling time.

    %-----------------------------------------------------------------------------------------------

    InitialGuess = bvpinit(to,r12*ones(1,6));
    % [km,km/s]Initial guess matrix.

    Solution = bvp4c( ...
        @(t,S)Cr3bpEom(t,S,C), ...
        @(S3cmo,S3cmf)Cr3bpBoundaryConditions(S3cmo,S3cmf,R3cmo,R3cmf), ...
        InitialGuess, ...
        C.BvpOptions);
    % [s,km,km/s]Numerically integrates the CR3BP as a boundary value problem.

    %-----------------------------------------------------------------------------------------------

    to = [Solution.x(1), Solution.x(end) * 2];
    % [s]Modeling time update.

    So = Solution.y(:,1);
    % [km,km/s]Initial state.

    S = Cr3bpPropagate(to,So,C);
    % []Propagates the CR3BP.

    R31 = S.R31(:,end);
    % [km]Final position WRT the Earth in CR3BP coordinates.

    phi(k) = acos(dot(R31,I) / norm(R31));
    % [rad]Return angle.

    fprintf('%0.0f%% complete!\n',k / dx * 100);
    % []Prints the index number on the command window.

end

%% PLOT RESULTS:

plot(rad2deg(phi),'k.-');
% []Plots the mission delta-v as a function of index.

grid;
% []Turns the grid on.

%% PRINT SIMULATION TIME:

SimulationTime = toc;
% []Stops the program timer.

SimulationTimeString = 'Simulation Time: %0.3f seconds\n';
% []Formatted string.

fprintf(SimulationTimeString,SimulationTime);
% []Prints the simulation time on the command window.
%===================================================================================================