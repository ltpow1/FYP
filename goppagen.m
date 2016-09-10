function [H,G,n,k,g,L] = goppagen(t,m)
%GOPPAGEN    Generate a goppa code
%    GOPPAGEN(t,m) generates a t error-correcting binary goppa code. The
%    parameter m defines the field over which the code is defined to be
%    F(2^m). The inputs and outputs of GOPPAGEN are listed below.
%    H = Parity check matrix
%    G = generator matrix
%    n = length of code-word
%    k = number of message bits
%    t = error correcting capability
%    m = order of galois field (2^m)
%    
%    Primary Reference: "A summary of McEliece type cryptosystems and their
%    security" Engelbert
%    

n = 2^m;
k = n-m*t;
g = benor(m,t); % g is the irreducible goppa polynomial

% L, the support of the code, can be a random vector containing all
% elements of the field, since irreducible polynomials have no zeros
L = gf(randperm(n)-1,m);

% test to make sure g has no zeros in L
if (any(polyval(g,L)==0))
    g % if g has zeros, then print it for debugging
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
nullspace = null2(H);
G = nullspace';


% for using the systematizer instead of null2.
% [H,P] = systematizer(H);
% G = [eye(k),H(:,1:k)'];
% L = L*P;

end
