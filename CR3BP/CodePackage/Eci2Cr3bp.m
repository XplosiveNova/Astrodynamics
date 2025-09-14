function [R3cm,V3cm,S3cm] = Eci2Cr3bp(t,S31,C)
    
    n = numel(t);
    %[]Number of elements in the time vector.

    %-----------------------------------------------------------------------------------------------

    R31 = S31(1:3,:);
    % [km]Satellite positions WRT the Earth in ECI coordinates.

    V31 = S31(4:6,:);
    % [km/s]Satellite velocities WRT the Earth in ECI coordinates.

    %-----------------------------------------------------------------------------------------------
    
    R3cm = zeros(3,n);
    %[]Allocates memory for the satellite relative positions WRT the CM in CR3BP coordinates.
    
    V3cm = zeros(3,n);
    %[]Allocates memory for the satellite relative velocities WRT the CM in CR3BP coordinates.

    %-----------------------------------------------------------------------------------------------
    
    for k = 1:n
        
        RotMat = Rotation(C.khat,C.wcm * t(k),'Radians');
        %[]Rotation matrix used to update ihat and jhat.
        
        ihat = RotMat * C.ihato;
        %[]Updated ihat vector in ECI coordinates.
        
        jhat = RotMat * C.jhato;
        %[]Update jhat vector in ECI coordinates.
        
        Cr3bpToEci = [ihat, jhat, C.khat];
        %[]Matrix that transforms vectors from CR3BP coordinates to ECI coordinates.
        
        EciToCr3bp = transpose(Cr3bpToEci);
        %[]Matrix that transforms vectors from ECI coordinates to CR3BP coordinates.
        
        R = EciToCr3bp * R31(:,k);
        %[km]Satellite position WRT the Earth in CR3BP coordinates.
        
        V = EciToCr3bp * V31(:,k);
        %[km/s]Satellite velocity WRT the Earth in CR3BP coordinates.
        
        R3cm(:,k) = R + C.R1cm;
        %[km]Satellite relative position WRT the CM in CR3BP coordinates.
        
        V3cm(:,k) = V + C.V1cm - cross(C.Wcm,R3cm(:,k));
        %[km/s]Satellite relative velocity WRT the CM in CR3BP coordinates.
        
    end

    S3cm = [R3cm; V3cm];
    % [km,km/s]Satellite relative states WRT the CM in CR3BP coordinates.
    
end
%===================================================================================================