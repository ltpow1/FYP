clear;close all; clc; rng('shuffle');
%NIEDERREITER_HAMMING    Niederreiter cryptosystem based on Hamming codes
%    Implementation of the Niederreiter cryptosystem based on Hamming
%    codes, implemented using the hammgen and decode functions.
%    

[H, G, n, k] = hammgen(5);
G_gf = gf(G);
H_gf = gf(H);
t = 1; % maximum error correcting ability of code

seed_bits = 10; % length of seed (in bits) max is 31
seed_binary = randi([0 1],1,seed_bits);
seed = bi2de(seed_binary);
%check that seed<2^(2n-4)

S = S_generator(seed,n-k);
S_gf = gf(S);

S_inv_gf = inv(gf(S));

P = P_generator(seed,n);
P_gf = gf(P);

H_pub = S_gf*H_gf*P_gf;

% public key is [H_pub, t]

%% encryption
m = zeros(1,n);
m(randperm(numel(m), t)) = 1;
m_gf = gf(m);

c_gf = H_pub*m_gf';

%% decryption

c_hat = S_inv_gf*c_gf;

trt = syndtable(H);

Pm = trt(1+bi2de(double(c_hat.x)','left-msb'),:);

decoded_m = (P_gf'*gf(Pm'))';
%% results
all(m==decoded_m)
