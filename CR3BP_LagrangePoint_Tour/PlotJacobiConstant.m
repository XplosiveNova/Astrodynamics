function PlotJacobiConstant(S, C)

    FB = [178, 34, 34] / 255;

    OrbitColor = {'k',FB,'k', FB, 'k', FB};

    n = numel(S);
    % []Number of elements in the time vector.

    for k = 1:n

        len = length(S(k).t);

        % a3cm(k).A = zeros(3,len);

        for j = 1:len
            
            x = S(k).R3cm(1,j);

            y = S(k).R3cm(2,j);

            R3cm = S(k).R3cm(:,j);

            V3cm = S(k).V3cm(:,j);

            R31 = R3cm - C.R1cm;
            
            R32 = R3cm - C.R2cm;
            
            r31 = norm(R31);
            
            r32 = norm(R32);

            v3cm = norm(V3cm);
            
            JC(k).J(j) = .5 * v3cm^2 - .5 * C.wcm^2 * (x^2 + y^2) - C.Gm(1)/r31 - C.Gm(2)/r32;
            % [gals] Acceleration of Satellite towards CM of CR3BP

        end

    end

    %-----------------------------------------------------------------------------------------------

    Window = figure( ...
        'Color','w', ...
        'Name','Jacobi Constant Analysis', ...
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
        'YLim',[-2,2], ...
        'XTick',linspace(0,30,16), ...
        'YTick',linspace(-2,2,11));
    % []Adds an axes to the specified window and adjusts its properties.

    title( ...
        'Jacobi Constant Analysis', ...
        'FontSize',20, ...
        'Parent',Axes);
    % []Adds a title to the specified axes and adjusts its properties.

    xlabel( ...
        'Time (Solar Days)', ...
        'FontSize',16, ...
        'Parent',Axes);
    % []Adds a label to the specified x-axis and adjusts its properties.

    ylabel( ...
        'Jacobi Constant (MJ/kg)', ...
        'FontSize',16, ...
        'Parent',Axes);
    % []Adds a label to the specified y-axis and adjusts its properties.

    %-----------------------------------------------------------------------------------------------

    for k = 1:n

        plot(S(k).t / 3600 / 24, JC(k).J, ...
            'Color',OrbitColor{k}, ...
            'LineStyle','-', ...
            'Marker','.', ...
            'Parent',Axes);
        % []Adds a plot to the specified axes and adjusts its properties.
    
        hold on

    end


end