function [ Ghat,S,Sinv,P ] = mcbchgen( n,k )
%MCBCHGEN Generates public and private keys for BCH McEliece
%   

messages = gf(eye(k));

polyG = gf(zeros(k,n));
po = bchgenpoly(n,k);
for i = 1:k
    msg = messages(i,:);
%     polyG(i,:) = conv(msg,po);
    polyG(i,:) = bchenc(msg,n,k);
end
[G,~,~] = systematizer2(double(polyG.x),1);
%% 
seedbits = 16; % must be less than 32
seedbinary = randi([0 1],1,seedbits);
seed = bi2de(seedbinary);
[S,Sinv] = Sgenerator(seed,k);
P = Pgenerator(seed,n);
Ghat = mod(S*G*P,2);

end

