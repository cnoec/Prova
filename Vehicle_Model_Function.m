function [xi_dot,Forces] = Vehicle_Model_Function(tau,xi,u,d,theta)

% Function that simulates a vehicle with 6 states (planar motion)

%% Read states

g = 9.81;

X       = xi(1,1);
Y       = xi(2,1);
Ux      = xi(3,1);
beta    = xi(4,1);                      % Vehicle Side Slip Angle
psi     = xi(5,1);
r       = xi(6,1);

%% Read inputs

Td      = u(1,1);
delta   = u(2,1);
W       = d(1,1);

%% Parameter vector

m       = theta(1,1);
Jz      = theta(2,1);
a       = theta(3,1);
b       = theta(4,1);
Cf      = theta(5,1);
Cr      = theta(6,1);
rw      = theta(7,1);
mu      = theta(8,1);
Af      = theta(9,1);
Al      = theta(10,1);
Cx      = theta(11,1);
Rr      = theta(12,1);
ro      = theta(13,1);


%% Equations

Uy      = tan( beta )*Ux;

% Tire slip angles
alphaf  = atan( (Uy + a*r)/(Ux) ) - delta;
alphar  = atan( (Uy - b*r)/(Ux) );

% Terms to compute the "FIALA MODEL"
zf      = tan(alphaf);
zr      = tan(alphar);

%% Forces

% Vertical Loads
Fzf     = m*g*( b/(a+b) );
Fzr     = m*g*( a/(a+b) );

% Lateral Forces
Fyf     = min( mu*Fzf, max( -mu*Fzf,-Cf*zf + ( Cf^2*abs(zf)*zf )/( 3*mu*Fzf ) - (Cf^3*zf^3)/(27*mu^2*Fzf^2) ) );
Fyr     = min( mu*Fzr, max( -mu*Fzr,-Cr*zr + ( Cr^2*abs(zr)*zr )/( 3*mu*Fzr ) - (Cr^3*zr^3)/(27*mu^2*Fzr^2) ) );

% Aerodynamic Lateral Force
Fyd     = (1/2)*ro*Al*W^2;

% Force acting along the local x direction (on the rear wheel)
Fx      = Td/rw;

% Rolling resistance Force
Fr      = Rr*Ux;

% Aerodynamic longitudinal Force
Fxd     = (1/2)*ro*Af*Cx*Ux^2;

%% State equations

X_dot        = Ux*cos(psi) - Uy*sin(psi);
Y_dot        = Ux*sin(psi) + Uy*cos(psi);
Ux_dot       = ( (Fx - Fyf*sin(delta)) - Fr - Fxd )/( m );
beta_dot     = ( Fyf*cos(delta) + Fyr + Fyd )/( m*Ux ) - r;
psi_dot      = r;
r_dot        = ( a*Fyf*cos(delta) - b*Fyr )/( Jz );

xi_dot(1,1)  = X_dot;
xi_dot(2,1)  = Y_dot;
xi_dot(3,1)  = Ux_dot;
xi_dot(4,1)  = beta_dot;
xi_dot(5,1)  = psi_dot;
xi_dot(6,1)  = r_dot;

Forces(1,1)  = Fyf; 
Forces(2,1)  = Fyr;
Forces(3,1)  = Fx;

end

