tic;
% [s]Starts the program timer.

clc;
% []Clears the command window.

clear;
% []Clears the variable workspace.

format('Compact');
% []Makes the command window output single-spaced.

format('LongG');
% []Displays 16 digits for all command window output.

close('All');
% []Closes all figures.

currentFolder = fileparts(mfilename('fullpath'));
% [] Saves current directiory location

CodePath = fullfile(currentFolder, '..', 'SourceCode');
% [] Finds path towards different folder to use software

addpath(CodePath);
% [] Adds path

Equal = strcat(repelem('=',100),'\n');
% []Formatted string with 100 equal signs and a carriage return.

Dash = strcat(repelem('-',100),'\n');
% []Formatted string with 100 equal signs and a carriage return.

String = 'Predicted Optimal Trajectory Parameters:\n';
% []Formatted string.

fprintf(String);
% []Prints the formatted string on the command window.

fprintf(Equal);
% []Prints the formatted string on the command window.

%% CONSTANTS:

C = NbpConstants;
% []Loads the Nbp constants.

Gms = C.Gm(1);
% [km^3/s^2]Gravitational parameter of the Sun.

Gm1 = C.Gm(2);
% [km^3/s^2]Gravitational parameter of the Earth.

rp1 = C.rpe;
% [km]Circular parking orbit radius WRT the Earth.

vp1 = C.vpe;
% [km/s]Circular parking orbit speed WRT the Earth.

%% DATA PREPARATION:

dx = 1000;
% []Departure date grid density.

dy = 1000;
% []Arrival date grid density.

dv = nan * ones(dy,dx);
% []Allocates memory for the total delta-v matrix.

dt = nan * ones(dy,dx);
% []Allocates memory for the time of flight matrix.

%---------------------------------------------------------------------------------------------------

JDx = C.JDo + linspace(20,200,dx);
% [solar days]Departure Julian dates.

JDy = C.JDo + linspace(300,3000,dy);
% [solar days]Arrival Julian dates.

for x = 1:dx

    for y = 1:dy

        tof = JDy(y) - JDx(x);
        % [solar days]Time of flight.

        if (tof <= 0)

            continue;
            % []Continue to the next iteration.

        else

            dt(y,x) = tof * 86400;
            % [s]Store the time of flight in seconds.

        end

    end

end

%---------------------------------------------------------------------------------------------------

S1cmx = transpose(interp1(C.Sun.JD,transpose(C.Sun.S),JDx,'Spline'));
% [km,km/s]Sun states WRT the CM in ECI coordinates based on departure dates.

Sccm = transpose(interp1(C.Earth.JD,transpose(C.Earth.S),JDx,'Spline'));
% [km,km/s]Earth states WRT the CM in ECI coordinates based on departure dates.

Sc1 = Sccm - S1cmx;
% [km,km/s]Earth states WRT the Sun in ECI coordinates based on departure dates.

%---------------------------------------------------------------------------------------------------

S1cmy = transpose(interp1(C.Sun.JD,transpose(C.Sun.S),JDy,'Spline'));
% [km,km/s]Sun states WRT the CM in ECI coordinates based on arrival dates.

Stcm = transpose(interp1(C.Jupiter.JD,transpose(C.Jupiter.S),JDy,'Spline'));
% [km,km/s]Jupiter states WRT the CM in ECI coordinates based on arrival dates.

St1 = Stcm - S1cmy;
% [km,km/s]Jupiter states WRT the Sun in ECI coordinates based on arrival dates.

%% ALGORITHM:

parfor x = 1:dx
    
    R1 = Sc1(1:3,x);
    % [km]Departure position WRT the Sun in ECI coordinates.
    
    V1minus = Sc1(4:6,x);
    % [km/s]Velocity WRT the Sun in ECI coordinates before the departure burn.
    
    Rsoi1 = norm(R1) * (Gm1 / Gms)^(2 / 5);
    % [km]Radius of the Earth's sphere of influence.
    
    for y = 1:dy

        if (dt(y,x) <= 0)

            continue;
            % []Continue to the next iteration.

        end
        
        R2 = St1(1:3,y);
        % [km]Arrival position WRT the Sun in ECI coordinates.
        
        [V1plus,~] = LambertTd(R1,R2,dt(y,x),Gms,'Prograde');
        % [km/s]Departure and arrival velocities WRT the Sun in ECI coordinates.
        
        %-------------------------------------------------------------------------------------------
        
        vinf1 = norm(V1plus - V1minus);
        % [km/s]Hyperbolic excess speed.
        
        v1plus = sqrt(vinf1^2 + 2 * Gm1 / rp1 - 2 * Gm1 / Rsoi1);
        % [km/s]Departure speed WRT the Earth.
        
        dv(y,x) = abs(v1plus - vp1);
        % [km/s]Departure delta-v.

    end
    
end

%% PORKCHOP PLOT:

CutOff = 7.1;
% [km/s]Delta-v cutoff.

PlotPorkChop(JDx,JDy,dv,C,CutOff);
% []Plots the pork chop plot.

save('EarthJupiterPorkChopData.mat','JDx','JDy','dv','dt');
% []Saves the porkchop data.

%% OPTIMAL TRAJECTORY PARAMETERS:

RowOffSet = 0;
% []Arrival offset.

ColumnOffSet = 0;
% []Departure offset.

Value = min(dv,[],'All');
% [km/s]Minimum delta-v.

[Row,Column] = find(dv == Value);
% []Row and column where the minimum delta-v occurs.

Row = Row + RowOffSet;
% []Adjusted arrival index.

Column = Column + ColumnOffSet;
% []Adjusted departure index.

Optimal.dv = dv(Row,Column);
% []Delta-v for the adjusted departure and arrival.

Optimal.dt = dt(Row,Column);
% [s]Optimal time of flight.

R1 = Sc1(1:3,Column);
% [km]Departure position WRT the Sun in ECI coordinates.

V1minus = Sc1(4:6,Column);
% [km/s]Velocity WRT the Sun in ECI coordinates before the departure burn.

R2 = St1(1:3,Row);
% [km]Arrival position WRT the Sun in ECI coordinates.

[V1plus,~] = LambertTd(R1,R2,dt(Row,Column),Gms,'Prograde');
% [km/s]Departure and arrival velocities WRT the Sun in ECI coordinates.

Vinf1 = V1plus - V1minus;
% [km/s]Hyperbolic excess velocity WRT the Earth in ECI coordinates.

vinf1 = norm(Vinf1);
% [km/s]Hyperbolic excess speed.

Uhat = cross(R1,Vinf1) / norm(cross(R1,Vinf1));
% []Rotation axis.

e = 1 + rp1 * dot(Vinf1,Vinf1) / Gm1;
% []Departure hyperbola eccentricity.

beta = acos(1 / e);
% [rad]Turn angle.

Phat = -Rotation(Uhat,beta,'Radians') * Vinf1 / vinf1;
% []Departure hyperbola periapsis direction in ECI coordinates.

Qhat = Rotation(Uhat,pi / 2,'Radians') * Phat;
% []Deparature hyperbola departure direction in ECI coordinates.

Rsate = rp1 * Phat;
% [km]Satellite position WRT the Earth in ECI coordinates at departure.

Vsate = (C.vpe + Optimal.dv) * Qhat;
% [km/s]Satellite velocity WRT the Earth in ECI coordinates at departure.

Optimal.Rsatcm = Sccm(1:3,Column) + Rsate;
% [km]Satellite position WRT the CM in ECI coordinates at departure.

Optimal.Vsatcm = Sccm(4:6,Column) + Vsate;
% [km/s]Satellite velocity WRT the CM in ECI coordinates at departure.

Optimal.Rtcm = Stcm(1:3,Row);
% [km]Jupiter position WRT the CM in ECI coordinates at arrival.

Optimal.JD = JDx(Column);
% [solar days]Departure Julian date.

Optimal = orderfields(Optimal,{'JD','Rsatcm','Vsatcm','Rtcm','dv','dt'});
% []Reorders the optimal parameters fields.

save('EarthJupiterOptimalParameters.mat','Optimal');
% []Saves the optimal trajectory parameters.

%% PRINT RESULTS:

String = { ...
    'Departure UTC: %4.0f:%02.0f:%02.0f:%02.0f:%02.0f:%02.0f\n'; ...
    'Arrival UTC: %4.0f:%02.0f:%02.0f:%02.0f:%02.0f:%02.0f\n'}; ...
    '\x0394v = %0.3f km/s\n'; ...
    '\x0394t = %0.3f days\n'; ...
% []Formatted string.

UTCo = datetime(Optimal.JD,'ConvertFrom','JulianDate','Format','yyyy:MM:dd:HH:mm:ss');
% []Departure UTC as a datetime value.

UTCo = datevec(UTCo);
% [yyyy,MM,dd,HH,mm,ss]Departure UTC.

UTCf = datetime( ...
    Optimal.JD + Optimal.dt / 86400,'ConvertFrom','JulianDate','Format','yyyy:MM:dd:HH:mm:ss');
% []Arrival UTC as a datetime value.

UTCf = datevec(UTCf);
% [yyyy,MM,dd,HH,mm,ss]Arrival UTC.

Result = {UTCo; Optimal.dv; Optimal.dt / 86400; UTCf};
% []Results cell.

for k = 1:4

    fprintf(String{k},Result{k});
    % []Prints the formatted string on the command window.

    if k < 4

        fprintf(Dash);
        % []Prints the formatted string on the command window.

    end

end

%% PRINT SIMULATION TIME:

fprintf(Equal);
% []Prints the formatted string on the command window.

SimTime = toc;
% []Stops the program timer.

SimTimeStr = 'Simulation Time: %.0f minutes %0.3f seconds\n';
% []Formatted string.

fprintf(SimTimeStr,floor(SimTime / 60), mod(SimTime, 60));
% []Prints the simulation time on the command window.
%===================================================================================================   