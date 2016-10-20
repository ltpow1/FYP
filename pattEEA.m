function [gcd,u,v] = pattEEA(P1,P2,m,t)
% PATTEEA Altered extended euclidea algorithm
% This is an altered version used in finding the even and odd parts of
% the error locating polynomial in the patterson algorithm



s0 = gf(1,m);
s1 = gf(0,m);


t0 = gf(0,m);
t1 = gf(1,m);


a = P1;
b = P2;

while any(b)&&(((length(a)-1)>floor(t/2))||((length(s0)-1)>floor((t-1)/2)))
    
    
    % conv requires removal of leading zeros
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