function DHMS = Sec2Dhms(t)
    
    if t < 60
        
        DHMS(1) = 0;
        %[solar days]Number of solar days.
        
        DHMS(2) = 0;
        %[hours]Number of hours.
        
        DHMS(3) = 0;
        %[minutes]Number of minutes.
        
        DHMS(4) = t;
        %[seconds]Number of seconds.
        
        return;
        
    elseif (t >= 60) && (t < 3600)
        
        DHMS(1) = 0;
        %[solar days]Number of solar days.
        
        DHMS(2) = 0;
        %[hours]Number of hours.
        
        Minutes = t / 60;
        %[minutes]Total number of minutes.
        
        DHMS(3) = fix(Minutes);
        %[minutes]Number of minutes.
        
        DHMS(4) = (Minutes - DHMS(3)) * 60;
        %[seconds]Number of seconds.
        
    elseif (t >= 3600) && (t < 86400)
        
        DHMS(1) = 0;
        %[solar days]Number of solar days.
        
        Hours = t / 3600;
        %[hours]Total number of hours.
        
        DHMS(2) = fix(Hours);
        %[hours]Number of hours.
        
        Minutes = (Hours - DHMS(2)) * 60;
        %[minutes]Total number of minutes.
        
        DHMS(3) = fix(Minutes);
        %[minutes]Number of minutes.
        
        DHMS(4) = (Minutes - DHMS(3)) * 60;
        %[seconds]Number of seconds.
        
    else
        
        SolarDays = t / 86400;
        %[solar days]Total number of solar days.
        
        DHMS(1) = fix(SolarDays);
        %[solar days]Number of solar days.
        
        Hours = (SolarDays - DHMS(1)) * 24;
        %[hours]Total number of hours.
        
        DHMS(2) = fix(Hours);
        %[hours]Number of hours.
        
        Minutes = (Hours - DHMS(2)) * 60;
        %[minutes]Total number of minutes.
        
        DHMS(3) = fix(Minutes);
        %[minutes]Number of minutes.
        
        DHMS(4) = (Minutes - DHMS(3)) * 60;
        %[seconds]Number of seconds.
        
    end
    
end
%===================================================================================================
        