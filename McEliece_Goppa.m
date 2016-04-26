%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% McEliece testbench (Alice)
% depends on S_generator and P_generator
% does not have a generator for S_inv yet, uses inv on gf(2)
% suggested values of n, k and t are n = 1024, k = 524 and t = 50
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;close all; clc; rng('shuffle');
t = 2;
m = 4;
[H, G, n, k] = goppagen(t,m);
G_gf = gf(G);
H_gf = gf(H);
l = 10; % length of seed (in bits) max atm is 31, limitation of rng
seed_binary = randi([0 1],1,l);
seed = bi2de(seed_binary);
%check that seed<2^(2n-4)

S = S_generator(seed,k);
S_gf = gf(S);

S_inv_gf = inv(gf(S));

P = P_generator(seed,n);
P_gf = gf(P);

G_hat = S_gf*G_gf*P_gf;

% public key is G_hat, t

%% encryption
m = randi([0 1],1,k); % generate random message of length k
m_gf = gf(m);

z = zeros(1,n);
z(randperm(numel(z), t)) = 1; % generate random error of weight t
z_gf = gf(z);

c_gf = m_gf*G_hat+z_gf;

%% decryption

c_hat = c_gf*P';


%% results
