function [ decodedmessage,z] = mcdecrypt(c,P,Sinv,g,H,L,m,k)
%MCDECRYPT decrypts the ciphertext chat, producing plaintext message m and
%   error vecto z
%   

    chat = gf(mod(c*P',2));
    [zhat] = patterson(chat,g,H,L,m);
    
    decodedciphertext = zhat+chat;
    z = zhat*P;
    mS = decodedciphertext(1:k);
    decodedmessage = mS*Sinv;
end

