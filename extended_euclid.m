function [gcd,u,v] = extended_euclid(P1,P2,m)
%EXTENDED_EUCLID    Extended Euclidean Algorithm for polynomials
%    EXTENDED_EUCLID(P1,P2,m) performs the extended euclidean algorithm to
%    the polynomials P1 and P2 over the finite field F(2^m). This outputs
%    the GCD of the two polynomials, gcd, and polynomials u and v such that
%    bezout's identity, P1u + P2v = gcd is satisfied.
%    
%    Primary Reference: Wikipedia page on polynomial GCD
%    Reference to be updated.
%   


s0 = gf(1,m);
s1 = gf(0,m);


t0 = gf(0,m);
t1 = gf(1,m);


a = P1;
b = P2;
iter = 0;

while any(b)
    
    iter = iter+1;
    
    % conv requires removal of leaing zeros
    while (a(1)==0)&&(length(a)>1)
        a = a(2:length(a));
    end
    while (b(1)==0)&&(length(a)>1)
        b = b(2:length(b));
    end
    
    
    
    [q,newb] = deconv(a,b);
    temps = conv(q,s1);
    tempt = conv(q,t1);
    
    % in order to subtract, length of s0 must match that of temps
    if length(temps)>length(s0)
        news = [zeros(1,length(temps)-length(s0)),s0]-temps;
    else
        news = s0-temps;
    end
    
    if length(tempt)>length(t0)
        newt = [zeros(1,length(tempt)-length(t0)),t0]-tempt;
    else
        newt = t0-tempt;
    end
    
    
    a = b;
    b = newb;
    
    s0 = s1;
    s1 = news;
    
    t0 = t1;
    t1 = newt;
    
    % check for scalar factors and remove
    if(all(a==a(1)))&&(a(1)~=0)
        s0 = s0/a(1);
        t0 = t0/a(1);
        a = a/a(1);
    end
    
    
    
    
end
gcd = a;
u = s0;
v = t0;


end