function PlotPorkChop(JDx,JDy,dv,C,CutOff)

    Value = min(dv,[],'All');
    % [km/s]Minimum delta-v.

    %-----------------------------------------------------------------------------------------------

    n = numel(dv);
    % []Number of elements in the delta-v matrix.

    for k = 1:n

        if dv(k) > CutOff

            dv(k) = nan;
            % []Ignores the delta-v value if it is less than the cutoff value.

        end

    end

    %-----------------------------------------------------------------------------------------------
    
    ScreenSize = get(0,'ScreenSize');
    % []Determines the location and dimensions of the current monitor.
    
    Window = figure( ...
        'Color','w', ...
        'Name',C.String.Name, ...
        'NumberTitle','Off', ...
        'OuterPosition',ScreenSize');
    % []Opens a new window and adjusts its properties.
    
    %-----------------------------------------------------------------------------------------------
    
    s = size(dv);
    % []Dimensions of the delta-v matrix.
    
    dx = s(2);
    % []Dimensions of the x-axis.
    
    dy = s(1);
    % []Dimensions of the y-axis.

    XLim = [JDx(1),JDx(end)] - C.JDo;
    % [solar days]X-axis limits.

    YLim = [JDy(1),JDy(end)] - C.JDo;
    % [solar days]Y-axis limits.
    
    Axes = axes( ...
        'FontName','Arial', ...
        'FontSize',12, ...
        'FontWeight','Bold', ...
        'NextPlot','Add', ...
        'Parent',Window, ...
        'XGrid','On', ...
        'YGrid','On', ...
        'XLim',XLim, ...
        'YLim',YLim, ...
        'XTick',linspace(XLim(1),XLim(2),11), ...
        'YTick',linspace(YLim(1),YLim(2),11));
    % []Adds an axes to the specified window and adjusts its properties.
    
    title( ...
        C.String.Title, ...
        'FontSize',20, ...
        'Parent',Axes);
    % []Adds a title to the specified axes and adjusts its properties.
    
    xlabel( ...
        C.String.Departure, ...
        'FontSize',16, ...
        'Parent',Axes);
    % []Adds a label to the specified x-axis and adjusts its properties.
    
    ylabel( ...
        C.String.Arrival, ...
        'FontSize',16, ...
        'Parent',Axes);
    % []Adds a label to the specified y-axis and adjusts its properties.
    
    %-----------------------------------------------------------------------------------------------

    Minimum = min(dv,[],'All');
    % [km/s]Minimum depature delta-v.
    
    Maximum = max(dv,[],'All');
    % [km/s]Maximum departure delta-v.

    Bottom = floor(Minimum);
    % []Lower colorbar limit.
    
    Top = 7.2;
    % []Upper colorbar limit.
    
    Extent = linspace(Bottom,Top,13);
    % []Colorbar tick mark locations.
    
    contour( ...
        linspace(XLim(1),XLim(2),dx),linspace(YLim(1),YLim(2),dy),dv, ...
        'LabelFormat','%0.1f', ...
        'Parent',Axes, ...
        'ShowText','On');
    % []Adds contour plot to the specified axes and adjusts its properties.
    
    CB = colorbar(Axes, ...
        'Limits',[Bottom,Top], ...
        'Ticks',Extent);
    % []Adds a colorbar to the contour plot and adjusts its properties.

    CB.Label.String = '\Deltav (km/s)';
    % []Sets the colorbar label.
    
    colormap('Jet');
    % []Sets the contour plot line color scheme.

    %-----------------------------------------------------------------------------------------------

    [Row,Column] = find(dv == Value);
    % []Row and column where the minimum delta-v occurs.

    x = JDx(Column) - C.JDo;
    % []X-coordinate.

    y = JDy(Row) - C.JDo;
    % []Y-coordinates.

    plot3(x,y,Value, ...
        'Color', 'k', ...
        'LineStyle','None', ...
        'Marker','.', ...
        'MarkerSize',25, ...
        'Parent',Axes);
    % []Plots the minimum delta-v on the porkchop plot.
    
    %-----------------------------------------------------------------------------------------------
    
    savefig(C.String.FileName);
    % []Saves the porkchop plot as a figure file.
    
end
%===================================================================================================