function state = cart_pole( state, action, env)

% state = cart_pole( state, action )
% 
%     Takes as input a state and action and returns the next state
%   TAU seconds later. The state is defined to be a column vector
%   according to:
%
%   state = [ x           <- the cart position
%             x_dot       <- the cart velocity
%             theta       <- the angle of the pole
%             theta_dot ] <- the angular velocity of the pole.
%
%   The action is force applied to the cart and can be positive or
%   negative. All units are standard SI: meters, meter/second,
%   radians, radians/second, and Newtons. Environment parameters,
%   such as gravity and friction, can be changed within the script
%   defining this function (cart_pole.m).
% 
%   Notes:
%    - A minor design consideration is whether to update velocity
%      changes or position changes first. In this implementation,
%      position (including angle) is updated before velocity.
%
%
% Originally written by Zhenzhen Liu
% Modified by Scott Livingston, October 2007
%
% Machine Intelligence Lab, EECS - Univ. of Tennessee
%
% Released under the GNU General Public License, version 3, see
% GPLv3.txt or README for details.


% state components (continuous-valued)
x         = state(1); % current position (units in m)
x_dot     = state(2); % current velocity (in m/s)
theta     = state(3); % current angle of the pole (in radians)
theta_dot = state(4); % current rate of change in angle of the pole (in radians/s)


%global env
% parameters for simulation

if nargin == 2
    g          =  9.8; % gravity (units are m/s^2)
    mass_cart  =  1.0; % mass of the cart (in kg)
    mass_pole  =  0.1; % mass of the pole (in kg)
    total_mass = mass_cart + mass_pole;
    length     =  0.5; % half of the length (in m) of the pole;
                       % (location of pole's center of mass)
    tau        = 0.01; % time interval (in seconds) for updating the values
    mu_c       = 0;    % coefficient of friction between cart and track
    mu_p       = 0;    % coefficient of friction at pole-cart joint.
else
    %keyboard
    g = env.g;
    mass_cart = env.mass_cart;
    mass_pole = env.mass_pole;
    total_mass = mass_cart + mass_pole;
    length = env.length;
    tau = 0.01;
    mu_c = env.mu_c;
    mu_p = env.mu_p;
end
    

noise = 0.1;
action = normrnd(action,noise);
%action = 20/(1+exp(-action/10)) - 10;
action = max(-10, min(10, action));

% calculate the acceleration of theta, given the current state and action
theta_acc = (g*sin(theta) + cos(theta)*( (-action - mass_pole*length*theta_dot*theta_dot*( sin(theta) + mu_c*sign(x_dot)*cos(theta) ))/total_mass + mu_c*sign(x_dot)*g ) - mu_p*theta_dot/(mass_pole*length)) / (length*( 4/3 - mass_pole*cos(theta)*(cos(theta)-mu_c*sign(x_dot) )/total_mass ));

% calculate the magnitude of normal force of the track on the cart;
% this is needed to account for friction in equation for cart acceleration.
Nc = abs(total_mass*g - mass_pole*length*( theta_acc*sin(theta) + theta_dot*theta_dot*cos(theta) ));

% now, calculate the acceleration of x
x_acc = (action + mass_pole*length*(theta_dot*theta_dot*sin(theta) - theta_acc*cos(theta)) - mu_c*Nc*sign(x_dot))/total_mass;

% update the four state variables, using Euler method
x         = x + tau*x_dot;
x_dot     = x_dot + tau*x_acc;
theta     = theta + tau*theta_dot;
theta_dot = theta_dot + tau*theta_acc;

% handle special case: pole is parallel with the horizontal axis
% if theta > pi/2, theta = pi/2; theta_dot = 0; display('Boundary'); end;
% if theta < -pi/2, theta = -pi/2; theta_dot = 0; display('Boundary');end;
% if x > 10, x = 10; x_dot = 0; display('Boundary');end;
% if x < -10, x = -10; x_dot = 0; display('Boundary');end;
if theta > pi, theta = theta-2*pi; end
if theta < -pi, theta = theta+2*pi; end
% return the new state
noise = normrnd([0;0;0;0],[0.5;2;2;2])*0.001;

state = [ x; x_dot; theta; theta_dot ];
state = state + noise;