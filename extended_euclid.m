 function [gcd,u,v] = extended_euclid(P1,P2,m)
% [gcd,u,v] = extended_euclid(P1,P2,m)
% can be used to find the multiplicative inverse of P1 mod P2, given by
% u. Also produces the gcd of P1 and P2. Applies over GF(m)
% see bezouts identity and the wiki page for extended euclid algorithm



s0 = gf(1,m);
s1 = gf(0,m);


t0 = gf(0,m);
t1 = gf(1,m);


a = P1;
b = P2;


while any(b)
    % conv requires removal of leaing zeros
    while(a(1)==0)
        a = a(2:length(a));
    end
    while (b(1)==0)
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
end
gcd = a;
u = s0;
v = t0;

 end