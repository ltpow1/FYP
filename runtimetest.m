% run time tests

m = [10,11];
n = 2.^(m);
t = [13,29,53,71];
times = zeros(length(m),length(t),9);

for j = 1:length(m)
    for i = 1:length(t)
        k = n(j)-m(j)*t(i);
        message = randi([0 1],1,k);
        
        nimessage = zeros(1,n(j));
nimessage(randperm(numel(nimessage), randi([0 t(i)]))) = 1; % generate random message of weight at most t
nimessagegf = gf(nimessage);
        
        name = strcat('m=',num2str(m(j)),'t=',num2str(t(i)),'.mat');
        if exist(name,'file') == 2
            % irred poly prepared earlier
            disp('mceliece')
            a = @()mckeygen(m(j),t(i));
             num= timeit(a,6);
             times(j,i,1) = num;
            
            [Ghat,g,L,Sinv,P,H] = mckeygen(m(j),t(i));
            a = @() mcencrypt(message,Ghat,t(i));
            num= timeit(a);
            times(j,i,2) = num;
            
            c = mcencrypt(message,Ghat,t(i));
            a = @()mcdecrypt(c,P,Sinv,g,H,L,m(j),k);
            num= timeit(a,2);
            times(j,i,3) = num;
            
            disp('ni')
            a = @()nikeygen(m(j),t(i));
            num= timeit(a,7);
            times(j,i,4) = num;
            
            [Hpub,S,Sinv,P,H,g,L] = nikeygen(m(j),t(i));
            a = @()niencrypt(Hpub, nimessagegf);
            num= timeit(a);
            times(j,i,5) = num;
            
            cgf = niencrypt(Hpub, nimessagegf);
            a = @()nidecrypt( cgf,Sinv,P,g,L,H,m(j));
            num= timeit(a);
            times(j,i,6) = num;
            
            disp('hymes')
            a = @()hymeskeygen(m(j),t(i));
            num= timeit(a,4);
            times(j,i,7) = num;
            
            [ Ghat,H,g,L ] = hymeskeygen( m(j),t(i) );
            a = @()hymesencrypt( gf(message),Ghat,n(j),t(i) );
            num= timeit(a);
            times(j,i,8) = num;
            
            [ cgf ] = hymesencrypt( gf(message),Ghat,n(j),t(i) );
            a = @()hymesdecrypt( cgf,g,L,H,m(j),k );
            num= timeit(a);
            times(j,i,9) = num;
        end
    end
end