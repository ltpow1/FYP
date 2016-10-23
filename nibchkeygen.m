function [ Hhat, S, Sinv, P ] = nibchkeygen( m,t )
%NIBCHKEYGEN Generates public and private keys for BCH based Niederreiter
%   
n = 2^m-1;
% making parity check matrix
alpha = gf(2,m).*ones(1,n);
alpha = alpha.^(0:(n-1));
H = gf(zeros(2*t,n),m);
for i = 1:(2*t)
    H(i,:) = alpha.^i;
end
% now convert H into binary form
binH = dec2bin(double(H.x))';

for i = 1:n
    tempVec = [];
    for j = 1:(2*t)
        tempVec = [tempVec;binH(:,j+2*t*(i-1))];
    end
    newH(:,i) = tempVec;
end
H = double(newH)-48;
%%
seedbits = 16; % must be less than 32
seedbinary = randi([0 1],1,seedbits);
seed = bi2de(seedbinary);

[S,Sinv] = Sgenerator(seed,2*m*t);
P = Pgenerator(seed,n);
Hhat = mod(S*H*P,2);% public key is [Hhat, t]

end

