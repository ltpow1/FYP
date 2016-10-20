function [S, Sinv] = Sgenerator(k,n)
%SGENERATOR    Scrambler generator
%   SGENERATOR(k,n) randomly generates a non-singular, n-by-n scrambler
%   matrix S, using k as the random number generator seed. Also generates
%   the inverse scrambler, Sinv.
%
%   Primary Reference: 'Key Generation of Algebraic-Code Cryptosystems'
%   Hung-Min Sun and Tzonelih Hwang
%

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
lockedcol = zeros(1,n);
lockedrow = zeros(1,n);

lockedrow(1) = 1;

%STEP 3
for i = 2:(2*n-1)
    if(mod(i,2)==1) %opposite conditions to paper, because matlab uses 1 indexing
        %add 1 to the row
        row = R(i-1);
        temprow = S(row,:);
        temprow(lockedcol==1) = 1; % set locked columns to 1, so they are ignored by
                                  %search for zeros below
        col = max(find(temprow==0,r(i+1)+1));
        S(row,col) = 1;
        lockedrow(row) = 1;
        R(i) = row;
        C(i) = col;
    else 
        % add 1 to the column
        col = C(i-1);
        tempcol = S(:,col);
        tempcol(lockedrow==1) = 1; % set locked rows to 1, so they are ignored by
                                  %search for zeros below
        row = max(find(tempcol==0,r(i+1)+1));
        S(row,col) = 1;
        lockedcol(col) = 1;
        R(i) = row;
        C(i) = col;
    end
    
end
%STEP 4
lockedrow(1) = 0;
S(1,C(2*n-1)) = 1; %Here, S is a DBO-1 matrix
R(2*n) = 1;
C(2*n) = C(2*n-1);

%STEP 5
p = mod(floor(k/n),n)+1;
q = mod(k,n)+1;
S(p,q) = mod(S(p,q)+1,2); % could also use S(p,q) = ~S(p,q)


% %% ALGORITHM II
% % Generate the inverse of S
% % requires R and C
% % STEP 1
 j = find(C==q,1)-1;

% STEP 2
W = zeros(1,n);
L = zeros(1,n);

if(R(j+1)==p)
    for i = 1:n
        W(i) = R(mod(j+2*i,2*n)+1);
        L(i) = C(mod(j+2*i,2*n)+1);
    end
else
    for i = 1:n
        W(i) = R(mod(j+1-2*i,2*n)+1);
        L(i) = C(mod(j+1-2*i,2*n)+1);
    end
end

% STEP 3

m = find(W==p,1);
Sinv = zeros(n);
Sinv(L(1:m-1),:) = 1;

newlockedrows = zeros(1,n);

% STEP 4
for i = 1:n
    tempcol = Sinv(:,W(i));
    tempcol(newlockedrows==0) = ~tempcol(newlockedrows==0); %invert locked rows twice, thus leaving them where they started
    Sinv(:,W(i)) = tempcol;
    newlockedrows(L(i)) = 1;
end

end












