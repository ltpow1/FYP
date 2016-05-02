% trialling pattersons algorithm
% once working, implement as function to call in cryptosystem
clear; close all; clc;

t = 2;
m = 3;
[H, G, n, k,g,L] = goppagen(t,m);

% encode a message/ generate error of degree <= t
z = zeros(1,n);
z(randperm(numel(z), t)) = 1; % generate random error of weight t
z_gf = gf(z);

mess = randi([0 1],1,k); % generate random message of length k
mess_gf = gf(mess);

encoded_mess = mess_gf*G;
encoded_mess_w_err = encoded_mess + z_gf;

% first, calculate the syndrome
synd = encoded_mess_w_err*H';
synd_array = synd.x;
%convert synd from GF(2) to GF(2^m)
for i = 1:m
    gfsynd(i) = bi2de(synd_array(((i-1)*m+1):(i*m)),'left-msb');
end
gfsynd = gf(gfsynd,m);

% now follow the steps of the patterson algorithm
% first, we need the inverse of the syndrome mod g
[d,T,v] = extended_euclid(gfsynd, g,m);
% note: d should be 1 if g is irreducible

Tx = T;
Tx(length(Tx)-1) = Tx(length(Tx)-1)+1;

R = poly_root(Tx,g,m);




