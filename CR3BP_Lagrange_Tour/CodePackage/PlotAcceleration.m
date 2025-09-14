function PlotAcceleration(S, C)

    FB = [178, 34, 34] / 255;

    OrbitColor = {'k',FB,'k', FB, 'k', FB};

    n = numel(S);
    % []Number of elements in the time vector.

    for k = 1:n

        len = length(S(k).t);

        % a3cm(k).A = zeros(3,len);

        for j = 1:len
            
            R3cm = S(k).R3cm(:,j);

            R31 = R3cm - C.R1cm;
            
            R32 = R3cm - C.R2cm;
            
            r31 = norm(R31);
            
            r32 = norm(R32);
            
            G31 = -C.Gm(1) * R31 / r31^3;
            
            G32 = -C.Gm(2) * R32 / r32^3;
            
            a3cm(k).A(j) = norm(G31 + G32) * 1000 * 100;
            % [gals] Acceleration of Satellite towards CM of CR3BP

        end

    end

    %-----------------------------------------------------------------------------------------------

    Window = figure( ...
        'Color','w', ...
        'Name','Acceleration Analysis', ...
        'NumberTitle','Off');
    % []Opens a new window and adjusts its properties.

    %-----------------------------------------------------------------------------------------------

    Axes = axes( ...
        'FontName','Arial', ...
        'FontSize',12, ...
        'FontWeight','Bold', ...
        'NextPlot','Add', ...
        'Parent',Window, ...
        'XGrid','On', ...
        'YGrid','On', ...
        'XLim',[0, 30], ...
        'YLim',[0,1000], ...
        'XTick',linspace(0,30,16), ...
        'YTick',linspace(0,1000,11));
    % []Adds an axes to the specified window and adjusts its properties.

    title( ...
        'Acceleration Analysis', ...
        'FontSize',20, ...
        'Parent',Axes);
    % []Adds a title to the specified axes and adjusts its properties.

    xlabel( ...
        'Time (Solar Days)', ...
        'FontSize',16, ...
        'Parent',Axes);
    % []Adds a label to the specified x-axis and adjusts its properties.

    ylabel( ...
        'Acceleration (Gals)', ...
        'FontSize',16, ...
        'Parent',Axes);
    % []Adds a label to the specified y-axis and adjusts its properties.

    %-----------------------------------------------------------------------------------------------

    for k = 1:n

        plot(S(k).t / 3600 / 24, a3cm(k).A, ...
            'Color',OrbitColor{k}, ...
            'LineStyle','-', ...
            'Marker','.', ...
            'Parent',Axes);
        % []Adds a plot to the specified axes and adjusts its properties.
    
        hold on

    end


end