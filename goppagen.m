function [H,G,n,k,g,L] = goppagen(t,m)
% GOPPA_GENERATOR   generate a goppa code
%   H = Parity check matrix
%   G = generator matrix
%   n = length of coded word
%   k = number of message bits
%   t = error correcting capability
%   m = order of galois field (2^m)
%   G and H will be returned as normal matrices, not GF arrays

n = 2^m;
k = n-m*t;
g = benor(m,t);

% g = gf([1,2,1],m); % this is the known irreducible polynomial, for use
% prior to development of irreducible polynomial generator

% L, the support of the code, can be a random vector containing all
% elements of the field, since irreducible polynomials have no zeros
L = gf(randperm(n)-1,m);

% test to make sure g has no zeros in L
if (any(polyval(g,L)==0))
    g
end


V = gf(zeros(t,n),m);
D = gf(zeros(n),m);
X = gf(zeros(t),m);

for i = 1:n
    D(i,i) = 1./(polyval(g,L(i)));
end

for j = 1:t
    V(j,:) = L.^(j-1);
end

for i = 1:t
    X(i,:) = [fliplr(g(1:i)),zeros(1,t-i)];
end


tempH = X*V*D; % t by n matrix

% now convert to binary form, mt by n

binH = dec2bin(double(tempH.x))';

for i = 1:n
    tempVec = [];
    for j = 1:t
        tempVec = [tempVec;binH(:,j+t*(i-1))];
    end
    newH(:,i) = tempVec;
end

 H = double(newH)-48;
nullspace = null2(H);
G = nullspace';

% [H,P] = systematizer(H);
% G = [eye(k),H(:,1:k)'];

% L = L*P;


% parity check matrix will not be full rank, and hence will
% be a bit larger thanthe standard (n-k)xn
end
