function reward = valueFun(policy,world1,env1,varargin)

global world env
if nargin ~=1
    world = world1;
    env = env1;
end
if world.learnerType ~= 3
    world.sinit = (rand(4,1)-0.5)/2;
    L = reshape(policy(1:16), 4,4);
    S = reshape(policy(17:end), 4, 4);
    reward_list = zeros(1,length(env));
    for i = 1:length(env)

        %z = [env{i}.length,1];
        z = zeros(1,4);
        z = [env{i}.mass_cart, env{i}.mass_pole,env{1}.length 1];
        policy11 = z*S*L;
        policy11 = [policy11 0];
        [~,hisReward,~,~] = trailExploration(policy11,world,env{i},false);
        reward_list(i) = -sum(hisReward);

    end
    reward = sum(reward_list)+0.1*norm(policy);
else
   
   [~,hisReward,~,~] = trailExploration(policy',world,env,false);
   reward = -sum(hisReward);

    
end

% policy = [policy' 0];
% [~,hisReward,~,~] = trailExploration(policy,world,env,false);
% reward = -sum(hisReward);

end