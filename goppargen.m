function H = goppargen(g,L)
%GOPPARGEN Generate parity check matrix of Goppa code
%    GOPPARGEN(g,L) generates a parity check matrix H for the Goppa code
%    defined by goppa polynomial g, support L.
%

t = length(g)-1;
n = length(L);
m = log2(n);
V = gf(zeros(t,n),m);
D = gf(zeros(n),m);
X = gf(zeros(t),m);


D = diag(1./polyval(g,L));

%consider using vector methods instead of for loops for speedup
for j = 1:t
    V(j,:) = L.^(j-1);
end

for i = 1:t
    X(i,:) = [fliplr(g(1:i)),zeros(1,t-i)];
end

tempH = X*V*D; % t by n matrix

% now convert to binary form, mt by n
% by expanding elements of H into binary column vectors

binH = dec2bin(double(tempH.x))';

for i = 1:n
    tempVec = [];
    for j = 1:t
        tempVec = [tempVec;binH(:,j+t*(i-1))];
    end
    newH(:,i) = tempVec;
end

H = double(newH)-48;

end