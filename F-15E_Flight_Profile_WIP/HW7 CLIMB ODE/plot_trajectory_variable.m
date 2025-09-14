function plot_trajectory_variable(x, y, xaxis_label, yaxis_label, xlim_vals, ylim_vals, xprecision, yprecision)
   
    format long

    % Color palette similar to seaborn's "colorblind" and "hls"
    colors = lines(20); % MATLAB's default color palette has 7 colors, using 'lines' function for up to 20.
    
    % Define line styles
    linestyles = {'-', '--', ':', '-.', '--', ':', '-', '-.'};
    % Figure parameters
    fig_width = 3.25; % Width in inches
    fig_height = 3.5; % Height in inches
    markersize = 2; % Marker size
    marker_linewidth = 0.5; % Marker edge width
    % Font and general plot settings
    set(0, 'DefaultLineLineWidth', 0.5); % Set default line width
    set(0, 'DefaultAxesFontSize', 8); % Set font size for axes
    set(0, 'DefaultAxesFontName', 'Times New Roman'); % Set font family for axes
    % Create figure with specific size
    figure('Position', [100, 100, fig_width*100, fig_height*100]);
    hold on;
    % Plot line and scatter
    color_selection = colors(1, :); % Select first color from palette
    plot(x, y, 'Color', color_selection, 'LineStyle', linestyles{1}, 'LineWidth', 0.5);
    scatter(x, y, markersize, 'MarkerEdgeColor', color_selection, 'MarkerFaceColor', 'w', 'LineWidth', marker_linewidth);
    % Set axis labels
    xlabel(xaxis_label);
    ylabel(yaxis_label);
    % Set x and y limits if provided
    if ~isempty(xlim_vals)
    xlim(xlim_vals);
    end
    if ~isempty(ylim_vals)
    ylim(ylim_vals);
    end
    % Custom x-axis precision
    if ~isempty(xprecision)
    xtickformat(xprecision);
    else
    xtickformat('%.0f'); % Default format for x-axis
    end
    % Custom y-axis precision
    if ~isempty(yprecision)
    ytickformat(yprecision);
    else
    ytickformat('%.0f'); % Default format for y-axis
    end
    % Minor ticks and grid
    grid on;
    set(gca, 'MinorGridLineStyle', '-', 'GridAlpha', 0.15, 'MinorGridAlpha', 0.15);
    grid minor;
    % Adjust plot layout
    set(gca, 'Layer', 'bottom');
    
    hold off;
end