function delta_est = estimate(temperature_est, neighbors, N, bad_robot)
% FILE: estimate.m implements a consensus-based estimation protocol that
% ignores bad values from a bad_robot
%
% DESCRIPTION:
% Each agent updates their own estimate by applying the
% consensus protocol with its neighbors.
%
% INPUTS:
% temperature_est - everyone's current sensor estimates (Nx1 vector of estimates)
% temperature_est(ii, 1) is the estimate of agent ii; temperature_est(jj, 1) is the estimate of
% agent jj
% neighbors - NxN matrix; entry (ii, jj) is 1 if agents ii and jj are
% neighbors; otherwise, entry is 0
% N - the number of robots in the swarm
% bad_robot - id of malicious actor
%
% OUTPUTS:
% delta_est - the change in estimate required to arrive at a consensus, or 
% basically, how much each should modify its own estimates; 
% delta_est(ii, 1) is how much agent ii's estimates will be changed
%
% TODO:
% Agents should modify their temperature estimates without being influenced by the 
% bad robot. We want agents to run consensus, but we don't 
% want the swarm to be influenced by the bad robot. Feel free to
% amend the argument list of this function, if you must.
% You are not allowed to specifically check for the bad robot. Agents must
% reach consensus by themselves, not with external knowledge. 

%% Authors: Safwan Alam, Musad Haque - 2019
%%%%%%%%%%%%%

% How much agents should change their current estimate; initialized to 0
% for each agent
delta_est = zeros(N, 1);

% Weight used in consensus equation
weight_consensus = 0.0015;

for ii = 1:1:N
    for jj = 1:1:N
        %%%%% Bad robot doing its own thing
        % Do not modify!!!
        if (ii == bad_robot)
            break
        end
        %%%%%

        %%%%% Everyone else running consensus
        % The way it is now, agents are susceptible to the 
        % malicious agent :-( 
        % TODO: The goal is to run consensus and come to an 
        % agreement, but not be influenced by the bad robot. 
        % You can't use the variable `bad_robot` and you can't solve the problem
        % for the swarm. Each agent ii must make a decision by interacting
        % with its neighbors.
        %%%%%
        
        if ((ii ~= jj) && neighbors(ii, jj)) % ii is not jj and jj is ii's neighbor
            % STARTER CODE: delta_est(ii, 1) = delta_est(ii, 1) - weight_consensus * (temperature_est(ii, 1) - temperature_est(jj, 1));
            neighbor_cnt = 0; % Neighbor Count
            cum_sum = 0; % Culmulative Sum
            neighbor_cnt = neighbor_cnt + 1;
            diff = temperature_est(jj, 1)-temperature_est(ii, 1);
            cum_sum = cum_sum + diff;
            delta_est(ii, 1) = (cum_sum/neighbor_cnt) * weight_consensus; % multiply avg by weight consensus
        end

    end
end
               
        
end


