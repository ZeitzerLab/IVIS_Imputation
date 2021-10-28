function [IV,IS] = calcIVIS(act,t)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


%% IS calculation
N = length(act);
p = hours(24)/(t(2)-t(1));
X_bar = mean(act);
h_ind = (24*(day(t)-1) + hour(t)) - min((24*(day(t)-1) + hour(t))) + 1;
X_h = nan(max(h_ind),1);
for h = 1:max(h_ind)
    X_h(h) = mean(act(h_ind == h));  
end
top =sum((X_h - X_bar).^2);
bottom = sum((act-X_bar).^2);

IS = (N*top)./(p*bottom);
end

