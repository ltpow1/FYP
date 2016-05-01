function [p] = rand_irred_poly(m,t)
% generates a random irreducible polynomial of degree t
% over the field F 2^m
% generate a poly of the form f(x) = x^t + a*x + b
p = monic_poly(m,t);
count = 0;
while (is_irred(p,m,t) == 0)
    p = monic_poly(m,t);
    count = count + 1;
end

end