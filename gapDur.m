function gaps = gapDur(notGap_ind)
%gapDur finds the start and stop indices of gaps in 1D data
%   Detailed explanation goes here
    gaps = [find(diff(~notGap_ind)>0),ones(length(find(diff(~notGap_ind)>0)),1);...
        find(diff(~notGap_ind)<0),zeros(length(find(diff(~notGap_ind)<0)),1)];
    gaps = sortrows(gaps);
    
    if rem(size(gaps,1),2) == 1
        if gaps(end,2) == 1
            gaps = [gaps;length(notGap_ind),0];
        end
        
        if gaps(1,2) == 0
            gaps = [1,1;gaps];
        end
    end
    starts = gaps(gaps(:,2)==1,1);
    stops = gaps(gaps(:,2)==0,1);
    gaps = [starts,stops];

end

