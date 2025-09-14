function plot_lift_curve_slope(AOA, G)

    % USED FOR PROBLEM 4.1

    AOA = AOA * pi / 180;   % [rad] Angle of Attack 
    n = 2000;
    Mach_range = linspace(0, 4, n);
    Graph_Matrix = zeros(n+1,2);
    i = 1;

    for Mach = Mach_range
        
        if Mach <= 0.9
            [~, CLA] = compute_subsonic_CL(Mach, AOA, G);
        elseif 0.9 < Mach && Mach <= 1.3
            [~, CLA] = compute_transonic_CL(Mach, AOA, G);
        else
            [~, CLA] = compute_supersonic_CL(Mach, AOA, G);
        end
        
        Graph_Matrix(i,1) = Mach;
        Graph_Matrix(i,2) = CLA * pi/180;
            
        i = i+1;
    end
    
    figure(1)
    plot(Graph_Matrix(:,1), Graph_Matrix(:,2), 'LineStyle','none', 'Marker', '.', 'MarkerSize', 6, 'Color', 'k')
    title('C_{L_{\alpha}} vs Mach Number', "FontSize", 20, 'FontWeight', 'bold', 'FontName', 'Arial')
    xlabel("Mach Number", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
    xlim([0, 4])
    xticks(0:.25:4)
    ylabel("C_{L_{\alpha}} _{(rad^{-1})}", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
    ylim([0, .1])
    yticks(0:.01:.1)
    grid on
    theme 'light'

end