function linInterpimputed = linInterpImputation(act,t,gaps)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

    linInterpimputed = act;
    for q = 1:size(gaps,1)
        
        v1 = act(gaps(q,1));
        v2 = act(gaps(q,2)+1);
        
        x = [gaps(q,1):gaps(q,2)+1]-gaps(q,1);
        
        impval = ((v2-v2)./length(x))*x + v1;
        
        linInterpimputed(gaps(q,1):gaps(q,2)+1) = impval;
    end
end

