%MIEDERREITER_GOPPA Niederreiter cryptosystem with Goppa codes
%    Implementation of the Niederreiter public key cryptosystem based on
%    binary Goppa codes.
%    
%
%
clear;close all; clc; rng('shuffle');

t = 4;
m = 5;
name = strcat('m=',num2str(m),'t=',num2str(t),'.mat');
    if exist(name,'file') == 2 
        % irred poly prepared earlier
        load(name)
    [H, n, k,g,L] = goppagen(t,m,g);
    else
        [H, n, k,g,L] = goppagen(t,m);
    end
    [Hsys, Psys] = systematizer(H);
    Gsys = [eye(k),Hsys(:,1:k)'];
    % if Psys is a non-identity matrix permutation, must recalculate H and L
    if(all(all(Psys == eye(size(Psys))))==0)
        L = L*Psys;
        H = goppargen(g,L);
    end

G_gf = gf(Gsys);
H_gf = gf(H);
l = 10; % length of seed (in bits) max atm is 31, limitation of rng
seed_binary = randi([0 1],1,l);
seed = bi2de(seed_binary);
%check that seed<2^(2n-4)

[S, S_inv] = S_generator(seed,n-k);


P = P_generator(seed,n);


H_pub = mod(S*H*P,2);

% public key is H_pub, t

%% encryption
message = zeros(1,n);
message(randperm(numel(message), randi([0 t]))) = 1; % generate random message of weight at most t
message_gf = gf(message);


c_gf = H_pub*message_gf';

%% decryption

c_hat = S_inv*c_gf;
z_hat = patterson(message_gf,g,H,L,m, c_hat');

decoded_m = P'*z_hat';

%% results
check = all(decoded_m == message')

