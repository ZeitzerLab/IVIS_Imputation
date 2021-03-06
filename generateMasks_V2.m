%% Mask Gen
% Lara Weed 17 OCT 2021

%% Load Paths
% Complete Data
if exist('data','var') == 0
    load('C:\Users\Lara\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\Organized\dataOrganized.mat');
end

%%
subjects = fields(data);
start_ind = [];
end_ind = [];
day = [];
startHr = [];
dur = [];
subject = [];
parfor i = 1:length(subjects)
    
    act = data.(subjects{i}).acc;
    t =  data.(subjects{i}).t;
    
    % Data must be a week long and the first collection from a subject 
    if t(end) - t(1) == duration(167,59,00) && (strcmp(subjects{i}(end-2:end),'0_0') || strcmp(subjects{i}(end-2:end),'4_0'))
        fprintf('%d - %s\n',i,subjects{i})
        hrs = hour(t);
        dayNum = weekday(t);
    
        
        for j = 1:7 % day of week
            %fprintf('    Day %d\n',j)
            for k = 0:2:24%[8,12,18]% 0:2:24 % Start time
                for q = 1:2:24%[115/60,140/60]   %1:2:24 % duration 
                    day_ind = dayNum == j;
                    s_ind = find(day_ind & hrs==k,1);
                    if isempty(s_ind)
                        s_ind = nan;
                    end
                        
                    if k + q < 24
                        e_ind = find(day_ind & hrs<=k+q,1,'last');  
                        if isempty(e_ind)
                            e_ind = nan;
                        end
                    else
                        e_ind = find(dayNum == j+1 & hrs<=k+q-24,1,'last'); 
                        if isempty(e_ind)
                            e_ind = nan;
                        end
                    end
                    end_ind = [end_ind;e_ind];
                    start_ind = [start_ind;s_ind];
                    day = [day;j];
                    startHr = [startHr;k];
                    dur = [dur;q];
                    subject = [subject;subjects(i)];
                    
                end
            end
        end
    else
        fprintf('%d - %s - ERROR\n',i,subjects{i})
    end
end

%          figure
%          plot(t,act)
%          ylim([0 2500])

masks = table(subject,day,dur,startHr,start_ind,end_ind);
save_fn = 'C:\Users\Lara\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\Masks\masksAllt2-20220318.mat';
save(save_fn, 'masks') 







