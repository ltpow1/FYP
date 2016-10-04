function M = all_poss(n_t,w,N)
% ALL_POSS All possible binary words of specified weight
% recursively generates all binary words of length N and weight w.
% Note: n_t = N for initial call
if n_t > 1 
    L = all_poss(n_t - 1,w,N);
    row = size(L,1);
    M = [zeros(row,1) L; ones(row,1) L];
else
    M = [0;1];
end
check = (sum(M,2)>w)+(sum(~M,2)>(N-w));
M(logical(check),:) = [];
end