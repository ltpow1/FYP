function [Hpub,S,Sinv,P,H,g,L] = nikeygen(m,t)
%NIKEYGEN Generates public and private keys for niederreiter cryptosystem
%   

name = strcat('m=',num2str(m),'t=',num2str(t),'.mat');
    if exist(name,'file') == 2 
        % irred poly prepared earlier
        load(name)
    [H, n, k,g,L] = goppagen(t,m,g);
    else
        [H, n, k,g,L] = goppagen(t,m);
    end
l = 10; % length of seed (in bits) max atm is 31, limitation of rng
seedbinary = randi([0 1],1,l);
seed = bi2de(seedbinary);
%check that seed<2^(2n-4)

[S, Sinv] = Sgenerator(seed,n-k);
P = Pgenerator(seed,n);
Hpub = mod(S*H*P,2); % public key is Hpub, t
end

