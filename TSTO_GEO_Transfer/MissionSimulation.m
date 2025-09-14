tic;
% [s]Starts the program timer.

clc;
% []Clears the command window.

clear;
% []Clears the variable workspace.

format('Compact');
% []Formats the command window to single-spaced output.

format('LongG');
% []Formats the command window output to display 16 digits for double-precision variables.

close('All');
% []Closes all figures.

currentFolder = fileparts(mfilename('fullpath'));
% [] Saves current directiory location

CodePath = fullfile(currentFolder, '..', 'Mission');
% [] Finds path towards different folder to use software

addpath(CodePath);
% [] Adds path

Equal = strcat(repelem('=',100),'\n');
% [string]Generates a string with 100 equal signs and a carriage return.

Dash = strcat(repelem('-',100),'\n');
% [string]Generates a string with 100 dash signs and a carriage return.

fprintf('Begin Simulation...\n');
% []Prints the formatted string on the command window.

fprintf(Equal);
% []Prints the formatted string on the command window.

%% CONSTANTS AND GIVEN QUANTITIES:

[C,S,dv] = R2bpConstants;
% []Loads the parameters for the mission simulation.

%% SEGMENT 2 -- JUPITER PROPAGATION DURING LAUNCH:

to = [0, S.t(end)];
% [s]Modeling time.

So = C.SJo;
% [km,km/s]JUPITER state WRT the Earth in ECI coordinates at mission commencement.

S(2) = R2bpPropagate(to,So,C);
% []Propagates the relative two-body problem.

%% SEGMENT 3 -- LEXICON LOITER:

[H1,H2,Lambda,dt] = Segment3Design(S,C);
% [s]Lexicon loiter time of flight desgin.

to = [S(1).t(end), S(1).t(end) + dt];
% [s]Modeling time.

So = S(1).S(:,end);
% [km,km/s]Lexicon state WRT the Earth in ECI coordinates at orbit insertion.

S(3) = R2bpPropagate(to,So,C);
% []Propagates the relative two-body problem.

%% SEGMENT 4 -- JUPITER PROPAGATION DURING LEXICON LOITER:

to = [S(2).t(end),S(2).t(end) + dt];
% [s]Modeling time.

So = S(2).S(:,end);
% [km,km/s]JUPITER state WRT the Earth in ECI coordinates at Lexicon orbit insertion.

S(4) = R2bpPropagate(to,So,C);
% []Propagates the relative two-body problem.

%% SEGMENT 5 -- LEXICON NONPLANAR HOHMANN TRANSFER:

[theta2,V2plus,HT] = Segment5Design(S,C,H1,H2,Lambda);
% []Lexicon nonplanar Hohmann transfer design.

to = [S(3).t(end), S(3).t(end) + HT.dt];
% [s]Modeling time.

So = S(3).S(:,end);
% [km,km/s]Lexicon state WRT the Earth in ECI coordinates at nonplanar Hohmann transfer
% commencement.

So(4:6) = HT.V1plus;
% [km/s]Lexicon nonplanar Hohmann transfer departure velocity.

S(5) = R2bpPropagate(to,So,C);
% []Propagates the relative two-body problem.

%% SEGMENT 6 -- JUPITER PROPAGATION DURING LEXICON NONPLANAR HOHMANN TRANSFER:

to = [S(4).t(end),S(4).t(end) + HT.dt];
% [s]Modeling time.

So = S(4).S(:,end);
% [km,km/s]JUPITER state WRT the Earth in ECI coordinates at Lexicon nonplanar Hohmann transfer commencement.

S(6) = R2bpPropagate(to,So,C);
% []Propagates the relative two-body problem.

%% SEGMENT 7 -- LEXICON PHASING MANEUVER:

dVh = V2plus - HT.V2minus;
% [km/s]Delta-v required to place Lexicon into the JUPITER orbit.

PM = Segment7Design(S,C,theta2,V2plus);
% []Lexicon phasing maneuver design.

to = [S(5).t(end),S(5).t(end) + PM.dtm];
% [s]Modeling time.

So = S(5).S(:,end);
% [km,km/s]Lexicon state WRT the Earth in ECI coordinates at phasing maneuver commencement.

So(4:6) = So(4:6) + dVh + PM.dVp;
% [km/s]Lexicon velocity correction WRT the Earth in ECI coordinates at phasing maneuver commencement.

S(7) = R2bpPropagate(to,So,C);
% []Propagates the relative two-body problem.

%% SEGMENT 8 -- JUPITER PROPAGATION DURING LEXICON PHASING MANEUVER:

to = [S(6).t(end),S(6).t(end) + PM.dtm];
% [s]Modeling time.

So = S(6).S(:,end);
% [km,km/s]Lexicon state WRT the Earth in ECI coordinates at phasing maneuver commencement.

S(8) = R2bpPropagate(to,So,C);
% []Propagates the relative two-body problem.

%% SEGMENT 9 -- LEXICON RENDEZVOUS, CORRECTION MANEUVER & LOITER

So = S(7).S(:,end);

So(4:6) = So(4:6) - PM.dVp;

to = [S(7).t(end),S(7).t(end) + 24 * 60^2];

S(9) = R2bpPropagate(to,So,C);

%% PLOT RESULTS:

GR = [218, 165, 2] / 255;
% []Goldenrod RGB color code.

FB = [178, 34, 34] / 255;
% []Firebrick RGB color code.

OrbitColor = {GR,GR,FB,FB,GR ,GR, FB, FB, GR, GR};
% []Segment color code.

CoeColor = {GR,GR,FB,FB,GR ,GR, FB, FB, GR, GR};
% []Classical orbital elements color code.

PlotOrbit(S,'Black',OrbitColor);
% []Plots the orbit WRT the Earth in three dimensions using an ECI coordinate system.

PlotGroundTrack(S,'Black',OrbitColor);
% []Plots the orbit's ground track.

PlotCoe(S,'Hours','Earth Radii',CoeColor);
% []Plots the orbit's classical orbital elements as a function of time.

%% MISSION SUMMARY:

dv(1) = norm(S(3).V(:,end) - S(5).V(:,1));
% [km/s]Delta-v at nonplanar Hohmann transfer departure.

dv(2) = norm(S(5).V(:,end) - S(7).V(:,1));
% [km/s]Delta-v at combined maneuver.

dv(3) = norm(S(7).V(:,end) - S(9).V(:,1));
% [km/s]Delta-v at rendezvous.

V1 = S(5).V(:,end);
% [km/s]Velocity at combined maneuver.

V2 = S(7).V(:,1);
% [km/s]Velocity after mission conclusion.

di = acosd(dot(V2,V1) / (norm(V2) * norm(V1)));
% [deg]Inclination change at combined maneuver.

MissionSummary(S,dv,di,Dash);
% []Prints the mission summary on the command \window.

%% PRINT THE SIMULATION TIME:

fprintf(Equal);
% []Prints the formatted string on the command window.

SimulationTime = toc;
% []Stops the program timer.

SimulationTimeString = 'Simulation Complete! (%0.3f seconds)\n';
% []Formatted string.

fprintf(SimulationTimeString,SimulationTime);
% []Prints the simulation time on the command window.

%===================================================================================================

