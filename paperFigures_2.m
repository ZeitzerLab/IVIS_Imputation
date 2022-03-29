%% Paper Figures

%% Load Data
baseDir = 'C:\Users\Lara\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\';

% Data
data_raw_path = 'Organized\dataOrganized.mat';

% Masks
masks_sing_path = 'Masks\masksAllt2-20220318.mat';

% IVIS
IVIS_sing_path = 'Imputation\impT20220318.mat';
IVIS_mult_path = 'Imputation\impTmult20220318.mat';

%% Plot Flags
% main plots
isplot_exampleImputation = 0;
isplot_heatmaps = 0; 
    isSing = 0;
    ismult = 1;

    isPlot_IV = 0; 
    isPlot_IS = 1;
    
    days_plot = 1;

% supplementary figures
isplot_exampleBlandAltman = 0;
isplot_starthr = 0;
isplot_IVISDist = 0;
isplot_heatmaps_supp = 1;

%% Plot features
% general features
fontsize = 12;
fontsize_letter = 18;
fontsize_text = 9;
fontsize_imp = 12;
linewidth = 1.5;
xrot = 0;
yspacing = 3;

% figure sizes
fs_exampleImputation = [100 100 624 400];
fs_Heatmap = [100 100 624 300];
fs_Heatmap_supp = [100 100 624 600];
fs_BA = [100 100 624 300];


sp_height_gen = .65;
sp_width_gen = 0.18;
sp_row_gen = 0.25;

offset = 0.1;
space = 0.02;
bump = 0.02;
sp_c1 = offset;
sp_c2 = sp_width_gen + space + offset;
sp_c3 = 2*(sp_width_gen + space) +  offset;
sp_c4 = 3*(sp_width_gen + space) +  offset + bump;

% subplot position/size vector
pos1 = [sp_c1 sp_row_gen sp_width_gen sp_height_gen];
pos2 = [sp_c2 sp_row_gen sp_width_gen sp_height_gen];
pos3 = [sp_c3 sp_row_gen sp_width_gen sp_height_gen];
pos4 = [sp_c4 sp_row_gen sp_width_gen sp_height_gen];

% heatmap color span 
%IV
iv_mm = 0.3;
iv_std_u = 0.49;
iv_std_l = 0;
iv_sl_u = .35;
iv_sl_l = -.05; 


is_mm = 0.17;
is_std_u = 0.3;
is_std_l = 0; 
is_sl_u = .23;
is_sl_l = -.45; 


% 2x4 plots

sp_height_gen = .35;
sp_bot = 0.1;
sp_top = 0.5;

pos5_hms = [sp_c1 sp_top sp_width_gen sp_height_gen];
pos6_hms = [sp_c2 sp_top sp_width_gen sp_height_gen];
pos7_hms = [sp_c3 sp_top sp_width_gen sp_height_gen];
pos8_hms = [sp_c4 sp_top sp_width_gen sp_height_gen];

pos9_hms = [sp_c1 sp_bot sp_width_gen sp_height_gen];
pos10_hms = [sp_c2 sp_bot sp_width_gen sp_height_gen];
pos11_hms = [sp_c3 sp_bot sp_width_gen sp_height_gen];
pos12_hms = [sp_c4 sp_bot sp_width_gen sp_height_gen];

% 84 subjects only
S = [{'S6019666_90001_0_0';'S6019821_90001_0_0';'S6020523_90001_0_0';'S6020813_90001_0_0';'S6020965_90001_0_0';'S6021269_90001_0_0';'S6021609_90001_0_0'}];

%% Example of True/Mask/imputed Data
if isplot_exampleImputation
    load(fullfile(baseDir,data_raw_path));
    load(fullfile(baseDir,masks_sing_path));
    % Set Vars
    subjects = unique(masks.subject);
    for i = 8%:length(subjects)
        %clear act_full act t
        fprintf('%d - %s\n',i,subjects{i})
        m = masks(strcmp(masks.subject,subjects{i}),:);

        act_full = data.(subjects{i}).acc;
        t = data.(subjects{i}).t;

        jjj = find(m.startHr == 10 & m.dur == 5);

        for j = jjj(1)%1%:size(m,1)
            fprintf('    Mask %d of %d\n',j,size(m,1))
            %clear act
            % Apply Mask
                if ~isnan(m.start_ind(j)) && ~isnan(m.end_ind(j))        
                    % Compute Imputation 
                    act = act_full;
                    act(m.start_ind(j):m.end_ind(j)) = 0;
                    if m.start_ind(j)>1
                        gaps = [m.start_ind(j)-1,m.end_ind(j)];
                    else
                        gaps = [m.start_ind(j),m.end_ind(j)];
                    end

                    % Mean Imputation
                    medianimputed = medianImputation(act,t,gaps);
                    meanimputed = meanImputation(act,t,gaps);
                    linInterpimputed = linInterpImputation(act,t,gaps);
                end
        end

        ind = t>= t(m.start_ind(j))-hours(12) & t<= t(m.start_ind(j))+hours(12);

        figure('Renderer', 'painters', 'Position', fs_exampleImputation)
        ax(1) = subplot(4,1,1);
        area([t(m.start_ind(j)) t(m.end_ind(j))],[max(act_full(ind)), max(act_full(ind))],'facecolor',[1,0,0], ...
        'facealpha',.3,'edgecolor','none', 'basevalue',0);
        hold on
        plot(t(ind),act_full(ind),'k','linewidth',linewidth)
        set(gca,'XTick',[])
        text(t(m.start_ind(j))+hours(2.25), 190, 'Raw','fontweight','bold','fontsize',fontsize_imp)
        text(t(find(ind,1))+hours(0.25), 180, 'A','fontweight','bold','fontsize',fontsize_letter)
        set(gca,'fontweight','bold','fontsize',fontsize)
        
        ax(2) = subplot(4,1,2);
        area([t(m.start_ind(j)) t(m.end_ind(j))],[max(act_full(ind)), max(act_full(ind))],'facecolor',[1,0,0], ...
        'facealpha',.3,'edgecolor','none', 'basevalue',0);
        hold on
        plot(t(ind),linInterpimputed(ind),'k','linewidth',linewidth)
        text(t(m.start_ind(j))+hours(1.775), 190, 'Linear','fontweight','bold','fontsize',fontsize_imp)
        text(t(find(ind,1))+hours(0.25), 180, 'B','fontweight','bold','fontsize',fontsize_letter)
        set(gca,'XTick',[])
        set(gca,'fontweight','bold','fontsize',fontsize)
        
        ax(3) = subplot(4,1,3);
        area([t(m.start_ind(j)) t(m.end_ind(j))],[max(act_full(ind)), max(act_full(ind))],'facecolor',[1,0,0], ...
        'facealpha',.3,'edgecolor','none', 'basevalue',0);
        hold on
        plot(t(ind),meanimputed(ind),'k','linewidth',linewidth)
        text(t(m.start_ind(j))+hours(1.85), 190, 'Mean','fontweight','bold','fontsize',fontsize_imp)
        text(t(find(ind,1))+hours(0.25), 180, 'C','fontweight','bold','fontsize',fontsize_letter)
        ylabel('                  Activity [Counts]')
        set(gca,'XTick',[])
        set(gca,'fontweight','bold','fontsize',fontsize)
        
        ax(4) = subplot(4,1,4);
        area([t(m.start_ind(j)) t(m.end_ind(j))],[max(act_full(ind)), max(act_full(ind))],'facecolor',[1,0,0], ...
        'facealpha',.3,'edgecolor','none', 'basevalue',0);
        hold on
        plot(t(ind),medianimputed(ind),'k','linewidth',linewidth)
        text(t(m.start_ind(j))+hours(1.45), 190,'Median','fontweight','bold','fontsize',fontsize_imp)
        text(t(find(ind,1))+hours(0.25), 180, 'D','fontweight','bold','fontsize',fontsize_letter)
        xlabel('Time [s]')
        %ylabel('Actigraphy')
        set(gca,'fontweight','bold','fontsize',fontsize)
        
        linkaxes(ax,'xy')
        axis tight

    end
end


%% Heatmaps
if isplot_heatmaps
    %% Single Gap   
    if isSing
        load(fullfile(baseDir,IVIS_sing_path))

        ind_s = ones( length(T.Subject),1); 
        for sss = 1:length(S)
            iii = strcmp(T.Subject,S{sss});
            ind_s(iii) = 0;
        end
        ind_s = logical(ind_s);

        T = T(ind_s,:);

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
                    
                end
            end
            
            %% IV plots
            if isPlot_IV
                figure('Renderer', 'painters', 'Position', fs_Heatmap,'Name','IV - Single Gap')
                % Mean
                subplot('Position',pos1)
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
                ylabel(sprintf('Duration [hr]'))
                xlabel('Start Time [hr]')
                title('Linear')
                hAx=h1.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h1.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos1;
                text(ax, .05, .09, 'A','fontweight','bold','fontsize',fontsize_letter)
                
                

                subplot('Position',pos2)
                h2 = heatmap(miIV,'ColorLimits',[-iv_mm iv_mm],'Colormap',jet);
                h2.NodeChildren(3).YDir='normal';
                h2.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = CustomXLabels;
                CustomYLabels = string(Durs);
                CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));% CustomYLabels;
                title('Mean')
                xlabel('Start Time [hr]')
                hAx=h2.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h2.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h2);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos2;
                text(ax, .05, .09, 'B','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos3)
                h3 = heatmap(mediIV,'ColorLimits',[-iv_mm iv_mm],'Colormap',jet);
                h3.NodeChildren(3).YDir='normal';
                h3.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = CustomXLabels;
                CustomYLabels = string(Durs);
                CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                title('Median')
                xlabel('Start Time [hr]')
                hAx=h3.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h3.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h3);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos3;
                text(ax, .05, .09, 'C','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos4)
                h4 = heatmap(maskIV,'ColorLimits',[-iv_mm iv_mm],'Colormap',jet);
                h4.NodeChildren(3).YDir='normal';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = CustomXLabels;
                CustomYLabels = string(Durs);
                CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                title('Masked')
                xlabel('Start Time [hr]')
                hAx=h4.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h4.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h4);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos4;
                text(ax, .05, .09, 'D','fontweight','bold','fontsize',fontsize_letter)
            end


            %% IS Plots
            if isPlot_IS
                figure('Renderer', 'painters', 'Position', fs_Heatmap,'Name','IS - Single Gap')
                subplot('Position',pos1)
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
                ylabel(sprintf('Duration [hr]'))
                xlabel('Start Time [hr]')
                title('Linear')
                hAx=h5.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h5.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h5);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos1;
                text(ax, .05, .09, 'A','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos2)
                h6 = heatmap(miIS,'ColorLimits',[-is_mm is_mm],'Colormap',jet);
                h6.NodeChildren(3).YDir='normal';
                h6.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = CustomXLabels;
                CustomYLabels = string(Durs);
                CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                title('Mean')
                xlabel('Start Time [hr]')
                hAx=h6.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h6.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h6);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos2;
                text(ax, .05, .09, 'B','fontweight','bold','fontsize',fontsize_letter)
                
                subplot('Position',pos3)
                h7 = heatmap(mediIS,'ColorLimits',[-is_mm is_mm],'Colormap',jet);
                h7.NodeChildren(3).YDir='normal';
                h7.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = CustomXLabels;
                CustomYLabels = string(Durs);
                CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                title('Median')
                xlabel('Start Time [hr]')
                hAx=h7.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h7.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h7);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos3;
                text(ax, .05, .09, 'C','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos4)
                h8 = heatmap(maskIS,'ColorLimits',[-is_mm is_mm],'Colormap',jet);
                h8.NodeChildren(3).YDir='normal';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = CustomXLabels;
                CustomYLabels = string(Durs);
                CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                title('Masked')
                xlabel('Start Time [hr]')
                hAx=h8.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h8.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h8);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos4;
                text(ax, .05, .09, 'D','fontweight','bold','fontsize',fontsize_letter)

            end

        end
    end

    %% Mult Gap
    if ismult
        clear T
        load(fullfile(baseDir,IVIS_mult_path))

        ind_s = ones( length(T.Subject),1); 
        for sss = 1:length(S)
            iii = strcmp(T.Subject,S{sss});
            ind_s(iii) = 0;
        end
        ind_s = logical(ind_s);

        T = T(ind_s,:);

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
                end
            end
            
            %% IV plots
            if isPlot_IV
                figure('Renderer', 'painters', 'Position', fs_Heatmap,'Name','IV - Multi Gap')
                % Mean
                subplot('Position',pos1)
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
                ylabel(sprintf('Duration [hr]'))
                xlabel('Start Time [hr]')
                title('Linear')
                hAx=h1.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h1.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h1);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos1;
                text(ax, .05, .09, 'A','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos2)
                h2 = heatmap(miIV,'ColorLimits',[-iv_mm iv_mm],'Colormap',jet);
                h2.NodeChildren(3).YDir='normal';
                h2.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = CustomXLabels;
                CustomYLabels = string(Spacing);
                CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                title('Mean')
                xlabel('Start Time [hr]')
                hAx=h2.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h2.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h2);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos2;
                text(ax, .05, .09, 'B','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos3)
                h3 = heatmap(mediIV,'ColorLimits',[-iv_mm iv_mm],'Colormap',jet);
                h3.NodeChildren(3).YDir='normal';
                h3.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = CustomXLabels;
                CustomYLabels = string(Spacing);
                CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                title('Median')
                xlabel('Start Time [hr]')
                hAx=h3.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h3.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h3);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos3;
                text(ax, .05, .09, 'C','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos4)
                h4 = heatmap(maskIV,'ColorLimits',[-iv_mm iv_mm],'Colormap',jet);
                h4.NodeChildren(3).YDir='normal';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = CustomXLabels;
                CustomYLabels = string(Spacing);
                CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                title('Masked')
                xlabel('Start Time [hr]')
                hAx=h4.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h4.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h4);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos4;
                text(ax, .05, .09, 'D','fontweight','bold','fontsize',fontsize_letter)
            end


            %% IS Plots
            if isPlot_IS
                figure('Renderer', 'painters', 'Position', fs_Heatmap,'Name','IS - Multi Gap')
                subplot('Position',pos1)
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
                ylabel(sprintf('Duration [hr]'))
                title('Linear')
                xlabel('Start Time [hr]')
                hAx=h5.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h5.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h5);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos1;
                text(ax, .05, .09, 'A','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos2)
                h6 = heatmap(miIS,'ColorLimits',[-is_mm is_mm],'Colormap',jet);
                h6.NodeChildren(3).YDir='normal';
                h6.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = CustomXLabels;
                CustomYLabels = string(Spacing);
                CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                title('Mean')
                xlabel('Start Time [hr]')
                hAx=h6.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h6.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h6);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos2;
                text(ax, .05, .09, 'B','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos3)
                h7 = heatmap(mediIS,'ColorLimits',[-is_mm is_mm],'Colormap',jet);
                h7.NodeChildren(3).YDir='normal';
                h7.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = CustomXLabels;
                CustomYLabels = string(Spacing);
                CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                title('Median')
                xlabel('Start Time [hr]')
                hAx=h7.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h7.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h7);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos3;
                text(ax, .05, .09, 'C','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos4)
                h8 = heatmap(maskIS,'ColorLimits',[-is_mm is_mm],'Colormap',jet);
                h8.NodeChildren(3).YDir='normal';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = CustomXLabels;
                CustomYLabels = string(Spacing);
                CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                title('Masked')
                xlabel('Start Time [hr]')
                hAx=h8.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h8.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h8);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos4;
                text(ax, .05, .09, 'D','fontweight','bold','fontsize',fontsize_letter)
            end

        end    
    end
end


%% ------ Supplementary ------ %% 
%% Example Bland Altman Plot
if isplot_exampleBlandAltman 
    % Set Vars
    %clear act_full act t
    clear T
    load(fullfile(baseDir,IVIS_sing_path))
    
    dt = T(T.StartHr == 10 & T.Dur == 5 & T.Day == 1,:);
    
    % IV values
%     masked_y = dt.IV_mask -  dt.IV_comp;
%     meanimp_y =  dt.IV_mimp -  dt.IV_comp;
%     medimp_y = dt.IV_medimp -  dt.IV_comp;
%     linint_y = dt.IV_linimp -  dt.IV_comp; 
%     
%     masked_x = (dt.IV_mask + dt.IV_comp)/2;
%     meanimp_x =  (dt.IV_mimp +  dt.IV_comp)/2;
%     medimp_x = (dt.IV_medimp +  dt.IV_comp)/2;
%     linint_x = (dt.IV_linimp +  dt.IV_comp)/2; 
    
    
    % IS Values
    masked_ys = dt.IS_mask -  dt.IS_comp;
    meanimp_ys =  dt.IS_mimp -  dt.IS_comp;
    medimp_ys = dt.IS_medimp -  dt.IS_comp;
    linint_ys = dt.IS_linimp -  dt.IS_comp; 
    
    masked_xs = (dt.IS_mask + dt.IS_comp)/2;
    meanimp_xs =  (dt.IS_mimp +  dt.IS_comp)/2;
    medimp_xs = (dt.IS_medimp +  dt.IS_comp)/2;
    linint_xs = (dt.IS_linimp +  dt.IS_comp)/2; 
    
    
    x = medimp_xs;
    y = medimp_ys;
    
    xs = masked_xs;
    ys = masked_ys;
    
    xm = meanimp_xs;
    ym = meanimp_ys;
    
    xl = linint_xs;
    yl = linint_ys;
    
    figure('Renderer', 'painters', 'Position', fs_BA,'Name','Bland-Altman Example: IS [10am, 5hr]')
    ax(1) = subplot('Position',pos1);
    hold on
    scatter(xl,yl,'MarkerFaceColor','r','MarkerEdgeColor','r','MarkerEdgeAlpha',0.3,'MarkerFaceAlpha',.3);
    idx = ~isnan(xl) & ~isnan(yl);
    p = polyfit(xl(idx),yl(idx),1);
    y_sll = polyval(p,xl);
    plot(xl,y_sll,'linewidth',linewidth,'color',[0,0,0,.6]);
    plot([0 1],[nanmean(yl) nanmean(yl)],'k','linewidth',linewidth)
    plot([0 1],[nanmean(yl)+1.96*nanstd(yl) nanmean(yl)+1.96*nanstd(yl)],'--k','linewidth',linewidth)
    plot([0 1],[nanmean(yl)-1.96*nanstd(yl) nanmean(yl)-1.96*nanstd(yl)],'--k','linewidth',linewidth)
    ylabel('Difference from True')
    xlabel(sprintf('Linear & True\nAverage'))
    title('Linear')
    txt1 = sprintf('Mean:\n%.2f',nanmean(yl));
    text(.975,nanmean(yl),txt1,'HorizontalAlignment','right','fontsize',fontsize_text)
    txt2 = sprintf('+1.96SD:\n%.2f',nanmean(yl)+1.96*nanstd(yl));
    text(.975,nanmean(yl)+1.96*nanstd(yl),txt2,'HorizontalAlignment','right','fontsize',fontsize_text)
    txt3 = sprintf('-1.96SD:\n%.2f',nanmean(yl)-1.96*nanstd(yl));
    text(.975,nanmean(yl)-1.96*nanstd(yl),txt3,'HorizontalAlignment','right','fontsize',fontsize_text)
    grid on
    text(0.025, .23, 'A','fontweight','bold','fontsize',fontsize_letter)
    set(gca, 'fontweight','bold','fontsize',fontsize)
    
    ax(2) = subplot('Position',pos2);
    hold on
    scatter(xm,ym,'MarkerFaceColor','r','MarkerEdgeColor','r','MarkerEdgeAlpha',0.3,'MarkerFaceAlpha',.3);
    idx = ~isnan(xm) & ~isnan(ym);
    p = polyfit(xm(idx),ym(idx),1);
    y_slm = polyval(p,xm);
    plot(xm,y_slm,'linewidth',linewidth,'color',[0,0,0,.6]);
    plot([0 1],[nanmean(ym) nanmean(ym)],'k','linewidth',linewidth)
    plot([0 1],[nanmean(ym)+1.96*nanstd(ym) nanmean(ym)+1.96*nanstd(ym)],'--k','linewidth',linewidth)
    plot([0 1],[nanmean(ym)-1.96*nanstd(ym) nanmean(ym)-1.96*nanstd(ym)],'--k','linewidth',linewidth)
    xlabel(sprintf('Mean & True\nAverage'))
    title('Mean')
    txt1 = sprintf('Mean:\n%.2f',nanmean(ym));
    text(.975,nanmean(ym),txt1,'HorizontalAlignment','right','fontsize',fontsize_text)
    txt2 = sprintf('+1.96SD:\n%.2f',nanmean(ym)+1.96*nanstd(ym));
    text(.975,nanmean(ym)+1.96*nanstd(ym),txt2,'HorizontalAlignment','right','fontsize',fontsize_text)
    txt3 = sprintf('-1.96SD:\n%.2f',nanmean(ym)-1.96*nanstd(ym));
    text(.975,nanmean(ym)-1.96*nanstd(ym),txt3,'HorizontalAlignment','right','fontsize',fontsize_text)
    grid on
    text(0.025, .23, 'B','fontweight','bold','fontsize',fontsize_letter)
    set(gca, 'fontweight','bold','fontsize',fontsize,'yticklabel',{[]})
    
    ax(3) = subplot('Position',pos3);
    hold on
    scatter(x,y,'MarkerFaceColor','r','MarkerEdgeColor','r','MarkerEdgeAlpha',0.3,'MarkerFaceAlpha',.3);
    idx = ~isnan(x) & ~isnan(y);
    p = polyfit(x(idx),y(idx),1);
    y_sl = polyval(p,x);
    plot(x,y_sl,'linewidth',linewidth,'color',[0,0,0,.6]);
    plot([0 1],[nanmean(y) nanmean(y)],'k','linewidth',linewidth)
    plot([0 1],[nanmean(y)+1.96*nanstd(y) nanmean(y)+1.96*nanstd(y)],'--k','linewidth',linewidth)
    plot([0 1],[nanmean(y)-1.96*nanstd(y) nanmean(y)-1.96*nanstd(y)],'--k','linewidth',linewidth)
    xlabel(sprintf('Median & True\nAverage'))
    title('Median')
    txt1 = sprintf('Mean:\n%.2f',nanmean(y));
    text(.975,nanmean(y),txt1,'HorizontalAlignment','right','fontsize',fontsize_text)
    txt2 = sprintf('+1.96SD:\n%.2f',nanmean(y)+1.96*nanstd(y));
    text(.975,nanmean(y)+1.96*nanstd(y),txt2,'HorizontalAlignment','right','fontsize',fontsize_text)
    txt3 = sprintf('-1.96SD:\n%.2f',nanmean(y)-1.96*nanstd(y));
    text(.975,nanmean(y)-1.96*nanstd(y),txt3,'HorizontalAlignment','right','fontsize',fontsize_text)
    grid on
    text(.025, .23, 'C','fontweight','bold','fontsize',fontsize_letter)
    set(gca, 'fontweight','bold','fontsize',fontsize,'yticklabel',{[]})
    
    ax(4) = subplot('Position',pos4);
    hold on
    scatter(xs,ys,'MarkerFaceColor','r','MarkerEdgeColor','r','MarkerEdgeAlpha',0.3,'MarkerFaceAlpha',.3);
    idx = ~isnan(xs) & ~isnan(ys);
    p = polyfit(xs(idx),ys(idx),1);
    y_sls = polyval(p,xs);
    plot(xs,y_sls,'linewidth',linewidth,'color',[0,0,0,.6]);
    plot([0 1],[nanmean(ys) nanmean(ys)],'k','linewidth',linewidth)
    plot([0 1],[nanmean(ys)+1.96*nanstd(ys) nanmean(ys)+1.96*nanstd(ys)],'--k','linewidth',linewidth)
    plot([0 1],[nanmean(ys)-1.96*nanstd(ys) nanmean(ys)-1.96*nanstd(ys)],'--k','linewidth',linewidth)
    txt1 = sprintf('Mean:\n%.2f',nanmean(ys));
    text(.975,nanmean(ys),txt1,'HorizontalAlignment','right','fontsize',fontsize_text)
    txt2 = sprintf('+1.96SD:\n%.2f',nanmean(y)+1.96*nanstd(ys));
    text(.975,nanmean(ys)+1.96*nanstd(ys),txt2,'HorizontalAlignment','right','fontsize',fontsize_text)
    txt3 = sprintf('-1.96SD:\n%.2f',nanmean(y)-1.96*nanstd(ys));
    text(.975,nanmean(ys)-1.96*nanstd(ys),txt3,'HorizontalAlignment','right','fontsize',fontsize_text)
    title('Masked')
    xlabel(sprintf('Masked & True\nAverage'))
    grid on
    text(0.025, .23, 'D','fontweight','bold','fontsize',fontsize_letter)
    set(gca,'fontweight','bold','fontsize',fontsize,'yticklabel',{[]})
    
    linkaxes(ax,'xy')
    xlim([0 1])
    ylim([-0.265 0.265])

end

%% Distribution of IV and IS Scores for complete files
if isplot_IVISDist
    clear T
    load(fullfile(baseDir,IVIS_sing_path))
    
    subjects = unique(cellstr(T.Subject));

    IVIS = nan(length(subjects),2);
    for i=1:length(subjects)
        ind = find(strcmp(T.Subject,subjects(i)),1);
        IVIS(i,:) = [T.IV_comp(ind),T.IS_comp(ind)];
    end

    figure
    subplot(1,2,1)
    histogram(IVIS(:,1))
    title('IV Distribution')
    xlabel('IV')
    ylabel('Counts')
    ylim([0 22])

    subplot(1,2,2)
    histogram(IVIS(:,2))
    title('IS Distribution')
    xlabel('IS')
    ylabel('Counts')
    ylim([0 22])
end

%% Distribution of starting Days/hours
if isplot_starthr
    load(fullfile(baseDir,data_raw_path))
    % Set Vars
    subjects = unique(masks.subject);
    for i = 1:length(subjects)
        %clear act_full act t
        fprintf('%d - %s\n',i,subjects{i})
        m = masks(strcmp(masks.subject,subjects{i}),:);

        act_full = data.(subjects{i}).acc;
        t = data.(subjects{i}).t;
        ST(i) = t(1);

    end

    figure
    histogram(weekday(ST),[.5:7.5])
    xlabel('Weekday')
    ylabel('Frequency')

    figure
    histogram(hour(ST),[.5:24.5])
    xlabel('Start Hour')
    ylabel('Frequency')
end

%% Heatmaps
if isplot_heatmaps_supp
    %% Single Gap   
    if isSing
        load(fullfile(baseDir,IVIS_sing_path))

        ind_s = ones( length(T.Subject),1); 
        for sss = 1:length(S)
            iii = strcmp(T.Subject,S{sss});
            ind_s(iii) = 0;
        end
        ind_s = logical(ind_s);

        T = T(ind_s,:);

        Days = unique(T.Day);
        Durs = unique(T.Dur);
        Starts = unique(T.StartHr);
        for i = days_plot
         
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
            
            IV_std_sing = [max([max(max(linIVstd)) max(max(miIVstd)) max(max(mediIVstd)) max(max(maskIVstd))]), min([min(min(linIVstd)) min(min(miIVstd)) min(min(mediIVstd)) min(min(maskIVstd))])];
            
            IS_std_sing = [max([max(max(linISstd)) max(max(miISstd)) max(max(mediISstd)) max(max(maskISstd))]), min([min(min(linISstd)) min(min(miISstd)) min(min(mediISstd)) min(min(maskISstd))])];
            
            IV_slope_sing = [max([max(max(linIVslope)) max(max(miIVslope)) max(max(mediIVslope)) max(max(maskIVslope))]), min([min(min(linIVslope)) min(min(miIVslope)) min(min(mediIVslope)) min(min(maskIVslope))])];
            
            IS_slope_sing = [max([max(max(linISslope)) max(max(miISslope)) max(max(mediISslope)) max(max(maskISslope))]), min([min(min(linISslope)) min(min(miISslope)) min(min(mediISslope)) min(min(maskISslope))])];
                   
            
            %% IV plots
            if isPlot_IV
                figure('Renderer', 'painters', 'Position', fs_Heatmap_supp,'Name','IV - Single Gap')

                % STD
                subplot('Position',pos5_hms)
                h1 = heatmap(linIVstd,'ColorLimits',[iv_std_l iv_std_u],'Colormap',spring);
                h1.NodeChildren(3).YDir='normal';
                h1.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = nan(size(CustomXLabels));%CustomXLabels;
                CustomYLabels = string(Durs);
                CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
                ax.YDisplayLabels = CustomYLabels;
                ylabel(sprintf('Duration [hr]'))
                hAx=h1.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h1.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                title('Linear')
                set(gca,'FontSize',fontsize)
                s = struct(h1);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos5_hms;
                text(ax, .05, .09, 'A','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos6_hms)
                h2 = heatmap(miIVstd,'ColorLimits',[iv_std_l iv_std_u],'Colormap',spring);
                h2.NodeChildren(3).YDir='normal';
                h2.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = nan(size(CustomXLabels));%CustomXLabels;
                CustomYLabels = string(Durs);
                CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                hAx=h2.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h2.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                title('Mean')
                set(gca,'FontSize',fontsize)
                s = struct(h2);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos6_hms;
                text(ax, .05, .09, 'B','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos7_hms)
                h3 = heatmap(mediIVstd,'ColorLimits',[iv_std_l iv_std_u],'Colormap',spring);
                h3.NodeChildren(3).YDir='normal';
                h3.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = nan(size(CustomXLabels));%CustomXLabels;
                CustomYLabels = string(Durs);
                CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                hAx=h3.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h3.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                title('Median')
                set(gca,'FontSize',fontsize)
                s = struct(h3);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos7_hms;
                text(ax, .05, .09, 'C','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos8_hms)
                h4 = heatmap(maskIVstd,'ColorLimits',[iv_std_l iv_std_u],'Colormap',spring);
                h4.NodeChildren(3).YDir='normal';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = nan(size(CustomXLabels));%CustomXLabels;
                CustomYLabels = string(Durs);
                CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                hAx=h4.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h4.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                title('Masked')
                set(gca,'FontSize',fontsize)
                s = struct(h4);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos8_hms;
                text(ax, .05, .09, 'D','fontweight','bold','fontsize',fontsize_letter)


                % Slope
                subplot('Position',pos9_hms)
                h1 = heatmap(linIVslope,'ColorLimits',[iv_sl_l iv_sl_u],'Colormap',cool);
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
                ylabel(sprintf('Duration [hr]'))
                hAx=h1.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h1.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h1);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos9_hms;
                text(ax, .05, .09, 'E','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos10_hms)
                h2 = heatmap(miIVslope,'ColorLimits',[iv_sl_l iv_sl_u],'Colormap',cool);
                h2.NodeChildren(3).YDir='normal';
                h2.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = CustomXLabels;
                CustomYLabels = string(Durs);
                CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                xlabel('Start Time [hr]')
                hAx=h2.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h2.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h2);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos10_hms;
                text(ax, .05, .09, 'F','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos11_hms)
                h3 = heatmap(mediIVslope,'ColorLimits',[iv_sl_l iv_sl_u],'Colormap',cool);
                h3.NodeChildren(3).YDir='normal';
                h3.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = CustomXLabels;
                CustomYLabels = string(Durs);
                CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                xlabel('Start Time [hr]')
                hAx=h3.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h3.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h3);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos11_hms;
                text(ax, .05, .09, 'G','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos12_hms)
                h4 = heatmap(maskIVslope,'ColorLimits',[iv_sl_l iv_sl_u],'Colormap',cool);
                h4.NodeChildren(3).YDir='normal';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = CustomXLabels;
                CustomYLabels = string(Durs);
                CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                xlabel('Start Time [hr]')
                hAx=h4.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h4.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h4);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos12_hms;
                text(ax, .05, .09, 'H','fontweight','bold','fontsize',fontsize_letter)
            end


            %% IS Plots
            if isPlot_IS
                figure('Renderer', 'painters', 'Position', fs_Heatmap_supp,'Name','IS - Single Gap')

                % STD
                subplot('Position',pos5_hms)
                h5 = heatmap(linISstd,'ColorLimits',[is_std_l is_std_u],'Colormap',spring);
                h5.NodeChildren(3).YDir='normal';
                h5.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = nan(size(CustomXLabels));%CustomXLabels;
                CustomYLabels = string(Durs);
                CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
                ax.YDisplayLabels = CustomYLabels;
                ylabel(sprintf('Duration [hr]'))
                hAx=h5.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                title('Linear')
                hCB=h5.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h5);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos5_hms;
                text(ax, .05, .09, 'A','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos6_hms)
                h6 = heatmap(miISstd,'ColorLimits',[is_std_l is_std_u],'Colormap',spring);
                h6.NodeChildren(3).YDir='normal';
                h6.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = nan(size(CustomXLabels));%CustomXLabels;
                CustomYLabels = string(Durs);
                CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                hAx=h6.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h6.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                title('Mean')
                set(gca,'FontSize',fontsize)
                s = struct(h6);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos6_hms;
                text(ax, .05, .09, 'B','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos7_hms)
                h7 = heatmap(mediISstd,'ColorLimits',[is_std_l is_std_u],'Colormap',spring);
                h7.NodeChildren(3).YDir='normal';
                h7.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = nan(size(CustomXLabels));%CustomXLabels;
                CustomYLabels = string(Durs);
                CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                hAx=h7.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h7.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                title('Median')
                set(gca,'FontSize',fontsize)
                s = struct(h7);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos7_hms;
                text(ax, .05, .09, 'C','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos8_hms)
                h8 = heatmap(maskISstd,'ColorLimits',[is_std_l is_std_u],'Colormap',spring);
                h8.NodeChildren(3).YDir='normal';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = nan(size(CustomXLabels));%CustomXLabels;
                CustomYLabels = string(Durs);
                CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                title('Masked')
                hAx=h8.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h8.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h8);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos8_hms;
                text(ax, .05, .09, 'D','fontweight','bold','fontsize',fontsize_letter)

                % Slope
                subplot('Position',pos9_hms)
                h5 = heatmap(linISslope,'ColorLimits',[is_sl_l is_sl_u],'Colormap',cool);
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
                ylabel(sprintf('Duration [hr]'))
                hAx=h5.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h5.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h5);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos9_hms;
                text(ax, .05, .09, 'E','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos10_hms)
                h6 = heatmap(miISslope,'ColorLimits',[is_sl_l is_sl_u],'Colormap',cool);
                h6.NodeChildren(3).YDir='normal';
                h6.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = CustomXLabels;
                CustomYLabels = string(Durs);
                CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                xlabel('Start Time [hr]')
                hAx=h6.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h6.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h6);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos10_hms;
                text(ax, .05, .09, 'F','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos11_hms)
                h7 = heatmap(mediISslope,'ColorLimits',[is_sl_l is_sl_u],'Colormap',cool);
                h7.NodeChildren(3).YDir='normal';
                h7.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = CustomXLabels;
                CustomYLabels = string(Durs);
                CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                xlabel('Start Time [hr]')
                hAx=h7.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h7.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h7);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos11_hms;
                text(ax, .05, .09, 'G','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos12_hms)
                h6 = heatmap(maskISslope,'ColorLimits',[is_sl_l is_sl_u],'Colormap',cool);
                h6.NodeChildren(3).YDir='normal';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = CustomXLabels;
                CustomYLabels = string(Durs);
                CustomYLabels(mod([2:length(Durs)+1],2) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                xlabel('Start Time [hr]')
                hAx=h6.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h6.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h6);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos12_hms;
                text(ax, .05, .09, 'H','fontweight','bold','fontsize',fontsize_letter)
            end

        end
    end

    %% Mult Gap
    if ismult
        clear T
        load(fullfile(baseDir,IVIS_mult_path))

        ind_s = ones( length(T.Subject),1); 
        for sss = 1:length(S)
            iii = strcmp(T.Subject,S{sss});
            ind_s(iii) = 0;
        end
        ind_s = logical(ind_s);

        T = T(ind_s,:);

        Days = unique(T.Day);
        Spacing = unique(T.Spacing);
        Starts = unique(T.StartHr);
        for i = days_plot

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
            IV_std_mult = [max([max(max(linIVstd)) max(max(miIVstd)) max(max(mediIVstd)) max(max(maskIVstd))]), min([min(min(linIVstd)) min(min(miIVstd)) min(min(mediIVstd)) min(min(maskIVstd))])];
            
            IS_std_mult = [max([max(max(linISstd)) max(max(miISstd)) max(max(mediISstd)) max(max(maskISstd))]), min([min(min(linISstd)) min(min(miISstd)) min(min(mediISstd)) min(min(maskISstd))])];
            
            IV_slope_mult = [max([max(max(linIVslope)) max(max(miIVslope)) max(max(mediIVslope)) max(max(maskIVslope))]), min([min(min(linIVslope)) min(min(miIVslope)) min(min(mediIVslope)) min(min(maskIVslope))])];
            
            IS_slope_mult = [max([max(max(linISslope)) max(max(miISslope)) max(max(mediISslope)) max(max(maskISslope))]), min([min(min(linISslope)) min(min(miISslope)) min(min(mediISslope)) min(min(maskISslope))])];
                   

            %% IV plots
            if isPlot_IV
                figure('Renderer', 'painters', 'Position', fs_Heatmap_supp,'Name','IV - Multi Gap')

                % STD
                subplot('Position',pos5_hms)
                h1 = heatmap(linIVstd,'ColorLimits',[iv_std_l iv_std_u],'Colormap',spring);
                h1.NodeChildren(3).YDir='normal';
                h1.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = nan(size(CustomXLabels));%CustomXLabels;
                CustomYLabels = string(Spacing);
                CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
                ax.YDisplayLabels = CustomYLabels;
                ylabel(sprintf('Duration [hr]'))
                hAx=h1.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h1.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                title('Linear')
                set(gca,'FontSize',fontsize)
                s = struct(h1);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos5_hms;
                text(ax, .05, .09, 'A','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos6_hms)
                h2 = heatmap(miIVstd,'ColorLimits',[iv_std_l iv_std_u],'Colormap',spring);
                h2.NodeChildren(3).YDir='normal';
                h2.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = nan(size(CustomXLabels));%CustomXLabels;
                CustomYLabels = string(Spacing);
                CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                title('Mean')
                hAx=h2.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h2.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h2);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos6_hms;
                text(ax, .05, .09, 'B','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos7_hms)
                h3 = heatmap(mediIVstd,'ColorLimits',[iv_std_l iv_std_u],'Colormap',spring);
                h3.NodeChildren(3).YDir='normal';
                h3.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = nan(size(CustomXLabels));%CustomXLabels;
                CustomYLabels = string(Spacing);
                CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                hAx=h3.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h3.NodeChildren(2); 
                title('Median')% the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h3);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos7_hms;
                text(ax, .05, .09, 'C','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos8_hms)
                h4 = heatmap(maskIVstd,'ColorLimits',[iv_std_l iv_std_u],'Colormap',spring);
                h4.NodeChildren(3).YDir='normal';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = nan(size(CustomXLabels));%CustomXLabels;
                CustomYLabels = string(Spacing);
                CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                hAx=h4.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                title('Masked')
                hCB=h4.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h4);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos8_hms;
                text(ax, .05, .09, 'D','fontweight','bold','fontsize',fontsize_letter)


                % Slope
                
                subplot('Position',pos9_hms)
                h1 = heatmap(linIVslope,'ColorLimits',[iv_sl_l iv_sl_u],'Colormap',cool);
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
                ylabel(sprintf('Duration [hr]'))
                hAx=h1.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h1.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h1);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos9_hms;
                text(ax, .05, .09, 'E','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos10_hms)
                h2 = heatmap(miIVslope,'ColorLimits',[iv_sl_l iv_sl_u],'Colormap',cool);
                h2.NodeChildren(3).YDir='normal';
                h2.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = CustomXLabels;
                CustomYLabels = string(Spacing);
                CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                xlabel('Start Time [hr]')
                hAx=h2.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h2.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h2);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos10_hms;
                text(ax, .05, .09, 'F','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos11_hms)
                h3 = heatmap(mediIVslope,'ColorLimits',[iv_sl_l iv_sl_u],'Colormap',cool);
                h3.NodeChildren(3).YDir='normal';
                h3.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = CustomXLabels;
                CustomYLabels = string(Spacing);
                CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                xlabel('Start Time [hr]')
                hAx=h3.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h3.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h3);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos11_hms;
                text(ax, .05, .09, 'G','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos12_hms)
                h4 = heatmap(maskIVslope,'ColorLimits',[iv_sl_l iv_sl_u],'Colormap',cool);
                h4.NodeChildren(3).YDir='normal';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = CustomXLabels;
                CustomYLabels = string(Spacing);
                CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                %xticks(Starts)
                xlabel('Start Time [hr]')
                hAx=h4.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h4.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h4);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos12_hms;
                text(ax, .05, .09, 'H','fontweight','bold','fontsize',fontsize_letter)
            end


            %% IS Plots
            if isPlot_IS
                figure('Renderer', 'painters', 'Position', fs_Heatmap_supp,'Name','IS - Multi Gap')

                % STD
                subplot('Position',pos5_hms)
                h5 = heatmap(linISstd,'ColorLimits',[is_std_l is_std_u],'Colormap',spring);
                h5.NodeChildren(3).YDir='normal';
                h5.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = nan(size(CustomXLabels));%CustomXLabels;
                CustomYLabels = string(Spacing);
                CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
                ax.YDisplayLabels = CustomYLabels;
                title('Linear')
                ylabel(sprintf('Duration [hr]'))
                hAx=h5.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h5.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h5);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos5_hms;
                text(ax, .05, .09, 'A','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos6_hms)
                h6 = heatmap(miISstd,'ColorLimits',[is_std_l is_std_u],'Colormap',spring);
                h6.NodeChildren(3).YDir='normal';
                h6.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = nan(size(CustomXLabels));%CustomXLabels;
                CustomYLabels = string(Spacing);
                CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                title('Mean')
                hAx=h6.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h6.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h6);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos6_hms;
                text(ax, .05, .09, 'B','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos7_hms)
                h7 = heatmap(mediISstd,'ColorLimits',[is_std_l is_std_u],'Colormap',spring);
                h7.NodeChildren(3).YDir='normal';
                h7.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = nan(size(CustomXLabels));%CustomXLabels;
                CustomYLabels = string(Spacing);
                CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                hAx=h7.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                title('Median')
                hCB=h7.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h7);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos7_hms;
                text(ax, .05, .09, 'C','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos8_hms)
                h6 = heatmap(maskISstd,'ColorLimits',[is_std_l is_std_u],'Colormap',spring);
                h6.NodeChildren(3).YDir='normal';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = nan(size(CustomXLabels));%CustomXLabels;
                CustomYLabels = string(Spacing);
                CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                hAx=h6.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                title('Masked')
                hCB=h6.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h6);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos8_hms;
                text(ax, .05, .09, 'D','fontweight','bold','fontsize',fontsize_letter)

                % Slope
                subplot('Position',pos9_hms)
                h5 = heatmap(linISslope,'ColorLimits',[is_sl_l is_sl_u],'Colormap',cool);
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
                ylabel(sprintf('Duration [hr]'))
                hAx=h5.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h5.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h5);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos9_hms;
                text(ax, .05, .09, 'E','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos10_hms)
                h6 = heatmap(miISslope,'ColorLimits',[is_sl_l is_sl_u],'Colormap',cool);
                h6.NodeChildren(3).YDir='normal';
                h6.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = CustomXLabels;
                CustomYLabels = string(Spacing);
                CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                xlabel('Start Time [hr]')
                hAx=h6.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h6.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h6);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos10_hms;
                text(ax, .05, .09, 'F','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos11_hms)
                h8 = heatmap(mediISslope,'ColorLimits',[is_sl_l is_sl_u],'Colormap',cool);
                h8.NodeChildren(3).YDir='normal';
                h8.ColorbarVisible = 'off';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = CustomXLabels;
                CustomYLabels = string(Spacing);
                CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                xlabel('Start Time [hr]')
                hAx=h8.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h8.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h8);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos11_hms;
                text(ax, .05, .09, 'G','fontweight','bold','fontsize',fontsize_letter)

                subplot('Position',pos12_hms)
                h6 = heatmap(maskISslope,'ColorLimits',[is_sl_l is_sl_u],'Colormap',cool);
                h6.NodeChildren(3).YDir='normal';
                ax = gca;
                CustomXLabels = string(Starts);
                CustomXLabels(mod([2:length(Starts)+1],2) ~= 0) = " ";
                ax.XDisplayLabels = CustomXLabels;
                CustomYLabels = string(Spacing);
                CustomYLabels(mod([2:length(Spacing)+1],yspacing) ~= 0) = " ";
                ax.YDisplayLabels = nan(size(CustomYLabels));%CustomYLabels;
                xlabel('Start Time [hr]')
                hAx=h6.NodeChildren(3);          % return the heatmap underlying axes handle
                hAx.FontWeight='bold';
                hCB=h6.NodeChildren(2);          % the wanted colorbar handle
                hCB.FontWeight='bold';
                set(gca,'FontSize',fontsize)
                s = struct(h6);
                s.XAxis.TickLabelRotation = xrot;
                ax = axes;
                ax.Color = 'none';
                ax.XTick = [];
                ax.YTick = [];
                ax.Position = pos12_hms;
                text(ax, .05, .09, 'H','fontweight','bold','fontsize',fontsize_letter)
            end

        end    
    end
end

