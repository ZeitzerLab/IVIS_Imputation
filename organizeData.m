%% Organize Data
% Lara Weed

%% Load Data
% Complete Data
dpathC = 'C:\Users\Laraw\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\raw\ukbb_complete';
ddpathC = dir(dpathC);
fnC = {ddpathC.name}';
fnC = fnC(3:end);

subjectsC = {};
for ffC = 1:length(fnC)
    us = find(fnC{ffC}=='_');
    subjectsC{ffC,1} = fnC{ffC}(1:us(3)+1);
end

for i = 1:length(fnC)
    fprintf('%d - %s\n',i,subjectsC{i})
    dt = readtable(fullfile(dpathC,fnC{i}),'Delimiter', ',');
    dt2 = readtable(fullfile(dpathC,fnC{i}));
    ttt=[];
    for jj = 1:length(dt2.Var2)
        ttt = [ttt;datetime(dt2.Var1(jj)) + duration(dt2.Var2{jj}(1:12))];
    end
    
    data.(strcat('S',subjectsC{i})).t = ttt;
    data.(strcat('S',subjectsC{i})).acc = dt.acc;    
end

