%% Visualize Raw Data

%% Load Data

load('C:\Users\Lara\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\Organized\dataOrganized.mat')

subjects = fields(data);
startdays = [];
for i = 1:length(subjects)
    startdays(i) = weekday(data.(subjects{i}).t(1));
    
    figure
    plot(data.(subjects{i}).t,data.(subjects{i}).acc)
    title(subjects{i})
end



