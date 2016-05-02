function [R] = poly_root(T,g,m)
% gets the square root of T mod g over the finite field f 2^m

[g0,g1] = poly_split(g,m);
[T0, T1] = poly_split(T,m);
[~,u,~] = extended_euclid(g1,g,m);
R = T0 + conv(conv(g0,u),T1);

end