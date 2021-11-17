%% Paper Figures

%% Load Data
baseDir = 'C:\Users\Laraw\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\';

% Data
load(fullfile(baseDir,'Organized\dataOrganized.mat'))

% Masks
load(fullfile(baseDir,'Masks\masksAllt2-2.mat'))

% IVIS
load(fullfile(baseDir,'Imputation\impT20211112.mat'))

%% Plot Flags
isplot_starthr = 0;
isplot_exData = 1;
isplot_singleGapHeatmap = 0;
isplot_IVISDist = 0;

%% Distribution of starting Days/hours
if isplot_starthr
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

%% Example of True/Mask/imputed Data
if isplot_exData
    % Set Vars
    subjects = unique(masks.subject);
    for i = 1:length(subjects)
        %clear act_full act t
        fprintf('%d - %s\n',i,subjects{i})
        m = masks(strcmp(masks.subject,subjects{i}),:);

        act_full = data.(subjects{i}).acc;
        t = data.(subjects{i}).t;

        jjj = find(m.startHr == 10 & m.dur == 5);

        for j = jjj(1)%1%:size(m,1)
            fprintf('    Mask %d of %d\n',j,size(m,1))
            %clear act
            %% -------------------------- Apply Mask --------------------------- %%
                if ~isnan(m.start_ind(j)) && ~isnan(m.end_ind(j))        
                    %% ----------------------- Compute Imputation ---------------------- %%
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

        figure('Renderer', 'painters', 'Position', [100 100 900 600])
        ax(1) = subplot(4,1,1);
        area([t(m.start_ind(j)) t(m.end_ind(j))],[max(act_full(ind)), max(act_full(ind))],'facecolor',[.8,1,.8], ...
        'facealpha',.5,'edgecolor','none', 'basevalue',0);
        hold on
        plot(t(ind),act_full(ind))
        title('Full Data')
        xlabel('Time (s)')
        ylabel('Actigraphy')
        
        ax(2) = subplot(4,1,2);
        area([t(m.start_ind(j)) t(m.end_ind(j))],[max(act_full(ind)), max(act_full(ind))],'facecolor',[.8,1,.8], ...
        'facealpha',.5,'edgecolor','none', 'basevalue',0);
        hold on
        plot(t(ind),linInterpimputed(ind))
        title('Linear Interpolation')
        xlabel('Time (s)')
        ylabel('Actigraphy')
        ax(3) = subplot(4,1,3);
        area([t(m.start_ind(j)) t(m.end_ind(j))],[max(act_full(ind)), max(act_full(ind))],'facecolor',[.8,1,.8], ...
        'facealpha',.5,'edgecolor','none', 'basevalue',0);
        hold on
        plot(t(ind),meanimputed(ind))
        title('Mean Imputation')
        xlabel('Time (s)')
        ylabel('Actigraphy')
        ax(4) = subplot(4,1,4);
        area([t(m.start_ind(j)) t(m.end_ind(j))],[max(act_full(ind)), max(act_full(ind))],'facecolor',[.8,1,.8], ...
        'facealpha',.5,'edgecolor','none', 'basevalue',0);
        hold on
        plot(t(ind),medianimputed(ind))
        title('Median Imputation')
        xlabel('Time (s)')
        ylabel('Actigraphy')
        linkaxes(ax,'xy')
        axis tight

    end
end

%% Single Gap Heatmaps
if isplot_singleGapHeatmap
    Days = unique(T.Day);
    Durs = unique(T.Dur);
    Starts = unique(T.StartHr);

    for i = 1:length(Days)
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

                linIV(k,j) = nanmean(T.IV_linimp(ind))-nanmean(T.IV_comp(ind));
                miIV(k,j) = nanmean(T.IV_mimp(ind))-nanmean(T.IV_comp(ind));
                linIS(k,j) = nanmean(T.IS_linimp(ind))-nanmean(T.IS_comp(ind));
                miIS(k,j) = nanmean(T.IS_mimp(ind))-nanmean(T.IS_comp(ind));
                maskIV(k,j) = nanmean(T.IV_mask(ind))-nanmean(T.IV_comp(ind));
                maskIS(k,j) = nanmean(T.IS_mask(ind))-nanmean(T.IS_comp(ind));
                mediIV(k,j) = nanmean(T.IV_medimp(ind))-nanmean(T.IV_comp(ind));
                mediIS(k,j) = nanmean(T.IS_medimp(ind))-nanmean(T.IS_comp(ind));


            end
        end
        iv_mm = max(abs([min(min(linIV)),max(max(linIV)),min(min(miIV)),max(max(miIV)),min(min(maskIV)),max(max(maskIV)),min(min(mediIV)),max(max(mediIV))]));
        is_mm = max(abs([min(min(linIS)),max(max(linIS)),min(min(miIS)),max(max(miIS)),min(min(maskIS)),max(max(maskIS)),min(min(mediIS)),max(max(mediIS))]));

        iv_ma = 0.25;
        is_ma = 0.18;

        %max(max(abs(maskIS)))
        %max(max(abs(maskIV)))

        figure('Renderer', 'painters', 'Position', [100 100 800 400])
        subplot(1,4,1)
        h1 = heatmap(linIV,'ColorLimits',[-iv_mm iv_mm],'Colormap',jet);
        h1.NodeChildren(3).YDir='normal';
        ax = gca;
        ax.XDisplayLabels = num2cell(Starts);
        ax.YDisplayLabels = num2cell(Durs);
        %xticks(Starts)
        xlabel('Start Time')
        %xticks(Durs)
        ylabel('Duration')
        title(sprintf('Lin Imputation IV - Day %d',Days(i)))

        subplot(1,4,2)
        h2 = heatmap(miIV,'ColorLimits',[-iv_mm iv_mm],'Colormap',jet);
        h2.NodeChildren(3).YDir='normal';
        ax = gca;
        ax.XDisplayLabels = num2cell(Starts);
        ax.YDisplayLabels = num2cell(Durs);
        %xticks(Starts)
        xlabel('Start Time')
        %xticks(Durs)
        ylabel('Duration')
        title(sprintf('Mean Imputation IV - Day %d',Days(i)))

        subplot(1,4,3)
        h3 = heatmap(mediIV,'ColorLimits',[-iv_mm iv_mm],'Colormap',jet);
        h3.NodeChildren(3).YDir='normal';
        ax = gca;
        ax.XDisplayLabels = num2cell(Starts);
        ax.YDisplayLabels = num2cell(Durs);
        %xticks(Starts)
        xlabel('Start Time')
        %xticks(Durs)
        ylabel('Duration')
        title(sprintf('Median Imputation IV - Day %d',Days(i)))

        subplot(1,4,4)
        h4 = heatmap(maskIV,'ColorLimits',[-iv_mm iv_mm],'Colormap',jet);
        h4.NodeChildren(3).YDir='normal';
        ax = gca;
        ax.XDisplayLabels = num2cell(Starts);
        ax.YDisplayLabels = num2cell(Durs);
        %xticks(Starts)
        xlabel('Start Time')
        %xticks(Durs)
        ylabel('Duration')
        title(sprintf('Masked IV - Day %d',Days(i)))

        %%
        figure('Renderer', 'painters', 'Position', [100 100 800 400])
        subplot(1,4,1)
        h5 = heatmap(linIS,'ColorLimits',[-is_mm is_mm],'Colormap',jet);
        h5.NodeChildren(3).YDir='normal';
        ax = gca;
        ax.XDisplayLabels = num2cell(Starts);
        ax.YDisplayLabels = num2cell(Durs);
        %xticks(Starts)
        xlabel('Start Time')
        %xticks(Durs)
        ylabel('Duration')
        title(sprintf('Lin Imputation IS - Day %d',Days(i)))

        subplot(1,4,2)
        h6 = heatmap(miIS,'ColorLimits',[-is_mm is_mm],'Colormap',jet);
        h6.NodeChildren(3).YDir='normal';
        ax = gca;
        ax.XDisplayLabels = num2cell(Starts);
        ax.YDisplayLabels = num2cell(Durs);
        %xticks(Starts)
        xlabel('Start Time')
        %xticks(Durs)
        ylabel('Duration')
        title(sprintf('Mean Imputation IS - Day %d',Days(i)))

        subplot(1,4,3)
        h7 = heatmap(mediIS,'ColorLimits',[-is_mm is_mm],'Colormap',jet);
        h7.NodeChildren(3).YDir='normal';
        ax = gca;
        ax.XDisplayLabels = num2cell(Starts);
        ax.YDisplayLabels = num2cell(Durs);
        %xticks(Starts)
        xlabel('Start Time')
        %xticks(Durs)
        ylabel('Duration')
        title(sprintf('Median Imputation IS - Day %d',Days(i)))

        subplot(1,4,4)
        h6 = heatmap(maskIS,'ColorLimits',[-is_mm is_mm],'Colormap',jet);
        h6.NodeChildren(3).YDir='normal';
        ax = gca;
        ax.XDisplayLabels = num2cell(Starts);
        ax.YDisplayLabels = num2cell(Durs);
        %xticks(Starts)
        xlabel('Start Time')
        %xticks(Durs)
        ylabel('Duration')
        title(sprintf('Masked IS - Day %d',Days(i)))


    end
end

%% Distribution of IV and IS Scores for complete files
if isplot_IVISDist
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







