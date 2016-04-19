function [S] = S_generator(k,n)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Algorithms for nonsingular matrix S
%   
%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ALGORITHM I
% STEP 1

rng(k) %define seed of random number generator
r = randperm(2*n-2);
r = [r,0,0];

%

% STEP 2
S = zeros(n,n); % nonsingular matrix, i.e. scrambler
S(1,1) = 1;

row = 1;
col = 1;

R = zeros(1,2*n);
R(1) = 1;
C = R;

% to lock rows and columns, use logic vectors
locked_col = zeros(1,n);
locked_row = zeros(1,n);

locked_row(1) = 1;

%STEP 3
for i = 2:(2*n-1)
    if(mod(i,2)==1) %opposite conditions to paper, because matlab uses 1 indexing
        %add 1 to the row
        row = R(i-1);
        temp_row = S(row,:);
        temp_row(locked_col==1) = 1; % set locked columns to 1, so they are ignored by
                                  %search for zeros below
        col = max(find(temp_row==0,r(i+1)+1));
        S(row,col) = 1;
        locked_row(row) = 1;
        R(i) = row;
        C(i) = col;
    else 
        % add 1 to the column
        col = C(i-1);
        temp_col = S(:,col);
        temp_col(locked_row==1) = 1; % set locked rows to 1, so they are ignored by
                                  %search for zeros below
        row = max(find(temp_col==0,r(i+1)+1));
        S(row,col) = 1;
        locked_col(col) = 1;
        R(i) = row;
        C(i) = col;
    end
    
end
%STEP 4
locked_row(1) = 0;
S(1,C(2*n-1)) = 1; %Here, S is a DBO-1 matrix
R(2*n) = 1;
C(2*n) = C(2*n-1);

%STEP 5
p = mod(floor(k/n),n)+1;
q = mod(k,n)+1;
S(p,q) = mod(S(p,q)+1,2); % could also use S(p,q) = ~S(p,q)

end

% %% ALGORITHM II *needs fixing* *can convert S using gf then use inv instead
% % Generate the inverse of S
% % requires R and C
% % STEP 1
% j = find(C==q,1);
% 
% % STEP 2
% W = zeros(1,n);
% L = zeros(1,n);
% 
% if(R(j)==p)
%     for i = 1:n
%         W(i) = R(mod(j+2*i,2*n)+1);
%         L(i) = C(mod(j+2*i,2*n)+1);
%     end
% else
%     for i = 1:n
%         W(i) = R(mod(j+1-2*i,2*n)+1);
%         L(i) = C(mod(j+1-2*i,2*n)+1);
%     end
% end
% 
% % STEP 3
% 
% m = find(W==p,1);
% S_inv = zeros(n);
% S_inv(L(1:m-1),:) = 1;
% 
% new_locked_rows = zeros(1,n);
% 
% % STEP 4
% for i = 1:n
%     temp_col = S_inv(:,W(i));
%     temp_col(new_locked_rows==1) = ~temp_col(new_locked_rows==1); %invert locked rows twice, thus leaving them where they started
%     S_inv(:,W(i)) = ~S_inv(:,W(i));
%     new_locked_rows(L(i)) = 1;
% end












