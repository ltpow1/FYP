function [R] = poly_root(T,g,m)
%POLY_ROOT Square root of a polynomial
%    R = POLY_ROOT(T,g,m) returns the square root of T mod g over the finite
%    field F(2^m).
%    
%    Primary Reference: "Note on decoding binary Goppa codes"
%    T. Huber
%    

[g0,g1] = poly_split(g,m);
[T0, T1] = poly_split(T,m);
[~,u,~] = extended_euclid(g1,g,m);
[~,u] = deconv(u,g);
[~,r] = deconv(conv(g0,u),g);
temp = conv(r,T1);

% need temp to be the same length as T0

    if length(temp)>length(T0)
        R = [zeros(1,length(temp)-length(T0)),T0]+temp;
    else
        R = T0+temp;
    end
    

end