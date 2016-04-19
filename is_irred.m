function [result] = is_irred(P,m,t)
% test polynomial P over the field F 2^m for irreducibility.
% output result = 1 if true, 0 otherwise
% t is the degree of the polynomial P
P_gf = gf(P,m);
h = zeros(1,t+1);
h(t) = 1;
h = gf(h,m);
result = 1;

for i = 1:(t/2)
    for j = 1:m
        [q,h] = deconv(conv(h,h),P_gf);
    end
    temp = h;
    temp(length(h)-1) = temp(length(h)-1)-1;
    if (poly_gcd(P_gf,temp) ~= 1)
        result = 0;
    end
end



end