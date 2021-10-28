function [IV,IS] = calcIVIS(act,t)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% IS calculation
N = length(act);
p = hours(24)/(t(2)-t(1));
X_bar = mean(act);
h_ind = hour(t);%(24*(day(t)-1) + hour(t)) - min((24*(day(t)-1) + hour(t))) + 1;
hi_ind = (24*(day(t)-1) + hour(t)) - min((24*(day(t)-1) + hour(t))) + 1;

X_i = nan(max(hi_ind),1);
for h = 1:max(hi_ind)
    X_i(h) = mean(act(hi_ind == h));   
end

X_h = nan(max(h_ind),1);
for hh = 1:length(unique(h_ind))
    X_h(hh) = mean(act(h_ind == hh-1));   
end

topIS =sum((X_h - X_bar).^2);
bottomIS = sum((X_i-X_bar).^2);%sum((act-X_bar).^2);

IS = (N*topIS)./(p*bottomIS);

% IV calculation
topIV = sum(diff(X_i).^2);
bottomIV = sum((X_i-X_bar).^2);%sum((act-X_bar).^2);

IV = N*topIV./((N-1)*bottomIV);


end

