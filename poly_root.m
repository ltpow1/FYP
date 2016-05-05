function [R] = poly_root(T,g,m)
% gets the square root of T mod g over the finite field f 2^m

[g0,g1] = poly_split(g,m);
[T0, T1] = poly_split(T,m);
[~,u,~] = extended_euclid(g1,g,m);
[~,r] = deconv(conv(g0,u),g);
temp = conv(r,T1);

% need temp to be the same length as T0

    if length(temp)>length(T0)
        R = [zeros(1,length(temp)-length(T0)),T0]+temp;
    else
        R = T0+temp;
    end
    


end