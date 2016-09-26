function [H,n,k,g,L] = goppagen(t,m,g)
%GOPPAGEN    Generate a goppa code
%    GOPPAGEN(t,m) generates a t error-correcting binary goppa code. The
%    parameter m defines the field over which the code is defined to be
%    F(2^m). The inputs and outputs of GOPPAGEN are listed below.
%    H = Parity check matrix
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
if nargin == 2 % must produce g
    g = benor(m,t); % g is the irreducible goppa polynomial
end
% L, the support of the code, can be a random vector containing all
% elements of the field, since irreducible polynomials have no zeros
L = gf(randperm(n)-1,m);

% test to make sure g has no zeros in L
if (any(polyval(g,L)==0))
    g % if g has zeros, then print it for debugging
end


H = goppargen(g,L);

end
