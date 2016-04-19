clear; close all; clc;
m = 4;
n = 2^m;
t = 2;
poly_index = n^t;
k = n-t*m;
%want to make goppa code; generate polynomial of degree t over gf(n) with
%coefficients over gf(2), ie, {0,1}.
% then make sequence of elements of gf(n)
L = randperm(n)-1;
L_gf = gf(L,m);


test_poly = de2bi([1,zeros(1,poly_index-2),1,0]');
test_poly_gf = gf(test_poly,m);

irreducible = 0;
i = 0;
max_iter = 10;
%now generate the polynomial in binary represe3ntation
while (irreducible == 0)&&(i<max_iter)
    g = fliplr(de2bi(randi([2^t+1,2^(t+1)-1])));
    g_gf = gf(g,m);
    % now check for irreducibility
    % find greatest common denomiator between g(x) and x^(q^(t))-x, q = 2^m
    [q,r] = deconv(test_poly_gf,g_gf);
    if r == 0
        irreducible = 1;
    end
    i = i+1;
end
V = gf(zeros(t+1,n),m);
for j = 0:t
    V(j+1,:) = L_gf.^j;
end
D = diag(polyval(g_gf,L_gf));

H = V*D;