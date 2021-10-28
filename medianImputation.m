function medianimputed = medianImputation(act,t,gaps)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

    medianimputed = act;
    tHrs = hour(t)+minute(t)/60 + second(t)/3600;
    for q = 1:size(gaps,1)
        
        gapTime = t(gaps(q,1)+1:gaps(q,2));
        
        gapHrs = hour(gapTime)+minute(gapTime)/60 + second(gapTime)/3600;
        
        impval = nan(length(gapHrs),1);
        for qq = 1:length(gapHrs)
            all_vals = act(tHrs==gapHrs(qq));
            vals = all_vals(all_vals~=0);
            impval(qq) = median(vals);
        end
        
        medianimputed(gaps(q,1)+1:gaps(q,2)) = impval;
    end
end

