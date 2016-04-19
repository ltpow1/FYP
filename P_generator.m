function [P] = P_generator(k,n)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Algorithm III For generating large permutation matrix
%
% Inputs: k = seed-key (also used to generate S)
%         n = dimension of matrix
%
% Outputs: P = An nXn permutation matrix
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 1
rng(k) %define seed of random number generator
r = randperm(n-2);
r = [r,0];

% STEP 2
P = zeros(n);
P(1,1) = 1;
locked_rows_p = zeros(1,n);
locked_cols_p = zeros(1,n);
locked_rows_p(1) = 1;
row = 1;
col = 1;

% STEP 3
for i = 1:(n-1)
    row = find(locked_rows_p==0,1);
    locked_cols_p(col) = 1;
    col = max(find(locked_cols_p==0,r(i)+1));
    P(row,col) = ~P(row,col);
    locked_rows_p(row) = 1;
end
end