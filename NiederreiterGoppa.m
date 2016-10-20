%MIEDERREITERGOPPA Niederreiter cryptosystem with Goppa codes
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

Ggf = gf(Gsys);
Hgf = gf(H);
l = 10; % length of seed (in bits) max atm is 31, limitation of rng
seedbinary = randi([0 1],1,l);
seed = bi2de(seedbinary);
%check that seed<2^(2n-4)

[S, Sinv] = Sgenerator(seed,n-k);


P = Pgenerator(seed,n);


Hpub = mod(S*H*P,2);

% public key is Hpub, t

%% encryption
message = zeros(1,n);
message(randperm(numel(message), randi([0 t]))) = 1; % generate random message of weight at most t
messagegf = gf(message);


cgf = Hpub*messagegf';

%% decryption

chat = Sinv*cgf;
zhat = patterson(messagegf,g,H,L,m, chat');

decodedm = P'*zhat';

%% results
check = all(decodedm == message')

