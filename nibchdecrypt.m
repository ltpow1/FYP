function [ decodedm ] = nibchdecrypt( c,Sinv,P,m,t)
%NIBCHDECRYPT Decrypts ciphertext produced by BCH code based niederreiter
%   system
%   
n = 2^m-1;
chat = gf(mod(Sinv*c,2));
% chat is the syndrome of the permuted message, Pm
[Pm] = mybchdec(chat,n,m,t);
decodedm = P'*Pm;
end

