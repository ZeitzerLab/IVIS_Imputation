%% Mask Gen - 2 masks with varying startimes and spacing
% Lara Weed 17 OCT 2021

%% Load Paths
% Complete Data
if exist('data','var') == 0
    load('C:\Users\Lara\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\Organized\dataOrganized.mat');
end

%%
subjects = fields(data);
start_ind1 = [];
start_ind2 = [];
end_ind1 = [];
end_ind2 = [];
day1 = [];
day2 = [];
startHr1 = [];
startHr2 = [];
dur1 = [];
dur2 = [];
spacing = [];
subject = [];
parfor i = 1:length(subjects)
    fprintf('%d - %s\n',i,subjects{i})
    t =  data.(subjects{i}).t;
    
    % Data must be a week long and the first collection from a subject 
    if t(end) - t(1) == duration(167,59,00) && strcmp(subjects{i}(end-2:end),'0_0')
        hrs = hour(t);
        dayNum = weekday(t);
        
        for j = 1:7 % day of week
            fprintf('    Day %d\n',j)
            for k = 0:2:24 % Start time
                for q = 3:2:167%[115/60,140/60]   %1:2:24 % duration 
                    day_ind = dayNum == j;
                    s_ind1 = find(day_ind & hrs==k,1);
                    if isempty(s_ind1)
                        s_ind1 = nan;
                        e_ind1 = nan;
                    else
                        e_ind1 = find(t == t(s_ind1) + minutes(115),1,'last');
                    end
                        
                    if k + q < 24
                        s_ind2 = find(day_ind & hrs==k+q,1,'last');
                        sh2 = k+q;
                        dj2 = j;
                        if isempty(s_ind2)
                            s_ind2 = nan;
                            e_ind2 = nan;
                        else
                            e_ind2 = find(t == t(s_ind2) + minutes(140),1,'last');
                            if isempty(e_ind2)
                                 e_ind2 = nan;
                            end                   
                        end
                    else
                        s_ind2 = find(dayNum == j+1 & hrs==k+q-24,1,'last'); 
                        sh2 = k+q-24;
                        if j ~= 7
                            dj2 = j+1;
                        else
                            dj2 = 1;
                        end
                        if isempty(s_ind2)
                            s_ind2 = nan;
                            e_ind2 = nan;
                        else
                            e_ind2 = find(t == t(s_ind2) + minutes(140),1,'last');
                            if isempty(e_ind2)
                                 e_ind2 = nan;
                            end 
                        end
                    end
                    
                    start_ind1 = [start_ind1;s_ind1];
                    start_ind2 = [start_ind2;s_ind2];
                    startHr1 = [startHr1;k];
                    startHr2 = [startHr2;sh2];
                    day1 = [day1;j];
                    day2 = [day2;dj2];
                    spacing = [spacing; q]; 
                    subject = [subject;subjects(i)];
                    end_ind1 = [end_ind1;e_ind1];
                    end_ind2 = [end_ind2;e_ind2];
                    dur1 = [dur1;115];
                    dur2 = [dur2;140];
  
                end
            end
        end
    end

%          figure
%          plot(t,act)
%          ylim([0 2500])
end

masks = table(subject,spacing,day1,dur1,startHr1,start_ind1,end_ind1,day2,dur2,startHr2,start_ind2,end_ind2);
masks = rmmissing(masks);
save_fn = 'C:\Users\Lara\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\Masks\masks2gapSweep_20211104_2.mat';
save(save_fn, 'masks') 




