function [gcd] = poly_gcd(P1,P2)
% finds gcd of polynomials p1 and p2 over field F 2^m
% requires P1 and P2 to be gf arrays

a = P1;
b = P2;

while any(b)
    while(a(1)==0)
        a = a(2:length(a));
    end
    while (b(1)==0)
        b = b(2:length(b));
    end
    [quo, remain] = deconv(a,b);
    a = b;
    b = remain;
end
gcd = a;

end