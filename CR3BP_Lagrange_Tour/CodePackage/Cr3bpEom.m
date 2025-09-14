function dSdt = Cr3bpEom(~,S,C)
    
    R3cm = S(1:3);
    % [km]Satellite relative position WRT the CM in CR3BP coordinates.
    
    V3cm = S(4:6);
    % [km/s]Satellite relative velocity WRT the CM in CR3BP coordinates.

    %-----------------------------------------------------------------------------------------------
    
    R31 = R3cm - C.R1cm;
    % [km]Satellite position WRT the Earth in CR3BP coordinates.
    
    R32 = R3cm - C.R2cm;
    % [km]Satellite position WRT the Moon in CR3BP coordinates.

    %-----------------------------------------------------------------------------------------------
    
    r31 = norm(R31);
    % [km]Satellite range WRT the Earth.
    
    r32 = norm(R32);
    % [km]Satellite range WRT the Moon.

    %-----------------------------------------------------------------------------------------------
    
    G31 = -C.Gm(1) * R31 / r31^3;
    % [km/s^2]Acceleration due to Earth gravity in CR3BP coordinates.
    
    G32 = -C.Gm(2) * R32 / r32^3;
    % [km/s^2]Acceleration due to Lunar gravity in CR3BP coordinates.

    %-----------------------------------------------------------------------------------------------
    
    dSdt = zeros(6,1);
    % []Allocates memory for the state vector derivative.
    
    dSdt(1:3) = V3cm;
    % [km/s]Satelllite relative velocity WRT the CM in CR3BP coordinates.
    
    dSdt(4:6) = -cross(C.Wcm,cross(C.Wcm,R3cm)) - 2 * cross(C.Wcm,V3cm) + G31 + G32;
    % [km/s^2]Satellite relative acceleration WRT the CM in CR3BP coordinates.
    
end
%===================================================================================================