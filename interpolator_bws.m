function d_interpolated = interpolator_bws(win_k,wout_k,win_kp1,wout_kp1,x_k,y_k)
% INTERPOLATOR BETWEEN 2 CONSEQUENTIAL WAYLINES
% This function computes the relative distance of the vehicle when it is
% travelling between two waylines, in order to compute the right value of
% the imput returned by the optimizator, which computed them only for each
% waylines.
%
% NOTE: for current wayline we mean the wayline that the vehicle has just
%       passed, while the next wayline is the next one.
%
%   inputs:
%           - win_k:        the inner point of the current waylines;
%           - wout_k:       the outer point of the current waylines;
%           - win_kp1:      the inner point of the next waylines;
%           - wout_kp1:     the outer point of the next waylines;
%           - x_k:          current x position of the vehicle;
%           - y_k:          current y position of the vehicle;
%
%   Output:
%           - d_interpolated

curr_pos        =       [x_k , y_k];
% Wayline_k   =       [win_k,wout_k];
% Wayline_kp1 =       [win_kp1,wout_kp1];

d1              =       point_to_line_distance(curr_pos,win_k,wout_k);
d1              =       point_to_line_distance(curr_pos,win_k,wout_k);

d_interpolated  =       ( d1 )/( d1 + d2 );

end

