%% Missing data Ratios 
% Lara Weed
% 11 Feb 2022

%% 
N = 24*7; % Hours in a week
p = 24; % Hours in a day

hrs = repmat([0:23]',7,1);
allhrs = 1:N;

% IV
IV_norm = N./(N-1);

% IS
IS_norm = N./p;

% Single gap
duration = 1:N-1;
start = 1:N;
gapImpact_IV = zeros(length(duration),length(start));
gapImpact_IS = zeros(length(duration),length(start));
for i = start
    for j = duration
        
        ind = allhrs>= i & allhrs< i + j;
        p_2 = length(unique(hrs(ind)));
        
        if i-1 + j <= N-2
            gapImpact_IV(j,i) = ((N-j)./((N-1)-(j+1)))  ./   (N./(N-1)); % figure out if j or j plus 1
            gapImpact_IS(j,i) = ((N-j)./(p - p_2))  ./   (N./p); % figure out if j or j plus 1
        else
            gapImpact_IV(j,i) = nan;
            gapImpact_IS(j,i) = nan;
        end
    end
%     figure
%     plot(duration,gapImpact_IS(:,i))
%     title(sprintf('%f',i))
end

%%
figure        
plot(duration,gapImpact_IV(:,1),'linewidth',2) 
hold on
plot(duration,gapImpact_IS(:,1),'linewidth',2)       
xlabel('Duration')
ylabel('Impact Ratio')
legend('IV','IS')  
ylim([1 max(gapImpact_IV(:,1))])
xlim([0 165])
grid on



