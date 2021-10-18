function imputed = graphImputation(act,gaps,Adj,nl)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

    imputed = act;
    for q = 1:size(gaps,1)
        if gaps(q,1) == 1
            seedNode = find(nl == act(gaps(q,2)+1));
        else
            seedNode = find(nl == act(gaps(q,1)));
        end
        impLength = gaps(q,2) - gaps(q,1);
        
        impsNode = [seedNode];
        % Options form seed node
        for qq = 1:impLength
            conn = full(Adj(impsNode(end),:));
            conn_ind = find(conn>0);
            cons = [conn_ind',conn(conn_ind)'];
            opVals = [];
            for pp = 1:size(cons,1)
                opVals = [opVals;repmat(cons(pp,1),1)];
            end
            
            if isempty(opVals)
                n = 1;
                while isempty(opVals)
                    conn = full(Adj(impsNode(end)-n,:));
                    conn_ind = find(conn>0);
                    cons = [conn_ind',conn(conn_ind)'];
                    opVals = [];
                    for pp = 1:size(cons,1)
                        opVals = [opVals;repmat(cons(pp,1),1)];
                    end
                    n=n+1;
                end
            end 
            nextNode = randsample(opVals,1);
            impsNode = [impsNode;nextNode];
        end
        
        imps = nan(length(impsNode),1);
        for tt = 1:length(nl)
            imps(impsNode==tt)= nl(tt);
        end
        
        if gaps(q,1) == 1
            imps = flipud(imps);
        end
        imputed(gaps(q,1):gaps(q,2)) = imps;
    end

end

