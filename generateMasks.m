%% Mask Gen
% Lara Weed 17 OCT 2021

%% Load Paths
% Complete Data
if exist('data','var') == 0
    load('C:\Users\Laraw\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\Organized\dataOrganized.mat');
end

%%
subjects = fields(data);

for i = 1:length(subjects)
    fprintf('%d - %s\n',i,subjects{i})
    act = data.(subjects{i}).acc;
    t =  data.(subjects{i}).t;
    
    % Data must be a week long 
    if t(end) - t(1) == duration(167,59,00)
        hrs = hour(t);
        dayNum = weekday(t);
        
        ind = [];
        day = [];
        startHr = [];
        dur = [];
        
        n = 1;
        for j = [4,7] %1:length(dayNum) % day of week
            fprintf('    Day %d\n',j)
            for k = 0:2:24 % Start time
                for q = 1:2:24 % duration 
                    day_ind = dayNum == j;
                    if k + q < 24
                        mask = day_ind & hrs>=k & hrs<=k+q;
                    else
                        mask_day1 = day_ind & hrs>=k & hrs<=24;
                        mask_day2 = dayNum == j+1 & hrs>=0 & hrs<=k+q-24;
                        mask = mask_day1 | mask_day2;
                    end
                    ind = [ind,mask];
                    day = [day;j];
                    startHr = [startHr;k];
                    dur = [dur;q];
                    
                    n = n+1;
                end
            end
        end
    end
    masks.(subjects{i}).ind = ind;
    masks.(subjects{i}).type = [day,startHr,dur];

%          figure
%          plot(t,act)
%          ylim([0 2500])
end










