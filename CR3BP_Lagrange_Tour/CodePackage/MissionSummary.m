function MissionSummary(S,dv)

    Equal = strcat(repelem('=',100),'\n');
    % []Formatted string with 100 equal signs and a carriage return.

    Dash = strcat(repelem('-',100),'\n');
    % []Formatted string with 100 dash signs and a carriage return.

    fprintf(Equal)
    fprintf("MISSION SUMMARY\n")
    fprintf(Dash)

    String = strcat( ...
        '(1) Earth Departure:\n', ...
        '    UTC = %4.0f:%02.0f:%02.0f:%02.0f:%02.0f:%02.0f\n', ...
        '    EMT = %02.0f:%02.0f:%02.0f:%02.0f\n', ...
        '     \x0394v = %0.3f km/s\n');
    % []Formatted string.

    EMT = Sec2Dhms(S(1).t(1));
    % [days,hours,minutes,seconds]Elapsed mission time.

    fprintf(String, ...
        S(1).UTC(1,:), ...
        EMT, ...
        dv(1));
    % []Prints the formatted string on the command window.

    fprintf(Dash);
    % []Prints the formatted string on the command window.

    %-----------------------------------------------------------------------------------------------

    String = strcat( ...
        '(2) Lunar Dark Side Arrival:\n', ...
        '    UTC = %4.0f:%02.0f:%02.0f:%02.0f:%02.0f:%02.0f\n', ...
        '    EMT = %02.0f:%02.0f:%02.0f:%02.0f\n', ...
        '     \x0394v = %0.3f km/s\n');
    % []Formatted string.

    EMT = Sec2Dhms(S(2).t(1));
    % [days,hours,minutes,seconds]Elapsed mission time.

    fprintf(String, ...
        S(2).UTC(1,:), ...
        EMT, ...
        dv(2));
    % []Prints the formatted string on the command window.

    fprintf(Dash);
    % []Prints the formatted string on the command window.

    %-----------------------------------------------------------------------------------------------

    String = strcat( ...
        '(3) L1 Arrival:\n', ...
        '    UTC = %4.0f:%02.0f:%02.0f:%02.0f:%02.0f:%02.0f\n', ...
        '    EMT = %02.0f:%02.0f:%02.0f:%02.0f\n', ...
        '     \x0394v = %0.3f km/s\n');
    % []Formatted string.

    EMT = Sec2Dhms(S(3).t(1));
    % [days,hours,minutes,seconds]Elapsed mission time.

    fprintf(String, ...
        S(3).UTC(1,:), ...
        EMT, ...
        dv(3));
    % []Prints the formatted string on the command window.

    fprintf(Dash);
    % []Prints the formatted string on the command window.

    %-----------------------------------------------------------------------------------------------

    String = strcat( ...
        '(4) L2 Arrival:\n', ...
        '    UTC = %4.0f:%02.0f:%02.0f:%02.0f:%02.0f:%02.0f\n', ...
        '    EMT = %02.0f:%02.0f:%02.0f:%02.0f\n', ...
        '     \x0394v = %0.3f km/s\n');
    % []Formatted string.

    EMT = Sec2Dhms(S(4).t(1));
    % [days,hours,minutes,seconds]Elapsed mission time.

    fprintf(String, ...
        S(4).UTC(1,:), ...
        EMT, ...
        dv(4));
    % []Prints the formatted string on the command window.

    fprintf(Dash);
    % []Prints the formatted string on the command window.

    %-----------------------------------------------------------------------------------------------

    String = strcat( ...
        '(5) L3 Arrival:\n', ...
        '    UTC = %4.0f:%02.0f:%02.0f:%02.0f:%02.0f:%02.0f\n', ...
        '    EMT = %02.0f:%02.0f:%02.0f:%02.0f\n', ...
        '     \x0394v = %0.3f km/s\n');
    % []Formatted string.

    EMT = Sec2Dhms(S(5).t(1));
    % [days,hours,minutes,seconds]Elapsed mission time.

    fprintf(String, ...
        S(5).UTC(1,:), ...
        EMT, ...
        dv(5));
    % []Prints the formatted string on the command window.

    fprintf(Dash);
    % []Prints the formatted string on the command window.

        %-----------------------------------------------------------------------------------------------

    String = strcat( ...
        '(6) L4 Arrival:\n', ...
        '    UTC = %4.0f:%02.0f:%02.0f:%02.0f:%02.0f:%02.0f\n', ...
        '    EMT = %02.0f:%02.0f:%02.0f:%02.0f\n', ...
        '     \x0394v = %0.3f km/s\n');
    % []Formatted string.

    EMT = Sec2Dhms(S(6).t(1));
    % [days,hours,minutes,seconds]Elapsed mission time.

    fprintf(String, ...
        S(6).UTC(1,:), ...
        EMT, ...
        dv(6));
    % []Prints the formatted string on the command window.

    fprintf(Dash);
    % []Prints the formatted string on the command window.
    
            %-----------------------------------------------------------------------------------------------

        String = strcat( ...
        '(7) L5 Arrival:\n', ...
        '    UTC = %4.0f:%02.0f:%02.0f:%02.0f:%02.0f:%02.0f\n', ...
        '    EMT = %02.0f:%02.0f:%02.0f:%02.0f\n', ...
        '     \x0394v = %0.3f km/s\n');
    % []Formatted string.

    EMT = Sec2Dhms(S(6).t(end));
    % [days,hours,minutes,seconds]Elapsed mission time.

    fprintf(String, ...
        S(6).UTC(end,:), ...
        EMT, ...
        dv(7));
    % []Prints the formatted string on the command window.

    fprintf(Dash);
    % []Prints the formatted string on the command window.

            %-----------------------------------------------------------------------------------------------

    fprintf('Total Delta-V = %.3f km/s\n'. sum(dv));

    fprintf(Dash);
    % []Prints the formatted string on the command window.

end
%===================================================================================================