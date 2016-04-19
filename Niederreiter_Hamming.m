%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Niederreiter testbench (Alice)
% depends on S_generator and P_generator
% does not have a generator for S_inv yet, uses inv on gf(2)
% 
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;close all; clc; rng('shuffle');

[H, G, n, k] = hammgen(5);
G_gf = gf(G);
H_gf = gf(H);
% n = 7; % total number of bits in linear code; dimension of S
% k = 4; % number of data bits; dimension of P
 t = 1; % maximum error correcting ability of code
l = 10; % length of seed (in bits) max atm is 31, limitation of rng
seed_binary = randi([0 1],1,l);
seed = bi2de(seed_binary);
%check that seed<2^(2n-4)

S = S_generator(seed,n-k);
S_gf = gf(S);

S_inv_gf = inv(gf(S));

P = P_generator(seed,n);
P_gf = gf(P);

H_pub = S_gf*H_gf*P_gf;

% public key is H_pub, t

%% encryption
m = zeros(1,n);
m(randperm(numel(m), t)) = 1;
m_gf = gf(m);

c_gf = H_pub*m_gf';

%% decryption

c_hat = S_inv_gf*c_gf;

trt = syndtable(H);
% syndrome = c_hat'*H_gf;

Pm = trt(1+bi2de(double(c_hat.x)','left-msb'),:);

decoded_m = (P_gf'*gf(Pm'))';
%% results
m==decoded_m
