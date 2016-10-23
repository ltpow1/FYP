function [ cgf ] = niencrypt(Hpub, message)
%NIENCRYPT Niederreiter encryption function
%   Encrypts message as a syndrom vector using Hpub

cgf = Hpub*message';
end

