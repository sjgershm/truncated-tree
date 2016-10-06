function MDP = init_mdp(MDP,T)
    
    S = size(T,1);
    def_MDP.T = T;
    def_MDP.S = S;
    def_MDP.r = zeros(S,1);
    def_MDP.V = zeros(S,1);
    def_MDP.tau = 0.01;
    def_MDP.w = zeros(S,1);
    def_MDP.Q = 0.1*eye(S);
    def_MDP.C = 4*eye(S);
    def_MDP.c_thresh = 3.5;
    def_MDP.b = 1;
    
    if isempty(MDP)
        MDP = def_MDP;
    else
        F = fieldnames(def_MDP);
        for j = 1:length(F)
            if ~isfield(MDP,F{j})
                MDP.(F{j}) = def_MDP.(F{j});
            end
        end
    end