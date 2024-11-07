function vel = swarm(rr, ro, ra, x, blind_neighbors, N, dxi)
% FILE: swarm.m implements a Boids-like behavior
%
% DESCRIPTION:
% Boids-like repulsion-orientation-attraction behavior based loosely on the 
% behavior described by Couzin et al. in the Collective Memory paper. 
%
% INPUTS:
% rr - radius of repulsion
% ro - radius of orientation
% ra - radius of attraction
% x - matrix containing the pose of all the robots; x(1, ii) is the
% position of robot ii along the horizontal axis; x(2, ii) is the position
% of robot ii along the vertical axis; x(3, ii) is the heading of robot ii
% in radians. Easier alternative to dealing with radians is to use
% dxi(:,ii) instead, which is the heading or velocity of robot ii, as a
% vector
% blind_neighbors - matrix tracking the robots in a robot's blind spot
% neighbors - NxN matrix; entry (ii, jj) is 1 if agents ii and jj are
% neighbors; otherwise, entry is 0
% N - the number of robots in the swarm
% dxi - the current velocity of the robots (2 x N vector); dxi(ii, 1) is
% the velocity component along the horizontal axis, while dxi(ii, 2) is the
% velocity component along the vertical axis)
%
% OUTPUTS:
% vel - the resulting velocity of the robots (2 x N vector); vel(ii, 1) is
% the velocity component along the horizontal axis, while vel(ii, 2) is the
% velocity component along the vertical axis)
%
% TODO:
% Return the velocity (i.e., heading) vel that incorporates repulsion,
% orientation, and attracton with neighbors

%% Authors: Safwan Alam, Musad Haque - 2018
%%%%%%%%%%%%%

% dist(ii, jj) is the distance between robots ii and jj
dist = distances_from_others(x, N); 

% Random movement - Keep this in here. Necessary. 
dxi = -1 + 2*rand(2, 10);

% Keep a copy of the original velocity vector. You might need it to avoid 
% a scenario during orientation where robot ii is trying to align with 
% robot jj while robot jj's heading is being modified
dxi_old = dxi;


%{ 
Distances Matrix - we Don't need this matrix explicitly. Note that the
repulsion/orientation/attraction grids SHALL BE of similar form. "It is the
nature of a thing that matters, not it's form." - Kratos
   1  2  3
 1[0, 3, 1]
 2[3, 0, 2]
 3[1, 2, 0]
 %}
repulsion_grid = zeros(N, N);
orient_grid = zeros(N, N);
attract_grid = zeros(N, N);
for ii = 1:1:N % populate grid
    for jj = 1:1:N
        if (ii ~= jj) % an agent will never be repulsed by itself, oriented to itself, or attracted to itself
            distance_between_agents = dist(ii, jj);
            if distance_between_agents < rr
                repulsion_grid(ii, jj) = true;
            elseif distance_between_agents < ro
                orient_grid(ii, jj) = true;
            elseif distance_between_agents < ra
                attract_grid(ii, jj) = true;
            end
        end
    end 
end

% Repulsion
for ii = 1:1:N
    if any(repulsion_grid(ii, :))
    for jj = 1:1:N
        if ~blind_neighbors(ii, jj) && repulsion_grid(ii, jj) 
            dxi(1, ii) = dxi(1, ii) + -(x(1, jj) - x(1, ii));
            dxi(2, ii) = dxi(2, ii) + -(x(2, jj) - x(2, ii));
        end
    end
    end
end

% Orientation
for ii = 1:1:N
    if ~any(repulsion_grid(ii, :)) % agents in repulsion SHALL NOT BE affected by Orientation or Attraction
    for jj = 1:1:N
        if ~blind_neighbors(ii, jj) && orient_grid(ii, jj)
            dxi(1, ii) = dxi(1, ii) + dxi_old(1, jj);
            dxi(2, ii) = dxi(2, ii) + dxi_old(2, jj);
        end
    end
    end
end

% Attraction
for ii = 1:1:N
    if ~any(repulsion_grid(ii, :)) % agents in repulsion SHALL NOT BE affected by Orientation or Attraction
    for jj = 1:1:N
        if ~blind_neighbors(ii, jj) && attract_grid(ii, jj)
            dxi(1, ii) = dxi(1, ii) + x(1, jj) - x(1, ii);
            dxi(2, ii) = dxi(2, ii) + x(2, jj) - x(2, ii);
        end
    end
    end
end
    

% Accumulate/aggregate the resulting headings in some fashion? Depends on
% how you implement the three headings above.
for ii = 1:1:N
    if norm(dxi(1:2), ii) ~= 0
        dxi(1, ii) = dxi(1, ii)/norm(dxi(1, ii)); % horizontal lolz
        dxi(2, ii) = dxi(2, ii)/norm(dxi(2, ii)); % vertical lmfao
    end
end



% Return the velocity
vel = dxi;

end


