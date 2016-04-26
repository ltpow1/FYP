function [H,G,n,k] = goppagen(t,m)
% GOPPA_GENERATOR   generate a goppa code
%   H = Parity check matrix
%   G = generator matrix
%   n = length of coded word
%   k = number of message bits
%   t = error correcting capability
%   m = order of galois field (2^m)
%   G and H will be returned as normal matrices, not GF arrays

n = 2^m;
alpha = gf(2,m);
beta = gf(1,m);

g = gf([1,zeros(1,t-2),alpha,beta],m);

L = gf(zeros(1,n),m);
L(2) = gf(1,m);
for i = 3:n
    L(i) = alpha^(i-2);
end

% using formula on wikipedia

V = gf(zeros(t+1,n),m);
D = gf(zeros(n),m);

for i = 1:n
    D(i,i) = 1./(polyval(g,L(i)));
end

for j = 1:(t+1)
    V(j,:) = L.^(j-1);
end


tempH = V*D; % t by n matrix

% now convert to binary form, mt by n

binH = dec2bin(double(tempH.x))';

for i = 1:n
    tempVec = [];
    for j = 1:(t+1)
        tempVec = [tempVec;binH(:,j+(t+1)*(i-1))];
    end
    newH(:,i) = tempVec;
end

H = double(newH)-48;
nullspace = null2(H);
G = nullspace';
k = size(G,1);
% parity check matrix will not be full rank, and hence will
% be a bit larger thanthe standard (n-k)xn
end
