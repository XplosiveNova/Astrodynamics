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
% []Closes all figures.

%% CONSTANTS:

C = Cr3bpConstants;
% []Loads the CR3BP constants.

%% GIVEN QUANTITIES:

theta = deg2rad(-135);
% [rad]Earth departure angle.

dt = 302400;
% [s]Time of flight.

%% MODELING TIME AND INITIAL GUESS:
    
to = linspace(0,dt,10);
% [s]Modeling time.

InitialGuess = bvpinit(to,C.r12*ones(1,6));
% [km,km/s]Initial guess matrix.

%% BOUNDARY CONDITIONS:

R3cmo = C.R1cm + (C.Re + 200) * [cos(theta); sin(theta); 0];
% [km]Initial relative position WRT the CM in CR3BP coordinates.

R3cmf = C.R2cm + (C.Rm + 300) * [1; 0; 0];
% [km]Final relative position WRT the CM in CR3BP coordinates.

%% NUMERICAL INTEGRATION:

Solution = bvp4c( ...
    @(t,S)Cr3bpEom(t,S,C), ...
    @(S3cmo,S3cmf)Cr3bpBoundaryConditions(S3cmo,S3cmf,R3cmo,R3cmf), ...
    InitialGuess, ...
    C.BvpOptions);
% [s,km,km/s]Numerically integrates the CR3BP as a boundary value problem.

%% TRAJECTORY PROPAGATION:

to = [Solution.x(1), Solution.x(end) * 1];
% [s]Modeling time update.

So = Solution.y(:,1);
% [km,km/s]Initial state.

S1 = Cr3bpPropagate(to,So,C);
% []Propagates the CR3BP.

%% DELTA-V CALCULATIONS:

dv1 = DeltaV(S1,C);
% [km/s]Delta-v required by each burn.

Sum = sum(dv);
% [km/s]Mission delta-v.

%% PLOT RESULTS:

PlotCr3bp(S,C);
% []Plots the satellite trajectory in the CR3BP system.

%% PRINT SIMULATION TIME:

SimulationTime = toc;
% []Stops the program timer.

SimulationTimeString = 'Simulation Time: %0.3f seconds\n';
% []Formatted string.

fprintf(SimulationTimeString,SimulationTime);
% []Prints the simulation time on the command window.
%===================================================================================================