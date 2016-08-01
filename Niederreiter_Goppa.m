%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Niederreiter Cryptosystem Implementation with Goppa codes
% depends on S_generator and P_generator
% does not have a generator for S_inv yet, uses inv on gf(2)
% 
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;close all; clc; rng('shuffle');

t = 2;
m = 3;
[H, G, n, k,g,L] = goppagen(t,m);
check = ones(n,1);

G_gf = gf(G);
H_gf = gf(H);
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
while(all(check))
%% encryption
message = zeros(1,n);
message(randperm(numel(message), randi([0 t]))) = 1; % generate random message of weight at most t
message_gf = gf(message);


c_gf = H_pub*message_gf';

%% decryption

c_hat = S_inv_gf*c_gf;
[m_hat, z_hat] = patterson(message_gf,g,G,H,L,m, c_hat');

decoded_m = P_gf'*z_hat';

%% results
check = decoded_m == message';
end
check
message

% NOTES:
% when message = 10000000, patterson produces wrong result
% is not a problem of weight, other weight 1 messages work.