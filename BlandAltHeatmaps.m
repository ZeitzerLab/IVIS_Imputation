%% Bland Altman Heatmaps

%% Plots
isSing = 1;

ismult = 1;

isPlot_IV = 1; 
isPlot_IS = 1;
    
days_plot = 1;

fontsize = 12;
xrot = 0;
yspacing = 3;


%% Single Gap
if isSing
    load('C:\Users\Laraw\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\Imputation\impT20211112.mat')

    Days = unique(T.Day);
    Durs = unique(T.Dur);
    Starts = unique(T.StartHr);
    for i = days_plot
        linIV = [];
        miIV = [];
        linIS = [];
        miIS = [];
        maskIV = [];
        maskIS = [];
        mediIV = [];
        mediIS = [];
        
        linIVstd = [];
        miIVstd = [];
        linISstd = [];
        miISstd = [];
        maskIVstd = [];
        maskISstd = [];
        mediIVstd = [];
        mediISstd = [];
        
        linIVslope = [];
        miIVslope = [];
        linISslope = [];
        miISslope = [];
        maskIVslope = [];
        maskISslope = [];
        mediIVslope = [];
        mediISslope = [];
        for j = 1:length(Starts)
            for k = 1:length(Durs)
                ind = T.Day == Days(i) & T.Dur == Durs(k) & T.StartHr == Starts(j);
                
                % Mean
                linIV(k,j) = nanmean(T.IV_linimp(ind)-T.IV_comp(ind));
                miIV(k,j) = nanmean(T.IV_mimp(ind)-T.IV_comp(ind));
                linIS(k,j) = nanmean(T.IS_linimp(ind)-T.IS_comp(ind));
                miIS(k,j) = nanmean(T.IS_mimp(ind)-T.IS_comp(ind));
                maskIV(k,j) = nanmean(T.IV_mask(ind)-T.IV_comp(ind));
                maskIS(k,j) = nanmean(T.IS_mask(ind)-T.IS_comp(ind));
                mediIV(k,j) = nanmean(T.IV_medimp(ind)-T.IV_comp(ind));
                mediIS(k,j) = nanmean(T.IS_medimp(ind)-T.IS_comp(ind));
                
                % STD
                linIVstd(k,j) = 1.96*nanstd(T.IV_linimp(ind)-T.IV_comp(ind));
                miIVstd(k,j) = 1.96*nanstd(T.IV_mimp(ind)-T.IV_comp(ind));
                linISstd(k,j) = 1.96*nanstd(T.IS_linimp(ind)-T.IS_comp(ind));
                miISstd(k,j) = 1.96*nanstd(T.IS_mimp(ind)-T.IS_comp(ind));
                maskIVstd(k,j) = 1.96*nanstd(T.IV_mask(ind)-T.IV_comp(ind));
                maskISstd(k,j) = 1.96*nanstd(T.IS_mask(ind)-T.IS_comp(ind));
                mediIVstd(k,j) = 1.96*nanstd(T.IV_medimp(ind)-T.IV_comp(ind));
                mediISstd(k,j) = 1.96*nanstd(T.IS_medimp(ind)-T.IS_comp(ind));
                
                % Slope
                y = T.IV_linimp(ind)-T.IV_comp(ind);
                x = (T.IV_linimp(ind) + T.IV_comp(ind))./2;
                idx = ~isnan(x) & ~isnan(y);
                if sum(idx)~=0
                    p = polyfit(x(idx),y(idx),1);
                    linIVslope(k,j) = p(1);
                else
                    linIVslope(k,j) = nan;
                end

                y = T.IV_mimp(ind)-T.IV_comp(ind);
                x = (T.IV_mimp(ind)+T.IV_comp(ind))./2;
                idx = ~isnan(x) & ~isnan(y);
                if sum(idx)~=0
                    p = polyfit(x(idx),y(idx),1);
                    miIVslope(k,j) = p(1);
                else
                    miIVslope(k,j) = nan;
                end

                y = T.IS_linimp(ind)-T.IS_comp(ind);
                x = (T.IS_linimp(ind)+T.IS_comp(ind))./2;
                idx = ~isnan(x) & ~isnan(y);
                if sum(idx)~=0
                    p = polyfit(x(idx),y(idx),1);
                    linISslope(k,j) = p(1);
                else
                    linISslope(k,j) = nan;
                end

                y = T.IS_mimp(ind)-T.IS_comp(ind);
                x = (T.IS_mimp(ind)+T.IS_comp(ind))./2;
                idx = ~isnan(x) & ~isnan(y);
                if sum(idx)~=0
                    p = polyfit(x(idx),y(idx),1);
                    miISslope(k,j) = p(1);
                else
                    miISslope(k,j) = nan;
                end

                y = T.IV_mask(ind)-T.IV_comp(ind);
                x = (T.IV_mask(ind)+T.IV_comp(ind))./2;
                idx = ~isnan(x) & ~isnan(y);
                if sum(idx)~=0
                    p = polyfit(x(idx),y(idx),1);
                    maskIVslope(k,j) = p(1);
                else
                    maskIVslope(k,j) = nan;
                end

                y = T.IS_mask(ind)-T.IS_comp(ind);
                x = (T.IS_mask(ind)+T.IS_comp(ind))./2;
                idx = ~isnan(x) & ~isnan(y);
                if sum(idx)~=0
                    p = polyfit(x(idx),y(idx),1);
                    maskISslope(k,j) = p(1);
                else
                    maskISslope(k,j) = nan;
                end

                y = T.IV_medimp(ind)-T.IV_comp(ind);
                x = (T.IV_medimp(ind)+T.IV_comp(ind))./2;
                idx = ~isnan(x) & ~isnan(y);
                if sum(idx)~=0
                    p = polyfit(x(idx),y(idx),1);
                    mediIVslope(k,j) = p(1);
                else
                    mediIVslope(k,j) = nan;
                end

                y = T.IS_medimp(ind)-T.IS_comp(ind);
                x = (T.IS_medimp(ind)+T.IS_comp(ind))./2;
                idx = ~isnan(x) & ~isnan(y);
                if sum(idx)~=0
                    p = polyfit(x(idx),y(idx),1);
                    mediISslope(k,j) = p(1);
                else
                    mediISslope(k,j) = nan;
                end 
                

            end
        end

        %% IV plots
        if isPlot_IV
            figure('Renderer', 'painters', 'Position', [100 100 800 800],'Name','IV - Single Gap')
            % Mean
            iv_mm = 0.30;
            subplot(3,4,1)
            h1 = heatmap(linIV,'ColorLimits',[-iv_mm iv_mm],'Colormap',jet);
            h1.NodeChildren(3).YDir='normal';
            h1.ColorbarVisible = 'off';
            ax = gca;
            CustomYLabels = string(Durs);
            CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            s = struct(h1);
            s.XAxis.TickLabelRotation = xrot;
            ylabel('Duration [hr]')
            title('Linear')
            set(gca,'FontSize',fontsize)

            subplot(3,4,2)
            h2 = heatmap(miIV,'ColorLimits',[-iv_mm iv_mm],'Colormap',jet);
            h2.NodeChildren(3).YDir='normal';
            h2.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Durs);
            CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            title('Mean')
            set(gca,'FontSize',fontsize)
            s = struct(h2);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,3)
            h3 = heatmap(mediIV,'ColorLimits',[-iv_mm iv_mm],'Colormap',jet);
            h3.NodeChildren(3).YDir='normal';
            h3.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Durs);
            CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            title('Median')
            set(gca,'FontSize',fontsize)
            s = struct(h3);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,4)
            h4 = heatmap(maskIV,'ColorLimits',[-iv_mm iv_mm],'Colormap',jet);
            h4.NodeChildren(3).YDir='normal';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Durs);
            CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            title('Masked')
            set(gca,'FontSize',fontsize)
            s = struct(h4);
            s.XAxis.TickLabelRotation = xrot;


            % STD
            iv_mm = 1.96*0.39;
            iv_mm_l = 0;

            subplot(3,4,5)
            h1 = heatmap(linIVstd,'ColorLimits',[iv_mm_l iv_mm],'Colormap',spring);
            h1.NodeChildren(3).YDir='normal';
            h1.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Durs);
            CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            ylabel('Duration [hr]')
            set(gca,'FontSize',fontsize)
            s = struct(h1);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,6)
            h2 = heatmap(miIVstd,'ColorLimits',[iv_mm_l iv_mm],'Colormap',spring);
            h2.NodeChildren(3).YDir='normal';
            h2.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Durs);
            CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            set(gca,'FontSize',fontsize)
            s = struct(h2);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,7)
            h3 = heatmap(mediIVstd,'ColorLimits',[iv_mm_l iv_mm],'Colormap',spring);
            h3.NodeChildren(3).YDir='normal';
            h3.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Durs);
            CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            set(gca,'FontSize',fontsize)
            s = struct(h3);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,8)
            h4 = heatmap(maskIVstd,'ColorLimits',[iv_mm_l iv_mm],'Colormap',spring);
            h4.NodeChildren(3).YDir='normal';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Durs);
            CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            set(gca,'FontSize',fontsize)
            s = struct(h4);
            s.XAxis.TickLabelRotation = xrot;


            % Slope
            iv_mm = .779;
            iv_mm_l = .016;

            subplot(3,4,9)
            h1 = heatmap(linIVslope,'ColorLimits',[iv_mm_l iv_mm],'Colormap',cool);
            h1.NodeChildren(3).YDir='normal';
            h1.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Durs);
            CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            xlabel('Start Time [hr]')
            ylabel('Duration [hr]')
            set(gca,'FontSize',fontsize)
            s = struct(h1);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,10)
            h2 = heatmap(miIVslope,'ColorLimits',[iv_mm_l iv_mm],'Colormap',cool);
            h2.NodeChildren(3).YDir='normal';
            h2.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Durs);
            CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            xlabel('Start Time [hr]')
            set(gca,'FontSize',fontsize)
            s = struct(h2);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,11)
            h3 = heatmap(mediIVslope,'ColorLimits',[iv_mm_l iv_mm],'Colormap',cool);
            h3.NodeChildren(3).YDir='normal';
            h3.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Durs);
            CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            xlabel('Start Time [hr]')
            set(gca,'FontSize',fontsize)
            s = struct(h3);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,12)
            h4 = heatmap(maskIVslope,'ColorLimits',[iv_mm_l iv_mm],'Colormap',cool);
            h4.NodeChildren(3).YDir='normal';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Durs);
            CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            xlabel('Start Time [hr]')
            set(gca,'FontSize',fontsize)
            s = struct(h4);
            s.XAxis.TickLabelRotation = xrot;
        end
        

        %% IS Plots
        if isPlot_IS
            is_mm = 0.17;
            figure('Renderer', 'painters', 'Position', [850 100 800 800],'Name','IS - Single Gap')
            subplot(3,4,1)
            h5 = heatmap(linIS,'ColorLimits',[-is_mm is_mm],'Colormap',jet);
            h5.NodeChildren(3).YDir='normal';
            h5.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Durs);
            CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            ylabel('Duration [hr]')
            title('Linear')
            set(gca,'FontSize',fontsize)
            s = struct(h5);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,2)
            h6 = heatmap(miIS,'ColorLimits',[-is_mm is_mm],'Colormap',jet);
            h6.NodeChildren(3).YDir='normal';
            h6.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Durs);
            CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            title('Mean')
            set(gca,'FontSize',fontsize)
            s = struct(h6);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,3)
            h7 = heatmap(mediIS,'ColorLimits',[-is_mm is_mm],'Colormap',jet);
            h7.NodeChildren(3).YDir='normal';
            h7.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Durs);
            CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            title('Median')
            set(gca,'FontSize',fontsize)
            s = struct(h7);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,4)
            h6 = heatmap(maskIS,'ColorLimits',[-is_mm is_mm],'Colormap',jet);
            h6.NodeChildren(3).YDir='normal';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Durs);
            CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            title('Masked')
            set(gca,'FontSize',fontsize)
            s = struct(h6);
            s.XAxis.TickLabelRotation = xrot;
            
            % STD
            is_mm = 1.96*0.23;
            is_mm_l = 0;
            subplot(3,4,5)
            h5 = heatmap(linISstd,'ColorLimits',[is_mm_l is_mm],'Colormap',spring);
            h5.NodeChildren(3).YDir='normal';
            h5.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Durs);
            CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            ylabel('Duration [hr]')
            set(gca,'FontSize',fontsize)
            s = struct(h5);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,6)
            h6 = heatmap(miISstd,'ColorLimits',[is_mm_l is_mm],'Colormap',spring);
            h6.NodeChildren(3).YDir='normal';
            h6.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Durs);
            CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            set(gca,'FontSize',fontsize)
            s = struct(h6);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,7)
            h7 = heatmap(mediISstd,'ColorLimits',[is_mm_l is_mm],'Colormap',spring);
            h7.NodeChildren(3).YDir='normal';
            h7.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Durs);
            CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            set(gca,'FontSize',fontsize)
            s = struct(h7);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,8)
            h6 = heatmap(maskISstd,'ColorLimits',[is_mm_l is_mm],'Colormap',spring);
            h6.NodeChildren(3).YDir='normal';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Durs);
            CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            set(gca,'FontSize',fontsize)
            s = struct(h6);
            s.XAxis.TickLabelRotation = xrot;
            
            % Slope
            is_mm = .652;
            is_mm_l = 0;

            subplot(3,4,9)
            h5 = heatmap(linISslope,'ColorLimits',[is_mm_l is_mm],'Colormap',cool);
            h5.NodeChildren(3).YDir='normal';
            h5.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Durs);
            CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            xlabel('Start Time [hr]')
            ylabel('Duration [hr]')
            set(gca,'FontSize',fontsize)
            s = struct(h5);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,10)
            h6 = heatmap(miISslope,'ColorLimits',[is_mm_l is_mm],'Colormap',cool);
            h6.NodeChildren(3).YDir='normal';
            h6.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Durs);
            CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            xlabel('Start Time [hr]')
            set(gca,'FontSize',fontsize)
            s = struct(h6);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,11)
            h7 = heatmap(mediISslope,'ColorLimits',[is_mm_l is_mm],'Colormap',cool);
            h7.NodeChildren(3).YDir='normal';
            h7.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Durs);
            CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            xlabel('Start Time [hr]')
            set(gca,'FontSize',fontsize)
            s = struct(h7);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,12)
            h6 = heatmap(maskISslope,'ColorLimits',[is_mm_l is_mm],'Colormap',cool);
            h6.NodeChildren(3).YDir='normal';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Durs);
            CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            xlabel('Start Time [hr]')
            set(gca,'FontSize',fontsize)
            s = struct(h6);
            s.XAxis.TickLabelRotation = xrot; 
        end

    end
end


%% Mult Gap
if ismult
    clear T
    load('C:\Users\Laraw\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\Imputation\impTmult20211112.mat')

    Days = unique(T.Day);
    Spacing = unique(T.Spacing);
    Starts = unique(T.StartHr);
    for i = days_plot
        linIV = [];
        miIV = [];
        linIS = [];
        miIS = [];
        maskIV = [];
        maskIS = [];
        mediIV = [];
        mediIS = [];
        
        linIVstd = [];
        miIVstd = [];
        linISstd = [];
        miISstd = [];
        maskIVstd = [];
        maskISstd = [];
        mediIVstd = [];
        mediISstd = [];
        
        linIVslope = [];
        miIVslope = [];
        linISslope = [];
        miISslope = [];
        maskIVslope = [];
        maskISslope = [];
        mediIVslope = [];
        mediISslope = [];
        for j = 1:length(Starts)
            for k = 1:length(Spacing)
                ind = T.Day == Days(i) & T.Spacing == Spacing(k) & T.StartHr == Starts(j);
                
                % Mean
                linIV(k,j) = nanmean(T.IV_linimp(ind)-T.IV_comp(ind));
                miIV(k,j) = nanmean(T.IV_mimp(ind)-T.IV_comp(ind));
                linIS(k,j) = nanmean(T.IS_linimp(ind)-T.IS_comp(ind));
                miIS(k,j) = nanmean(T.IS_mimp(ind)-T.IS_comp(ind));
                maskIV(k,j) = nanmean(T.IV_mask(ind)-T.IV_comp(ind));
                maskIS(k,j) = nanmean(T.IS_mask(ind)-T.IS_comp(ind));
                mediIV(k,j) = nanmean(T.IV_medimp(ind)-T.IV_comp(ind));
                mediIS(k,j) = nanmean(T.IS_medimp(ind)-T.IS_comp(ind));
                
                % STD
                linIVstd(k,j) = 1.96*nanstd(T.IV_linimp(ind)-T.IV_comp(ind));
                miIVstd(k,j) = 1.96*nanstd(T.IV_mimp(ind)-T.IV_comp(ind));
                linISstd(k,j) = 1.96*nanstd(T.IS_linimp(ind)-T.IS_comp(ind));
                miISstd(k,j) = 1.96*nanstd(T.IS_mimp(ind)-T.IS_comp(ind));
                maskIVstd(k,j) = 1.96*nanstd(T.IV_mask(ind)-T.IV_comp(ind));
                maskISstd(k,j) = 1.96*nanstd(T.IS_mask(ind)-T.IS_comp(ind));
                mediIVstd(k,j) = 1.96*nanstd(T.IV_medimp(ind)-T.IV_comp(ind));
                mediISstd(k,j) = 1.96*nanstd(T.IS_medimp(ind)-T.IS_comp(ind));
                
                % Slope
                y = T.IV_linimp(ind)-T.IV_comp(ind);
                x = (T.IV_linimp(ind) + T.IV_comp(ind))./2;
                idx = ~isnan(x) & ~isnan(y);
                if sum(idx)~=0
                    p = polyfit(x(idx),y(idx),1);
                    linIVslope(k,j) = p(1);
                else
                    linIVslope(k,j) = nan;
                end

                y = T.IV_mimp(ind)-T.IV_comp(ind);
                x = (T.IV_mimp(ind)+T.IV_comp(ind))./2;
                idx = ~isnan(x) & ~isnan(y);
                if sum(idx)~=0
                    p = polyfit(x(idx),y(idx),1);
                    miIVslope(k,j) = p(1);
                else
                    miIVslope(k,j) = nan;
                end

                y = T.IS_linimp(ind)-T.IS_comp(ind);
                x = (T.IS_linimp(ind)+T.IS_comp(ind))./2;
                idx = ~isnan(x) & ~isnan(y);
                if sum(idx)~=0
                    p = polyfit(x(idx),y(idx),1);
                    linISslope(k,j) = p(1);
                else
                    linISslope(k,j) = nan;
                end

                y = T.IS_mimp(ind)-T.IS_comp(ind);
                x = (T.IS_mimp(ind)+T.IS_comp(ind))./2;
                idx = ~isnan(x) & ~isnan(y);
                if sum(idx)~=0
                    p = polyfit(x(idx),y(idx),1);
                    miISslope(k,j) = p(1);
                else
                    miISslope(k,j) = nan;
                end

                y = T.IV_mask(ind)-T.IV_comp(ind);
                x = (T.IV_mask(ind)+T.IV_comp(ind))./2;
                idx = ~isnan(x) & ~isnan(y);
                if sum(idx)~=0
                    p = polyfit(x(idx),y(idx),1);
                    maskIVslope(k,j) = p(1);
                else
                    maskIVslope(k,j) = nan;
                end

                y = T.IS_mask(ind)-T.IS_comp(ind);
                x = (T.IS_mask(ind)+T.IS_comp(ind))./2;
                idx = ~isnan(x) & ~isnan(y);
                if sum(idx)~=0
                    p = polyfit(x(idx),y(idx),1);
                    maskISslope(k,j) = p(1);
                else
                    maskISslope(k,j) = nan;
                end

                y = T.IV_medimp(ind)-T.IV_comp(ind);
                x = (T.IV_medimp(ind)+T.IV_comp(ind))./2;
                idx = ~isnan(x) & ~isnan(y);
                if sum(idx)~=0
                    p = polyfit(x(idx),y(idx),1);
                    mediIVslope(k,j) = p(1);
                else
                    mediIVslope(k,j) = nan;
                end

                y = T.IS_medimp(ind)-T.IS_comp(ind);
                x = (T.IS_medimp(ind)+T.IS_comp(ind))./2;
                idx = ~isnan(x) & ~isnan(y);
                if sum(idx)~=0
                    p = polyfit(x(idx),y(idx),1);
                    mediISslope(k,j) = p(1);
                else
                    mediISslope(k,j) = nan;
                end 
                

            end
        end

        %% IV plots
        if isPlot_IV
            figure('Renderer', 'painters', 'Position', [100 100 800 800],'Name','IV - Multi Gap')
            % Mean
            iv_mm = 0.30;
            subplot(3,4,1)
            h1 = heatmap(linIV,'ColorLimits',[-iv_mm iv_mm],'Colormap',jet);
            h1.NodeChildren(3).YDir='normal';
            h1.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Spacing);
            CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            ylabel('Duration [hr]')
            title('Linear')
            set(gca,'FontSize',fontsize)
            s = struct(h1);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,2)
            h2 = heatmap(miIV,'ColorLimits',[-iv_mm iv_mm],'Colormap',jet);
            h2.NodeChildren(3).YDir='normal';
            h2.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Spacing);
            CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            title('Mean')
            set(gca,'FontSize',fontsize)
            s = struct(h2);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,3)
            h3 = heatmap(mediIV,'ColorLimits',[-iv_mm iv_mm],'Colormap',jet);
            h3.NodeChildren(3).YDir='normal';
            h3.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Spacing);
            CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            title('Median')
            set(gca,'FontSize',fontsize)
            s = struct(h3);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,4)
            h4 = heatmap(maskIV,'ColorLimits',[-iv_mm iv_mm],'Colormap',jet);
            h4.NodeChildren(3).YDir='normal';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Spacing);
            CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            title('Masked')
            set(gca,'FontSize',fontsize)
            s = struct(h4);
            s.XAxis.TickLabelRotation = xrot;


            % STD
            iv_mm = 1.96*0.39;
            iv_mm_l = 0;

            subplot(3,4,5)
            h1 = heatmap(linIVstd,'ColorLimits',[iv_mm_l iv_mm],'Colormap',spring);
            h1.NodeChildren(3).YDir='normal';
            h1.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Spacing);
            CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            ylabel('Duration [hr]')
            set(gca,'FontSize',fontsize)
            s = struct(h1);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,6)
            h2 = heatmap(miIVstd,'ColorLimits',[iv_mm_l iv_mm],'Colormap',spring);
            h2.NodeChildren(3).YDir='normal';
            h2.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Spacing);
            CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            set(gca,'FontSize',fontsize)
            s = struct(h2);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,7)
            h3 = heatmap(mediIVstd,'ColorLimits',[iv_mm_l iv_mm],'Colormap',spring);
            h3.NodeChildren(3).YDir='normal';
            h3.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Spacing);
            CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            set(gca,'FontSize',fontsize)
            s = struct(h3);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,8)
            h4 = heatmap(maskIVstd,'ColorLimits',[iv_mm_l iv_mm],'Colormap',spring);
            h4.NodeChildren(3).YDir='normal';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Spacing);
            CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            set(gca,'FontSize',fontsize)
            s = struct(h4);
            s.XAxis.TickLabelRotation = xrot;


            % Slope
            iv_mm = .779;
            iv_mm_l = .016;
            subplot(3,4,9)
            h1 = heatmap(linIVslope,'ColorLimits',[iv_mm_l iv_mm],'Colormap',cool);
            h1.NodeChildren(3).YDir='normal';
            h1.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Spacing);
            CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            %xticks(Starts)
            xlabel('Start Time [hr]')
            %xticks(Durs)
            ylabel('Duration [hr]')
            set(gca,'FontSize',fontsize)
            s = struct(h1);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,10)
            h2 = heatmap(miIVslope,'ColorLimits',[iv_mm_l iv_mm],'Colormap',cool);
            h2.NodeChildren(3).YDir='normal';
            h2.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Spacing);
            CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            xlabel('Start Time [hr]')
            set(gca,'FontSize',fontsize)
            s = struct(h2);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,11)
            h3 = heatmap(mediIVslope,'ColorLimits',[iv_mm_l iv_mm],'Colormap',cool);
            h3.NodeChildren(3).YDir='normal';
            h3.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Spacing);
            CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            xlabel('Start Time [hr]')
            set(gca,'FontSize',fontsize)
            s = struct(h3);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,12)
            h4 = heatmap(maskIVslope,'ColorLimits',[iv_mm_l iv_mm],'Colormap',cool);
            h4.NodeChildren(3).YDir='normal';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Spacing);
            CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            %xticks(Starts)
            xlabel('Start Time [hr]')
            set(gca,'FontSize',fontsize)
            s = struct(h4);
            s.XAxis.TickLabelRotation = xrot;
        end
        

        %% IS Plots
        if isPlot_IS
            is_mm = 0.17;
            figure('Renderer', 'painters', 'Position', [850 100 800 800],'Name','IS - Multi Gap')
            subplot(3,4,1)
            h5 = heatmap(linIS,'ColorLimits',[-is_mm is_mm],'Colormap',jet);
            h5.NodeChildren(3).YDir='normal';
            h5.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Spacing);
            CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            ylabel('Duration [hr]')
            title('Linear')
            set(gca,'FontSize',fontsize)
            s = struct(h5);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,2)
            h6 = heatmap(miIS,'ColorLimits',[-is_mm is_mm],'Colormap',jet);
            h6.NodeChildren(3).YDir='normal';
            h6.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Spacing);
            CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            title('Mean')
            set(gca,'FontSize',fontsize)
            s = struct(h6);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,3)
            h7 = heatmap(mediIS,'ColorLimits',[-is_mm is_mm],'Colormap',jet);
            h7.NodeChildren(3).YDir='normal';
            h7.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Spacing);
            CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            title('Median')
            set(gca,'FontSize',fontsize)
            s = struct(h7);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,4)
            h6 = heatmap(maskIS,'ColorLimits',[-is_mm is_mm],'Colormap',jet);
            h6.NodeChildren(3).YDir='normal';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Spacing);
            CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            title('Masked')
            set(gca,'FontSize',fontsize)
            s = struct(h6);
            s.XAxis.TickLabelRotation = xrot;
            
            % STD
            is_mm = 1.96*0.23;
            is_mm_l = 0;
            subplot(3,4,5)
            h5 = heatmap(linISstd,'ColorLimits',[is_mm_l is_mm],'Colormap',spring);
            h5.NodeChildren(3).YDir='normal';
            h5.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Spacing);
            CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            ylabel('Duration [hr]')
            set(gca,'FontSize',fontsize)
            s = struct(h5);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,6)
            h6 = heatmap(miISstd,'ColorLimits',[is_mm_l is_mm],'Colormap',spring);
            h6.NodeChildren(3).YDir='normal';
            h6.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Spacing);
            CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            set(gca,'FontSize',fontsize)
            s = struct(h6);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,7)
            h7 = heatmap(mediISstd,'ColorLimits',[is_mm_l is_mm],'Colormap',spring);
            h7.NodeChildren(3).YDir='normal';
            h7.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Spacing);
            CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            set(gca,'FontSize',fontsize)
            s = struct(h7);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,8)
            h6 = heatmap(maskISstd,'ColorLimits',[is_mm_l is_mm],'Colormap',spring);
            h6.NodeChildren(3).YDir='normal';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Spacing);
            CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            set(gca,'FontSize',fontsize)
            s = struct(h6);
            s.XAxis.TickLabelRotation = xrot;
            
            % Slope
            is_mm = .652;
            is_mm_l = 0;

            subplot(3,4,9)
            h5 = heatmap(linISslope,'ColorLimits',[is_mm_l is_mm],'Colormap',cool);
            h5.NodeChildren(3).YDir='normal';
            h5.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Spacing);
            CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            xlabel('Start Time [hr]')
            ylabel('Duration [hr]')
            set(gca,'FontSize',fontsize)
            s = struct(h5);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,10)
            h6 = heatmap(miISslope,'ColorLimits',[is_mm_l is_mm],'Colormap',cool);
            h6.NodeChildren(3).YDir='normal';
            h6.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Spacing);
            CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            xlabel('Start Time [hr]')
            set(gca,'FontSize',fontsize)
            s = struct(h6);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,11)
            h8 = heatmap(mediISslope,'ColorLimits',[is_mm_l is_mm],'Colormap',cool);
            h8.NodeChildren(3).YDir='normal';
            h8.ColorbarVisible = 'off';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Spacing);
            CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            xlabel('Start Time [hr]')
            set(gca,'FontSize',fontsize)
            s = struct(h8);
            s.XAxis.TickLabelRotation = xrot;

            subplot(3,4,12)
            h6 = heatmap(maskISslope,'ColorLimits',[is_mm_l is_mm],'Colormap',cool);
            h6.NodeChildren(3).YDir='normal';
            ax = gca;
            CustomXLabels = string(Starts);
            CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
            ax.XDisplayLabels = CustomXLabels;
            CustomYLabels = string(Spacing);
            CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
            ax.YDisplayLabels = CustomYLabels;
            xlabel('Start Time [hr]')
            set(gca,'FontSize',fontsize) 
            s = struct(h6);
            s.XAxis.TickLabelRotation = xrot;
        end

    end    
end
    
    
    
    
    
    
    
    
    
    
    
    
    

