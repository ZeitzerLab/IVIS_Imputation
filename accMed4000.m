%% Imputation over gaps and 4000+ acc values

Dpath = 'C:\Users\Laraw\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\Raw\Files_accelerating_4000';
d = dir(Dpath);

fn = {d.name}';
fn = fn(3:end);

%fn = gunzip('*.gz');

for i = 1:length(fn)
    fprintf('%d - %s\n',i,fn{i})
    dt = readtable(fullfile(Dpath,fn{i}),'Delimiter', ',');
    dt2 = readtable(fullfile(Dpath,fn{i}));
    ttt=[];
    for jj = 1:length(dt2.Var2)
        ttt = [ttt;datetime(dt2.Var1(jj)) + duration(dt2.Var2{jj}(1:12))];
    end
    
    notGap_ind = ~(dt.imputed | dt.acc>4000);
    gaps = gapDur(notGap_ind);
    acc_med4000 = medianImputation(dt.acc,ttt,gaps);
    dt.acc_med4000 = acc_med4000;
    
%     figure
%     plot(dt.acc)
%     hold on
%     plot(acc_med4000) 
%     title(fn{i})
%     pause(.01)
    
    writetable(dt,fullfile(Dpath,fn{i}),'Delimiter',',')  
end








