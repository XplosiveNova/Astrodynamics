function BC = NbpBoundaryConditions(So,Sf,Ro,Rf)
    
    BC = [So(1:3) - Ro; Sf(1:3) - Rf];
    %[km]Ten-body problem boundary conditions.
    
end
%===================================================================================================