function [decodederror] = patterson(encodedmesswerr,g,H,L,m, synd)
%PATTERSON Decodes Goppa codes using the Patterson algorithm
%    [decodedmess, decodederror] = patterson(encodedmesswerr,g,G,H,L,m, synd)
%    


% first, calculate the syndrome
t = length(g)-1;
n = 2^m;
k = n-m*t;

if nargin == 5
    synd = encodedmesswerr*H';
end

syndarray = synd.x;
%convert synd from GF(2) to GF(2^m)
for i = 1:t
    gfsynd(i) = bi2de(syndarray(((i-1)*m+1):(i*m)),'left-msb');
end
gfsynd = gf(gfsynd,m);

% now follow the steps of the patterson algorithm
% first, we need the inverse of the syndrome mod g
[~,T,~] = extendedeuclid(gfsynd,g,m);
[~,T] = deconv(T,g);

% check if T = x
Tx = fliplr(T);
if all(Tx == [0 1 zeros(1,length(Tx)-2)])
    
    sigma = gf([1 0],m);
    
else
    
    % add x to T
    
    if length(Tx)>=2
        Tx(2) = Tx(2)+1;%wrong, add the polynomial of same length as T
        %ie, Tx = Tx + x, where x = gf([0 0 1 0],m) for example
    else
        Tx(2) = 1;
    end
    
    Tx = fliplr(Tx);
    
    % R = sqrt(T+x) mod g
    R = polyroot(Tx,g,m);
    [~,R] = deconv(R,g);
    [gcd,~,v] = pattEEA(g, R, m, t);
    
    firstterm = conv(gcd,gcd);
    secondterm = conv(gf([1 0],m),conv(v,v));
    % need these terms to be the same length for addition
    firstterm = [zeros(1,length(secondterm)-length(firstterm)),firstterm];
    secondterm = [zeros(1,length(firstterm)-length(secondterm)),secondterm];
    sigma = firstterm+secondterm;
    sigma = sigma./sigma(1);
end

errorroots = roots(sigma);

for i = 1:length(errorroots)
    errorindex(i) = find(L==errorroots(i));
end

decodederror = zeros(1,n);

if (length(errorroots)>=1)
    
    for j = 1:length(errorindex)
        decodederror(errorindex(j)) = 1;
    end
    
    %      z==decodederror
end
end
