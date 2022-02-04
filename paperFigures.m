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
isplot_exampleImputation = 0;
isplot_exampleBlandAltman = 1;



isplot_starthr = 0;
isplot_IVISDist = 0;


%% Example of True/Mask/imputed Data
if isplot_exampleImputation
    font = 16;
    lw = 1.5;
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
        area([t(m.start_ind(j)) t(m.end_ind(j))],[max(act_full(ind)), max(act_full(ind))],'facecolor',[.9,0,.8], ...
        'facealpha',.2,'edgecolor','none', 'basevalue',0);
        hold on
        plot(t(ind),act_full(ind),'k','linewidth',lw)
        %title('Full Data')
        set(gca,'XTick',[])
        %ylabel('Actigraphy')
        set(gca,'fontweight','bold','fontsize',font)
        
        ax(2) = subplot(4,1,2);
        area([t(m.start_ind(j)) t(m.end_ind(j))],[max(act_full(ind)), max(act_full(ind))],'facecolor',[.9,0,.8], ...
        'facealpha',.2,'edgecolor','none', 'basevalue',0);
        hold on
        plot(t(ind),linInterpimputed(ind),'k','linewidth',lw)
        %title('Linear Interpolation')
        %ylabel('Actigraphy')
        set(gca,'XTick',[])
        set(gca,'fontweight','bold','fontsize',font)
        
        ax(3) = subplot(4,1,3);
        area([t(m.start_ind(j)) t(m.end_ind(j))],[max(act_full(ind)), max(act_full(ind))],'facecolor',[.9,0,.8], ...
        'facealpha',.2,'edgecolor','none', 'basevalue',0);
        hold on
        plot(t(ind),meanimputed(ind),'k','linewidth',lw)
        %title('Mean Imputation')
        ylabel('                  Activity [Counts]')
        set(gca,'XTick',[])
        set(gca,'fontweight','bold','fontsize',font)
        
        ax(4) = subplot(4,1,4);
        area([t(m.start_ind(j)) t(m.end_ind(j))],[max(act_full(ind)), max(act_full(ind))],'facecolor',[.9,0,.8], ...
        'facealpha',.2,'edgecolor','none', 'basevalue',0);
        hold on
        plot(t(ind),medianimputed(ind),'k','linewidth',lw)
        %title('Median Imputation')
        xlabel('Time [s]')
        %ylabel('Actigraphy')
        set(gca,'fontweight','bold','fontsize',font)
        
        linkaxes(ax,'xy')
        axis tight

    end
end

%% Example Bland Altman Plot
if isplot_exampleBlandAltman 
    font = 14;
    lw = 1.5;
    ms = 10;
    % Set Vars
    %clear act_full act t
    dt = T(T.StartHr == 10 & T.Dur == 5 & T.Day == 1,:);
    
    % IV values
    masked_y = dt.IV_mask -  dt.IV_comp;
    meanimp_y =  dt.IV_mimp -  dt.IV_comp;
    medimp_y = dt.IV_medimp -  dt.IV_comp;
    linint_y = dt.IV_linimp -  dt.IV_comp; 
    
    masked_x = (dt.IV_mask + dt.IV_comp)/2;
    meanimp_x =  (dt.IV_mimp +  dt.IV_comp)/2;
    medimp_x = (dt.IV_medimp +  dt.IV_comp)/2;
    linint_x = (dt.IV_linimp +  dt.IV_comp)/2; 
    
    
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
    
    figure('Renderer', 'painters', 'Position', [100 100 1300 400])
    ax(1) = subplot(1,4,1);
    hold on
    plot(xl,yl,'.b','markersize',ms)
    %plot([0 max(x)+.1],[0 0],'--k')
    plot([0 max(xl)+.1],[nanmean(yl) nanmean(yl)],'k','linewidth',lw)
    plot([0 max(xl)+.1],[nanmean(yl)+1.96*nanstd(yl) nanmean(yl)+1.96*nanstd(yl)],'--k','linewidth',lw)
    plot([0 max(xl)+.1],[nanmean(yl)-1.96*nanstd(yl) nanmean(yl)-1.96*nanstd(yl)],'--k','linewidth',lw)
     idx = ~isnan(xl) & ~isnan(yl);
     p = polyfit(xl(idx),yl(idx),1);
     y_sll = polyval(p,xl);
     plot(xl,y_sll);
    ylabel('Difference from True')
    xlabel(sprintf('Linear Interpolation & True\nAverage'))
    title('Linear Interpolation')
    txt1 = sprintf('Mean:\n%f',nanmean(yl));
    text(.025,nanmean(yl),txt1,'HorizontalAlignment','left')
    txt2 = sprintf('+1.96SD:\n%f',nanmean(yl)+1.96*nanstd(yl));
    text(.025,nanmean(yl)+1.96*nanstd(yl),txt2,'HorizontalAlignment','left')
    txt3 = sprintf('-1.96SD:\n%f',nanmean(yl)-1.96*nanstd(yl));
    text(.025,nanmean(yl)-1.96*nanstd(yl),txt3,'HorizontalAlignment','left')
%     xlim([0 max(x)+.1])
%     ylim([-(max(y)+.05) max(y)+.05])
    grid on
    set(gca, 'fontweight','bold','fontsize',font)
    
    ax(2) = subplot(1,4,2);
    hold on
    plot(xm,ym,'.g','markersize',ms)
    %plot([0 max(x)+.1],[0 0],'--k')
    plot([0 max(xm)+.1],[nanmean(ym) nanmean(ym)],'k','linewidth',lw)
    plot([0 max(xm)+.1],[nanmean(ym)+1.96*nanstd(ym) nanmean(ym)+1.96*nanstd(ym)],'--k','linewidth',lw)
    plot([0 max(xm)+.1],[nanmean(ym)-1.96*nanstd(ym) nanmean(ym)-1.96*nanstd(ym)],'--k','linewidth',lw)
     idx = ~isnan(xm) & ~isnan(ym);
     p = polyfit(xm(idx),ym(idx),1);
     y_slm = polyval(p,xm);
     plot(xm,y_slm);
    %ylabel('Mean Imputation - True')
    xlabel(sprintf('Mean Imputation & True\nAverage'))
    title('Mean Imputation')
    txt1 = sprintf('Mean:\n%f',nanmean(ym));
    text(.025,nanmean(ym),txt1,'HorizontalAlignment','left')
    txt2 = sprintf('+1.96SD:\n%f',nanmean(ym)+1.96*nanstd(ym));
    text(.025,nanmean(ym)+1.96*nanstd(ym),txt2,'HorizontalAlignment','left')
    txt3 = sprintf('-1.96SD:\n%f',nanmean(ym)-1.96*nanstd(ym));
    text(.025,nanmean(ym)-1.96*nanstd(ym),txt3,'HorizontalAlignment','left')
    grid on
    set(gca, 'fontweight','bold','fontsize',font)
    
    ax(3) = subplot(1,4,3);
    hold on
    plot(x,y,'.r','markersize',ms)
    plot([0 max(x)+.1],[nanmean(y) nanmean(y)],'k','linewidth',lw)
    plot([0 max(x)+.1],[nanmean(y)+1.96*nanstd(y) nanmean(y)+1.96*nanstd(y)],'--k','linewidth',lw)
    plot([0 max(x)+.1],[nanmean(y)-1.96*nanstd(y) nanmean(y)-1.96*nanstd(y)],'--k','linewidth',lw)
     idx = ~isnan(x) & ~isnan(y);
     p = polyfit(x(idx),y(idx),1);
     y_sl = polyval(p,x);
     plot(x,y_sl);
    %ylabel('Median Imputation - True')
    xlabel(sprintf('Median Imputation & True\nAverage'))
    title('Median Imputation')
    txt1 = sprintf('Mean:\n%f',nanmean(y));
    text(.025,nanmean(y),txt1,'HorizontalAlignment','left')
    txt2 = sprintf('+1.96SD:\n%f',nanmean(y)+1.96*nanstd(y));
    text(.025,nanmean(y)+1.96*nanstd(y),txt2,'HorizontalAlignment','left')
    txt3 = sprintf('-1.96SD:\n%f',nanmean(y)-1.96*nanstd(y));
    text(.025,nanmean(y)-1.96*nanstd(y),txt3,'HorizontalAlignment','left')
    grid on
    set(gca, 'fontweight','bold','fontsize',font)
    
    ax(4) = subplot(1,4,4);
    hold on
    plot(xs,ys,'.m','markersize',ms)
    plot([0 max(xs)+.1],[nanmean(ys) nanmean(ys)],'k','linewidth',lw)
    plot([0 max(xs)+.1],[nanmean(ys)+1.96*nanstd(ys) nanmean(ys)+1.96*nanstd(ys)],'--k','linewidth',lw)
    plot([0 max(xs)+.1],[nanmean(ys)-1.96*nanstd(ys) nanmean(ys)-1.96*nanstd(ys)],'--k','linewidth',lw)
     idx = ~isnan(xs) & ~isnan(ys);
     p = polyfit(xs(idx),ys(idx),1);
     y_sls = polyval(p,xs);
     plot(xs,y_sls);
    txt1 = sprintf('Mean:\n%f',nanmean(ys));
    text(.025,nanmean(ys),txt1,'HorizontalAlignment','left')
    txt2 = sprintf('+1.96SD:\n%f',nanmean(y)+1.96*nanstd(ys));
    text(.025,nanmean(ys)+1.96*nanstd(ys),txt2,'HorizontalAlignment','left')
    txt3 = sprintf('-1.96SD:\n%f',nanmean(y)-1.96*nanstd(ys));
    text(.025,nanmean(ys)-1.96*nanstd(ys),txt3,'HorizontalAlignment','left')
    title('Masked')
    %ylabel('Masked - True')
    xlabel(sprintf('Masked & True\nAverage'))
    grid on
    set(gca, 'fontweight','bold','fontsize',font)
    
    linkaxes(ax,'xy')
    xlim([0 max(xm)+.1])
    ylim([-(max(ym)+.01) max(ym)+.01])

end


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







