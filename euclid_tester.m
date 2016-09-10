% extended_euclid tester
clear; close all; clc;

m = 4;
n = 5;

P1 = benor(m,n);
P2 = gf([1,4,6,2,1],m);

[g,u,v] = extended_euclid(P1,P2,m);

g2 = poly_gcd(P1, P2);