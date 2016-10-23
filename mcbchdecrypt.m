function [ decodedmessage] = mcbchdecrypt(c,P,Sinv,n,k)
%MCBCHDECRYPT decrypts the ciphertext chat, producing plaintext message m and
%   error vecto z based on BCH McEliece system
%   

    chat = gf(mod(c*P',2));
    mS = bchdec(chat,n,k);
    decodedmessage = mS*Sinv;
end

