function [G_hat,g,L,S_inv,P,H] = mceliecekeygen(m,t)


    name = strcat('m=',num2str(m),'t=',num2str(t),'.mat');
    if exist(name,'file') == 2 
        % irred poly prepared earlier
        load(name)
    [H, n, k,g,L] = goppagen(t,m,g);
    else
        [H, n, k,g,L] = goppagen(t,m);
    end
    [Hsys, Psys] = systematizer(H);
    Gsys = [eye(k),Hsys(:,1:k)'];
    % if Psys is a non-identity matrix permutation, must recalculate H and L
    if(all(all(Psys == eye(size(Psys))))==0)
        L = L*Psys;
        H = goppargen(g,L);
    end
    
    G_gf = gf(Gsys);
    H_gf = gf(H);
    
    seed_bits = 16; % must be less than 32
    seed_binary = randi([0 1],1,seed_bits);
    seed = bi2de(seed_binary);
    
    [S,S_inv] = S_generator(seed,k);

    
    P = P_generator(seed,n);

    
    G_hat = mod(S*Gsys*P,2);
    
end