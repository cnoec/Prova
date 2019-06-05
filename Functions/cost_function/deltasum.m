function [sum_Delta] = deltasum(u, xi0, T_end, Ts, waypoints, n_wp)

u(1:T_end/Ts) = u(1:T_end/Ts)*2000;

[xi, ~, ~] = trajectory_generation(u, xi0, T_end, Ts);

n_states = length(xi);

dist = wp_to_trajectory_distance( waypoints, xi(1:2,:),n_wp,n_states);

% sum_Delta = sum(dist)/1e5;

sum_Delta = dist'*dist/1e7;

end
