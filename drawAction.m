function action = drawAction(policy, states, policyType)

persistent mu

if rand()<0.5
    sigma = exp(policy(end));
else
    sigma = 0;
end
%sigma = 0;
if policyType == 1 % policyType == 'ENAC'
    action = normrnd(policy(1:end-1)*states, 0.01+sigma);
elseif policyType == 2 % policyType == 'POWER'
    action  = policy(:,1:end-1)*states;
elseif policyType == 0
    action = policy(:,1:end-1)*states;
elseif policyType == 3 % network with 1 hidden layer and 50 units & norm bias term for both input and hidden layer
    if ~any(size(mu))
        mu = [-3:6/50:3; -5:10/50:5; -pi:2*pi/50:pi; -5:10/50:5];
    end
    %mu = reshape(policy(1:200),4,50);
    bias1 = reshape(policy(1:204),4,51);
    W1 = policy(205:end);
    %bias1 = 1./(1+exp(-bias));
    distance = (bsxfun(@minus, mu, states)).^2;
    
    hiddenLayer = exp(-sum(distance.*bias1,1));

    action = W1*hiddenLayer';
else
    error('Learning Type not defined');
end

%action = 20/(1+exp(-action/10)) - 10; 
% if rand()<0.05 
%     action = rand()*20-10;
% end
%action = max(-10, min(10, action));

end