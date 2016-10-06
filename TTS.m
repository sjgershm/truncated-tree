function [R,adj,RT] = TTS(MDP,s)
    
    % Truncated tree-search.
    %
    % USAGE: [R,adj] = TTS(MDP,s,opts)
    %
    % INPUTS:
    %   MDP - Markov decision process structure with the following fields:
    %           .T - [S x S] transition matrix. T(s,s') = 1 indicates a transition from s to s'
    %           .V - [S x 1] cached state value estimates
    %           .c - [S x 1] variances of state value estimates
    %           .r - [S x 1] cached state reward estimates
    %   s - starting state
    %
    % OUTPUTS:
    %   R - vector of expected returns for each adjacent state
    %   adj - vector of adjacent state indices
    %
    % Sam Gershman, Oct 2016
    
    adj = find(MDP.T(s,:)==1);
    R = zeros(length(adj),1); D = zeros(length(adj),1);
    for j = 1:length(adj)
        [R(j),D(j)] = forwardsearch(adj(j),0,1,MDP);
    end
    RT = sum(D);
    
end

function [R,D] = forwardsearch(s,R,D,MDP)
    
    adj = find(MDP.T(s,:)==1);  % adjacent states
    if ~isempty(adj)
        for i = adj
            if MDP.C(i,i) < MDP.c_thresh
                v = R + MDP.V(i);                      % use cached values if below variance threshold
            else
                v = MDP.r(i) + forwardsearch(i,R,D,MDP); % otherwise recurse
                D = D + 1;
            end
            R = max(R,v);
        end
    end
    
end