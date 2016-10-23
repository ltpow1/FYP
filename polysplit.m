function [g0, g1] = polysplit(g,m)
%POLYSPLIT Splits polynomials into even and odd parts
%    [g0, g1] = POLYSPLIT(g,m) splits the polynomial g over GF(2^m)
%    into even and odd parts g0 and g1 such that g = g0^2 + x*g1^2.
%    
%    Primary Reference: "How SAGE helps to implement Goppa codes and
%    McEliece PKCSs" - Risse
%

t = length(g)-1;
sqrtg = g.^(2^(m-1)); % reference: Huber, note on decoding goppa codes
count = 1;
if mod(t,2)==1 %check if t is even or odd
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
end