function [decoded_error] = patterson(encoded_mess_w_err,g,H,L,m, synd)
%PATTERSON Decodes Goppa codes using the Patterson algorithm
%    [decoded_mess, decoded_error] = patterson(encoded_mess_w_err,g,G,H,L,m, synd)
%    


% first, calculate the syndrome
t = length(g)-1;
n = 2^m;
k = n-m*t;

if nargin == 5
    synd = encoded_mess_w_err*H';
end

synd_array = synd.x;
%convert synd from GF(2) to GF(2^m)
for i = 1:t
    gfsynd(i) = bi2de(synd_array(((i-1)*m+1):(i*m)),'left-msb');
end
gfsynd = gf(gfsynd,m);

% now follow the steps of the patterson algorithm
% first, we need the inverse of the syndrome mod g
[~,T,~] = extended_euclid(gfsynd,g,m);
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
    R = poly_root(Tx,g,m);
    [~,R] = deconv(R,g);
    [gcd,~,v] = patt_EEA(g, R, m, t);
    
    first_term = conv(gcd,gcd);
    second_term = conv(gf([1 0],m),conv(v,v));
    % need these terms to be the same length for addition
    first_term = [zeros(1,length(second_term)-length(first_term)),first_term];
    second_term = [zeros(1,length(first_term)-length(second_term)),second_term];
    sigma = first_term+second_term;
    sigma = sigma./sigma(1);
end

error_roots = roots(sigma);

for i = 1:length(error_roots)
    error_index(i) = find(L==error_roots(i));
end

decoded_error = zeros(1,n);

if (length(error_roots)>=1)
    
    for j = 1:length(error_index)
        decoded_error(error_index(j)) = 1;
    end
    
    %      z==decoded_error
end
end
