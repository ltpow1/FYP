% trialling pattersons algorithm
% once working, implement as function to call in cryptosystem
function [decoded_mess, decoded_error] = patterson(encoded_mess_w_err,g,G,H,L,m, synd)


% clear; clc;
% t = 2;
% m = 3;
% [H, G, n, k,g,L] = goppagen(t,m);

% encode a message/ generate error of degree <= t
% z = zeros(1,n);
% z(randperm(numel(z), t)) = 1; % generate random error of weight t
% z_gf = gf(z);

% mess = randi([0 1],1,k); % generate random message of length k
% mess_gf = gf(mess);
%
% encoded_mess = mess_gf*G;
% encoded_mess_w_err = encoded_mess + z_gf;

% first, calculate the syndrome
t = length(g)-1;
n = 2^m;
k = n-m*t;

if nargin == 6
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


% add x to T
Tx = fliplr(T);
if length(Tx)>=2
    Tx(2) = Tx(2)+1;
else
    Tx(2) = 1;
end
Tx = fliplr(Tx);

% R = sqrt(T+x) mod g
R = poly_root(Tx,g,m);

[gcd,~,v] = patt_EEA(g, R, m, t);

first_term = conv(gcd,gcd);
second_term = conv(gf([1 0],m),conv(v,v));
% need these terms to be the same length for addition
first_term = [zeros(1,length(second_term)-length(first_term)),first_term];
second_term = [zeros(1,length(first_term)-length(second_term)),second_term];
sigma = first_term+second_term;

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

decoded_mess = gf(zeros(1,k));
if nargin == 6
    
    mess_wout_error = encoded_mess_w_err+decoded_error;
    for i = 1:k
        check_vector = zeros(k,1);
        check_vector(i) = 1;
        for j = 1:n
            if(all(check_vector==G(:,j)))
                decoded_mess(i) = mess_wout_error(j);
            end
        end
    end
end
end
