%MIEDERREITER_GOPPA Niederreiter cryptosystem with Goppa codes
%    Implementation of the Niederreiter public key cryptosystem based on
%    binary Goppa codes.
%    
%
%
clear;close all; clc; rng('shuffle');

t = 2;
m = 4;
[H, G, n, k,g,L] = goppagen(t,m);

G_gf = gf(G);
H_gf = gf(H);
l = 10; % length of seed (in bits) max atm is 31, limitation of rng
seed_binary = randi([0 1],1,l);
seed = bi2de(seed_binary);
%check that seed<2^(2n-4)

[S, S_inv] = S_generator(seed,n-k);
S_gf = gf(S);

S_inv_gf = gf(S_inv);

P = P_generator(seed,n);
P_gf = gf(P);

H_pub = S_gf*H_gf*P_gf;

% public key is H_pub, t

%% encryption
message = zeros(1,n);
message(randperm(numel(message), randi([0 t]))) = 1; % generate random message of weight at most t
message_gf = gf(message);


c_gf = H_pub*message_gf';

%% decryption

c_hat = S_inv_gf*c_gf;
z_hat = patterson(message_gf,g,H,L,m, c_hat');

decoded_m = P_gf'*z_hat';

%% results
check = all(decoded_m == message');

check
