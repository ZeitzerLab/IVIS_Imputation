%% Mean Actigraphy Day
% Lara Weed 11 NOV 2021

%% Load Data
% Data
load('C:\Users\Lara\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\Organized\dataOrganized.mat')

subjects = fields(data);
for i = 1:length(subjects)
    %clear act_full act t
    fprintf('%d - %s\n',i,subjects{i})
    
    act = data.(subjects{i}).acc;
    t = data.(subjects{i}).t;
    fs = median(seconds(1)./diff(t));
    tmins = 60*hour(t)+minute(t)+(second(t)./60);
    
    times = unique(tmins);
    dayMin = nan(1,length(times)); 
    
    for j = 1:length(times)
        dayMin(j) = mean(act(tmins == times(j)));
    end 
    Subject =  {subjects{i}};   
    T = [table(Subject),array2table(dayMin)];

end