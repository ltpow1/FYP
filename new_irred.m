%new irred tester
clear; clc;
m = 3;
t = 2;
alpha = 1;
beta = 1;
p = zeros(1,t+1);
p(1) = 1;
p(t) = alpha;
p(t+1) = beta;
p = gf(p,m);
n = 2^m;
tester = zeros(1,t);
result = gf(zeros(n,n),m);
for i = 2:n
    tester(1) = i-1;
    for j = 1:n
        tester(2) = j-1;
        if any(tester)
            result(i,j) = poly_gcd(p,gf(tester,m));
        end
    end
end