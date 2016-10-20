function M = allposs(nt,w,N)
% ALLPOSS All possible binary words of specified weight
% recursively generates all binary words of length N and weight w.
% Note: nt = N for initial call
if nt > 1 
    L = allposs(nt - 1,w,N);
    row = size(L,1);
    M = [zeros(row,1) L; ones(row,1) L];
else
    M = [0;1];
end
check = (sum(M,2)>w)+(sum(~M,2)>(N-w));
M(logical(check),:) = [];
end