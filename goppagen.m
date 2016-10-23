function [H,n,k,g,L] = goppagen(t,m,g)
%GOPPAGEN    Generate a goppa code
%    GOPPAGEN(t,m) generates a t error-correcting binary goppa code. The
%    parameter m defines the field over which the code is defined to be
%    F(2^m). If g is not given as an input, rabin() will be used to
%    generate a new goppa polynomial. For this case, t should be prime.
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
    g = rabin(m,t); % g is the irreducible goppa polynomial
end
% L, the support of the code, can be a random vector containing all
% elements of the field, since irreducible polynomials have no zeros
L = gf(randperm(n)-1,m);
H = goppargen(g,L);
end
