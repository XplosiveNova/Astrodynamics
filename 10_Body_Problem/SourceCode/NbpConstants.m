function C = NbpConstants

    C.UTCo = [2031, 1, 1, 0, 0, 0];
    % [yyyy,MM,dd,HH,mm,ss]Initial coordinated universal time.

    %-----------------------------------------------------------------------------------------------

    C.String = struct( ...
        'Name','Earth-Jupiter Launch Window', ...
        'Title','Earth-Jupiter Launch Window', ...
        'Departure','Departure (Days Since January 1, 2031)', ...
        'Arrival','Arrival (Days Since January 1, 2031)', ...
        'FileName','EarthJupiterPorkChop.fig');
    % []Plot strings.

    %-----------------------------------------------------------------------------------------------

    C.JDo = juliandate(C.UTCo);
    % [solar days]Initial Julian date.

    %-----------------------------------------------------------------------------------------------

    C.Gm = GravitationalParameters({'Sun','Earth','Moon','Mars','Jupiter','Ganymede', 'Callisto', 'Io', 'Europa'});
    % [km^3/s^2]Gravitational parameters.

    C.R = PlanetaryRadii({'Sun','Earth','Moon','Mars','Jupiter','Ganymede', 'Callisto', 'Io', 'Europa'});
    % [km]Mean equatorial radii.

    C.AU = 149597870.7;
    % [km]Astronomical unit.

    %-----------------------------------------------------------------------------------------------

    C.rpe = C.R(2) + 200;
    %[km]Parking orbit radius WRT the Earth.

    C.vpe = sqrt(C.Gm(2) / C.rpe);
    %[km/s]Parking orbit speed WRT the Earth.

    %-----------------------------------------------------------------------------------------------

    load('Sun.mat','Sun');
    load('Earth.mat','Earth');
    load('Moon.mat','Moon');
    load('Mars.mat','Mars');
    load('Jupiter.mat','Jupiter');
    load('Ganymede.mat','Ganymede');
    load('Callisto.mat','Callisto');
    load('Io.mat','Io');
    load('Europa.mat','Europa');

    %-----------------------------------------------------------------------------------------------

    C.Sun = Sun;
    C.Earth = Earth;
    C.Moon = Moon;
    C.Mars = Mars;
    C.Jupiter = Jupiter;
    C.Ganymede = Ganymede;
    C.Callisto = Callisto;
    C.Io = Io;
    C.Europa = Europa;

    %-----------------------------------------------------------------------------------------------

    C.IvpOptions = odeset('RelTol',1e-10);
    C.BvpOptions = bvpset('RelTol',1e-6);

end
%===================================================================================================