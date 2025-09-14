function plot_lift(Mach_Values, G)

    % USED FOR PROBLEM 4.2

    n = 16;
    AOA_range = linspace(0, 15, n); % [deg] AOA Range
    Graph_Matrix = zeros(n+1,2);
    colors = ['r', 'b'];
    j = 1;

    for Mach = Mach_Values

        i = 1;

        for AOA = AOA_range
            
            if Mach <= 1
                [CL, ~] = compute_subsonic_CL(Mach, AOA, G);
            else
                [CL, ~] = compute_supersonic_CL(Mach, AOA, G);
            end
            
            Graph_Matrix(i,1) = AOA;
            Graph_Matrix(i,2) = CL;
                
            i = i+1;
        end

        figure(2)
        plot(Graph_Matrix(:,1), Graph_Matrix(:,2), 'LineStyle','none', 'Marker', '.', 'MarkerSize', 16, 'Color', colors(j))
        hold on
        j = j+1;
    end

    title('C_L vs {\alpha}', "FontSize", 20, 'FontWeight', 'bold', 'FontName', 'Arial')
    xlabel("{\alpha} _{(deg)}", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
    xlim([0, n])
    xticks(0:1:n)
    ylabel("C_L", "FontSize", 16, 'FontWeight', 'bold', 'FontName', 'Arial')
    ylim([0, 1.5])
    yticks(0:.125:1.5)
    grid on
    

end