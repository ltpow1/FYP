function [ decodedm ] = nidecrypt( cgf,Sinv,P,g,L,H,m)
%NIDECRYPT Decrypts the niederreiter ciphertext cgf
%   

chat = Sinv*cgf;
zhat = patterson(0,g,H,L,m, chat');
decodedm = P'*zhat';

end

