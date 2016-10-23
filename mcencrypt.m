function [ c ] = mcencrypt( message ,Ghat,t)
%MCENCRYPT Encrypts message using the supplied public key
%   Simple matrix multiplication
%
    n = size(Ghat,2);
    z = zeros(1,n);
    z(randperm(numel(z), t)) = 1; % generate random error of weight t
    
    c = mod(message*Ghat+z,2);
end

