function [ cgf ] = hymesencrypt( messagegf,Ghat,n,t )
%hymesencrypt Encrypts message using HyMes public key
%   

z = zeros(1,n);
z(randperm(numel(z), t)) = 1; % generate random error of weight t
zgf = gf(z);

cgf = [messagegf,messagegf*Ghat]+zgf;
end

