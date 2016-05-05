% extended euclid inverse tester
clear; clc;
m = 3;
t = 2;
g = gf([1 2 1],m);

S = gf([2 7],m); %want inverse of S mod g

[gcd,u,v] = extended_euclid(S,g,m);

% u should be inverse of S

onemod = conv(u,S);
[quo,rem] = deconv(onemod,g);

first_term = conv(v,g);
second_term = conv(u,S);

first_term = [zeros(1,length(second_term)-length(first_term)),first_term];
second_term = [zeros(1,length(first_term)-length(second_term)),second_term];
sigma = first_term+second_term;

gcd
rem
sigma

R = poly_root(S,g,m);
[q,r] = deconv(conv(R,R),g)
