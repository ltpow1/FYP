%Goppa testbench
m = 4; % defines length of goppa code
n = 2^m; %length of goppa code, must be power of 2, ie, 2^m
% field will be over gf(2^m)
t = 2;
k = (n+1)-t*m; % approx formula taken from fundamentals of cryptography

% select *irreducible* polynomail, g(x), over GF(2^m).
% can check irreducibility with gftable and showing no linear factors
%can use primpoly, since primitive polynomials are irreducible too

PR = primpoly(t);

% to find a polynomial, can produce polynomials at random and check for
% irreducibility
