function [g0, g1] = polysplit(g,m)
%POLYSPLIT Splits polynomials into even and odd parts
%    [g0, g1] = POLYSPLIT(g,m) splits the polynomial g defined over F(2^m)
%    into even and odd parts g0 and g1 such that g = g0^2 + x*g1^2.
%    
%    Primary Reference: ""
%

t = length(g)-1;


sqrtg = g.^(2^(m-1)); % reference: Huber, note on decoding goppa codes

% Find the square root of each coefficient in g by finding the root of
% x^2 + g(i)
% sqrtg = gf(zeros(1,t+1),m);
% 
% for i = 1:(t+1)
%     theroots = roots([1 0 g(i)]);
%     sqrtg(i) = theroots(1);
% end
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
        g1(count) = sqrtg(i);
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
        g1(count) = sqrtg(i);
        count = count + 1;
    end
end
% consider removing leading zeros in g0 and g1
end
