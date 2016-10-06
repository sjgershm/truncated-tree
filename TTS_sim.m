function results = TTS_sim(MDP,R,s0)
    
    nIter = size(R,1);
    
    for n = 1:nIter
        s = s0(n); j = 0; MDP.x = zeros(1,MDP.S); MDP.x(s) = 1;
        while any(MDP.T(s,:))
            j = j + 1;
            [V,adj,results(n).RT(j)] = TTS(MDP,s);
            results(n).s(j) = s;
            p = exp(MDP.b*V - logsumexp(MDP.b*V));
            k = fastrandsample(p');
            s = adj(k);
            r = R(n,s);
            MDP = KTD(s,r,MDP);
            results(n).r(j) = r;
            results(n).MDP = MDP;
        end
    end