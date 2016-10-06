function MDP = KTD(s,r,MDP)
    
    % Kalman filter update
    %
    % USAGE: MDP = KTD(s,r,MDP)
    %
    % Sam Gershman, Oct 2016
    
    x = zeros(1,MDP.S); x(s)=1; % state features
    h = MDP.x - x;              % temporal difference features
    rhat = h*MDP.w;             % reward prediction
    dt = r - rhat;              % prediction error
    MDP.C = MDP.C + MDP.Q;      % a priori covariance
    P = h*MDP.C*h'+ MDP.tau;    % residual covariance
    K = MDP.C*h'/P;             % Kalman gain
    MDP.w = MDP.w + K*dt;       % weight update
    MDP.C = MDP.C - K*h*MDP.C;  % posterior covariance update
    MDP.x = x;                  % store state features
    MDP.r(s) = r;               % keep track of rewards