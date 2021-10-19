function [IV,IS] = calcIVIS(act,t)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% IS calculation
N = length(act);
p = hours(24)/(t(2)-t(1));
X_bar = nanmean(act);
h_ind = (24*(day(t)-1) + hour(t)) - min((24*(day(t)-1) + hour(t))) + 1;
X_h = nan(max(h_ind),1);
for h = 1:max(h_ind)
    X_h(h) = nanmean(act(h_ind == h));  
end
topIS =nansum((X_h - X_bar).^2);
bottomIS = nansum((act-X_bar).^2);

IS = (N*topIS)./(p*bottomIS);

% IV calculation
topIV = N*nansum(diff(act).^2);
bottomIV = (N-1)*nansum((X_bar-act).^2);

IV = topIV./bottomIV;


end

