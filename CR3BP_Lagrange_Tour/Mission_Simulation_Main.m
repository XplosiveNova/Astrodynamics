currentFolder = fileparts(mfilename('fullpath'));
CodePath = fullfile(currentFolder, '..', 'CodePackage');
addpath(CodePath);

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

Equal = strcat(repelem('=',100),'\n');
% []Formatted string with 100 equal signs and a carriage return.


%% CONSTANTS:

C = Cr3bpConstants;
% []Loads the CR3BP constants.

%% FRT EARTH - MOON:

theta = deg2rad(-100);
% [rad]Earth departure angle.

dt1 = 480000;
% [s]Time of flight.

R3cmo = C.R1cm + (C.Re + 200) * [cos(theta); sin(theta); 0];
% [km]Initial relative position WRT the CM in CR3BP coordinates. Located at Earth

R3cmf = C.R2cm + (C.Rm + 300) * [1; 0; 0];
% [km]Final relative position WRT the CM in CR3BP coordinates. Located at Moon

[S(1), dv(1)] = FrtSimulationFunction(R3cmo, R3cmf, dt1, 0, C);
% [] Propagates the CR3BP using Free Return Trajectory Code as a function. %C.R2cm + (C.Rm + 300) * [1; 0; 0];

time(1) = toc;

%% FRT MOON - L1:

dt2 = 105000;

R3cmo = S(1).R3cm(:,end); 
% [km]Initial relative position WRT the CM in CR3BP coordinates. Located at Moon

R3cmf = C.L1cm;
% [km]Final relative position WRT the CM in CR3BP coordinates. Located at L1

[S(2), dv(2)] = FrtSimulationFunction(R3cmo, R3cmf, dt2, S(1).t(end), C);

time(2) = toc;

%% FRT L1 - L2:

dt3 = 455000;

R3cmo = S(2).R3cm(:,end); 
% [km]Initial relative position WRT the CM in CR3BP coordinates. Located at L1

R3cmf = C.L2cm;
% [km]Final relative position WRT the CM in CR3BP coordinates. Located at L2

[S(3), dv(3)] = FrtSimulationFunction(R3cmo, R3cmf, dt3, S(2).t(end), C);

time(3) = toc;

%% FRT L2 - L3:

dt4 = 557500;

R3cmo = S(3).R3cm(:,end); 
% [km]Initial relative position WRT the CM in CR3BP coordinates. Located at L2

R3cmf = C.L3cm;
% [km]Final relative position WRT the CM in CR3BP coordinates. Located at L3

[S(4), dv(4)] = FrtSimulationFunction(R3cmo, R3cmf, dt4, S(3).t(end),C);

time(4) = toc;

%% FRT L3 - L4:

dt5 = 395000;

R3cmo = S(4).R3cm(:,end); 
% [km]Initial relative position WRT the CM in CR3BP coordinates. Located at L3

R3cmf = C.L4cm;
% [km]Final relative position WRT the CM in CR3BP coordinates. Located at L4

[S(5), dv(5)] = FrtSimulationFunction(R3cmo, R3cmf, dt5, S(4).t(end), C);

time(5) = toc;

%% FRT L4 - L5:

dt6 = 352400;

R3cmo = S(5).R3cm(:,end); 
% [km]Initial relative position WRT the CM in CR3BP coordinates. Located at L4

R3cmf = C.L5cm;
% [km]Final relative position WRT the CM in CR3BP coordinates. Located at L5

[S(6), dv(6)] = FrtSimulationFunction(R3cmo, R3cmf, dt6, S(5).t(end), C);

time(6) = toc;

S7_V3cm = 0.0 * S(6).V3cm(:,end);
dv(7) = norm(S7_V3cm - S(6).V3cm(:,end));

%% PLOT RESULTS:

PlotCr3bp(S,C);
% []Plots the satellite trajectory in the CR3BP system.

PlotRange(S)

PlotSpeed(S)

PlotAcceleration(S, C)

PlotJacobiConstant(S, C)

dvTotal = sum(dv);
% [km/s] Total DV

MissionSummary(S,dv)

%% PRINT SIMULATION TIME:

SimulationTime = toc;
% []Stops the program timer.

SimulationTimeString = 'Simulation Time: %0.3f seconds\n';
% []Formatted string.

fprintf(SimulationTimeString,SimulationTime);
% []Prints the simulation time on the command window.

fprintf(Equal)

%===================================================================================================

