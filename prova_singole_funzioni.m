clear all
close all
clc

path        =           pwd;
addpath('Functions');
addpath('Model');
addpath('Mat_Data\');
addpath('Functions\unc_optimization');
addpath('Functions\con_optimization');
addpath('Functions\track');
addpath('Functions\cost_function');


%% track generation and waypoints positioning

% choose which track to plot:
% track_number = 1 -> CIRCLE TRACK
% track_number = 2 -> OVAL TRACK
% track_number = 3 -> RANDOM TRACK

track_number = 2;
[~,outerBoundary,innerBoundary,N,x0,y0] = track_generation(track_number);

n_wp = 30;

[ waypoints ] = waypoints_selector(innerBoundary,outerBoundary, n_wp,N);

%% parameters initialization and setting of initial state

m = (outerBoundary(1,2)-innerBoundary(1,2))/(outerBoundary(1,1)-innerBoundary(1,1));
m = -1/m;

X       =       2;         % inertial X position (m)
Y       =       -50;         % inertial Y position (m)
Ux      =       20;         % body x velocity (m/s)
beta    =       0;          % sideslip angle (rad)
psi     =       atan(m);    % yaw angle (rad)
r       =       0;          % yaw rate (rad/s)

xi0     =       [X Y Ux beta psi r]';

%% time

Ts = 1e-1;
Ts_sim = 1e-3;
T_end = 25;
N = T_end/Ts +1;


u = [30; 20; 0.61/15*ones(N,1);];

[xi, t_vec, exitflag,Torque] = trajectory_generation_cc(u, xi0, T_end, Ts, Ts_sim);
figure
plot(xi(1,:), xi(2,:)),grid on;

figure
plot(t_vec, xi(3,:)), grid on;

figure
plot(t_vec(1:(end-1)), Torque), grid on;


%%
% [xi_sim, t_vec, exitflag] = trajectory_generation_sim(u, xi0, T_end, Ts);
% 
% %% plot
% 


%% test cost function
tic
cost = deltasum(u, xi0, T_end, Ts, waypoints, n_wp);
cost_fun_time = toc

% %% gradiente
% 
% tic
% [y, grad] = gradient_num_comp((@(u)deltasum(u, xi0,T_end,Ts,waypoints, n_wp)), u, 'FD', 2^-17);
% grad_time = toc