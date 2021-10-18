function [Adj,nl] = genAccNet(act,t)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    
    % Determine node values
    nl = unique(act);
    
    % initialize sparse matrix
    Adj = sparse(length(nl),length(nl));
    
    % Determine pairs
    A = act(1:2:end);
    B = act(2:2:end);
    C = A(2:end);
    A = A(1:end-1);
    
    % Pre allocate 
    A1 = nan(length(A),1);
    B1 = nan(length(B),1);
    C1 = nan(length(C),1);
    
    % Convert pairs to labels
    for j = 1:length(nl)
        A1(A==nl(j)) = j;
        B1(B==nl(j)) = j;
        C1(C==nl(j)) = j;
        
%         ind_A = find(A==nl(j));
%         ind_B = find(B==nl(j));
%         ind_C = find(C==nl(j));
%         
%         A1(ind_A) = j;
%         B1(ind_B) = j;
%         C1(ind_C) = j;
    end
    
    for k = 1:length(A)
        if t(2*k)-t(2*k-1)==seconds(30)
            %forward
            Adj(A1(k),B1(k)) = Adj(A1(k),B1(k)) + 1;
            %backward
            Adj(B1(k),A1(k)) = Adj(B1(k),A1(k)) + 1;
        end
        if t(2*k+1)-t(2*k)==seconds(30)
            %forward
            Adj(B1(k),C1(k)) = Adj(B1(k),C1(k)) + 1;
            %backward
            Adj(C1(k),B1(k)) = Adj(C1(k),B1(k)) + 1;
        end
    end
end

