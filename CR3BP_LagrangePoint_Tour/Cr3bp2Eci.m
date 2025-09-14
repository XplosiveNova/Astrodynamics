function [R31,V31,S31] = Cr3bp2Eci(t,S3cm,C)

    n = numel(t);
    %[]Number of elements in the time vector.

    %-----------------------------------------------------------------------------------------------
    
    R3cm = S3cm(1:3,:);
    %[km]Satellite relative positions WRT the CM in CR3BP coordinates.
    
    V3cm = S3cm(4:6,:);
    %[km/s]Satellite relative velocities WRT the CM in CR3BP coordinates.

    %-----------------------------------------------------------------------------------------------
    
    R31 = zeros(3,n);
    %[]Allocates memory for the satellite positions WRT the Earth in ECI coordinates.
    
    V31 = zeros(3,n);
    %[]Allocates memory for the satellite velocities WRT the Earth in ECI coordinates.

    %-----------------------------------------------------------------------------------------------
    
    for k = 1:n
        
        R = R3cm(:,k) - C.R1cm;
        %[km]Satellite position WRT the Earth in CR3BP coordinates.
        
        V = V3cm(:,k) - C.V1cm + cross(C.Wcm,R3cm(:,k));
        %[km/s]Satellite velocity WRT the Earth in CR3BP coordinates.
        
        RotMat = Rotation(C.khat,C.wcm * t(k),'Radians');
        %[]Rotation matrix used to update ihat and jhat.
        
        ihat = RotMat * C.ihato;
        %[]Updated ihat vector in ECI coordinates.
        
        jhat = RotMat * C.jhato;
        %[]Update jhat vector in ECI coordinates.
        
        Cr3bpToEci = [ihat, jhat, C.khat];
        %[]Matrix that transforms vectors from CR3BP coordinates to ECI coordinates.
        
        R31(:,k) = Cr3bpToEci * R;
        %[km]Satellite position WRT the Earth in ECI coordinates.
        
        V31(:,k) = Cr3bpToEci * V;
        %[km/s]Satelliite velocity WRT the Earth in ECI coordinates.
        
    end

    S31 = [R31; V31];
    %[km,km/s]Satellite states WRT the Earth in ECI coordinates.
    
end
%===================================================================================================   