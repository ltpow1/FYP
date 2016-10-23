function [decodedmessage ] = hymesdecrypt( cgf,g,L,H,m,k )
%HYMESDECRYPT Decrypts ciphertext using HyMes system
%   

[zhat] = patterson(cgf,g,H,L,m);
decodedciphertext = zhat+cgf;
decodedmessage = decodedciphertext(1:k);
end

