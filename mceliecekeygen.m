function [Ghat,g,L,Sinv,P,H] = mceliecekeygen(m,t)


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
    
    Ggf = gf(Gsys);
    Hgf = gf(H);
    
    seedbits = 16; % must be less than 32
    seedbinary = randi([0 1],1,seedbits);
    seed = bi2de(seedbinary);
    
    [S,Sinv] = Sgenerator(seed,k);

    
    P = Pgenerator(seed,n);

    
    Ghat = mod(S*Gsys*P,2);
    
end