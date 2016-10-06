function [cdiff, RTdiff] = sim_3step(nIter)
    
    % 1 - A
    % 2 - B
    % 3 - C
    % 4 - D
    % 5 - E
    % 6 - F
    % 7 - G
    % 8 - H
    % 9 - I
    
    if nargin < 1; nIter = 200; end
    
    % transition function
    T = zeros(9);
    T(1,[3 4 5]) = 1;
    T(2,[3 4 5]) = 1;
    T(3,[6 7]) = 1;
    T(5,[8 9]) = 1;
    
    % optional parameters
    MDP.c_thresh = 4;
    
    for t = 1:20
        
        % reward function
        R = [zeros(nIter,5) cumsum(normrnd(zeros(nIter,4),0.01))];
        MDP = init_mdp(MDP,T);
        
        % initial state
        s0 = [ones(nIter/2,1); ones(nIter/2,1)+1];
        s0 = s0(randperm(nIter));
        N = randperm(nIter);
        s0(N(1:round(0.8*nIter))) = 3;
        
        % run simulation
        results = TTS_sim(MDP,R,s0);
        
        c = diag(results(end).MDP.C);
        cdiff(t) = c(5)-c(3);
        
        RT = []; s = [];
        for n = 1:length(results)
            RT = [RT results(n).RT];
            s = [s results(n).s];
        end
        RTdiff(t) = mean(RT(s==2)) - mean(RT(s==1));
    end