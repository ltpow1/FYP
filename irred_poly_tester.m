% test for irreducible polynomial generation

m = 3;
t = 2;
p = rand_irred_poly(m,t);
p = gf(p,m);

n = 2^m;
alpha = gf(2,m);
beta = gf(1,m);

g = gf([1,zeros(1,t-2),alpha,beta],m);

L = gf(zeros(1,n),m);
L(2) = gf(1,m);
for i = 3:n
    L(i) = alpha^(i-2);
end


% here construct every polynomial of the form 