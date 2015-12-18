function reward = drawReward(state,sgoal,R,timediscount,action)

    Q = 1e-4;
    action = max(min(action, 10), -10);
    error = state - sgoal;
    reward = - timediscount * ( error'*R*error + action'*Q*action );  
    
    theta = state(3);
    x = state(1);
    reward = 10*cos(theta) - 11 + exp(-25*theta^2) - x^2/2;
    %%
    %error = [error(1) error(3)];
%     if (abs(error(1)) < 0.05 && abs(error(3))< 0.05)
%         reward = 0;
%     elseif (abs(error(1)) < 0.05 || abs(error(3))< 0.05)
%         reward = -0.5*timediscount;
%     else
%         reward = -timediscount;
%     end
end