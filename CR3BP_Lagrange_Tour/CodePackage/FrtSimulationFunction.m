function [S, dvSum] = FrtSimulationFunction(R3cmo, R3cmf, dt, ti, C)
%% MODELING TIME AND INITIAL GUESS:
    
to = linspace(0,dt,10);
% [s]Modeling time.

InitialGuess = bvpinit(to,C.r12*ones(1,6));
% [km,km/s]Initial guess matrix.

%% NUMERICAL INTEGRATION:

Solution = bvp4c( ...
    @(t,S)Cr3bpEom(t,S,C), ...
    @(S3cmo,S3cmf)Cr3bpBoundaryConditions(S3cmo,S3cmf,R3cmo,R3cmf), ...
    InitialGuess, ...
    C.BvpOptions);
% [s,km,km/s]Numerically integrates the CR3BP as a boundary value problem.

%% TRAJECTORY PROPAGATION:

to = [ti + Solution.x(1), ti + Solution.x(end) * 1];
% [s]Modeling time update.

So = Solution.y(:,1);
% [km,km/s]Initial state.

S = Cr3bpPropagate(to,So,C);
% []Propagates the CR3BP.

%% DELTA-V CALCULATIONS:

dv = DeltaV(S,C);
% [km/s]Delta-v required by each burn.

dvSum = sum(dv); % [km/s]Mission delta-v.

end