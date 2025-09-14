function BC = Cr3bpBoundaryConditions(S3cmo,S3cmf,R3cmo,R3cmf)
    
    BC = [S3cmo(1:3) - R3cmo; S3cmf(1:3) - R3cmf];
    %[km]Cr3bp boundary conditions.
    
end
%===================================================================================================