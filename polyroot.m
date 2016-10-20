function [R] = polyroot(T,g,m)
%POLYROOT Square root of a polynomial
%    R = POLYROOT(T,g,m) returns the square root of T mod g over the finite
%    field F(2^m).
%    
%    Primary Reference: "Note on decoding binary Goppa codes"
%    T. Huber
%    

[g0,g1] = polysplit(g,m);
[T0, T1] = polysplit(T,m);
[~,u,~] = extendedeuclid(g1,g,m);
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