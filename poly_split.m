function [g0, g1] = poly_split(g,m)
% splits polynomial g into even and odd root parts, g0 and g1

% NOTE: MATLAB doesnt calculate square roots in finite fields properly.
% need to use roots instead, as shown below

t = length(g)-1;
sqrtg = gf(zeros(1,t+1),m);
for i = 1:(t+1)
    the_roots = roots([1 0 g(i)]);
    sqrtg(i) = the_roots(1);
end
count = 1;

if mod(t,2)==1
    g0 = gf(zeros(1,(1+t)/2),m);
    g1 = gf(zeros(1,(1+t)/2),m);    
    for i = 2:2:(t+1)
        g0(count) = sqrtg(i);
        count = count + 1;
    end
    count =  1;
    for i = 1:2:(t+1)
        g1(i) = sqrtg(i);
        count = count + 1;
    end
    
else
    g0 = gf(zeros(1,1+t/2),m);
    g1 = gf(zeros(1,t/2),m);
    for i = 1:2:(t+1)
        g0(count) = sqrtg(i);
        count = count + 1;
    end
    count =  1;
    for i = 2:2:(t+1)
        g1(i) = sqrtg(i);
        count = count + 1;
    end
end
% consider removing leading zeros in g0 and g1
end
