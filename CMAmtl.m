clear all;
load('temp/Dec14.mat','world','env_list');
initPolicy = zeros(32,1);
sigma = 10;

reward = valueFun(initPolicy, world, env_list);
[xmin,fmin,counteval,stopflag,out,bestever] = cmaes('valueFun',initPolicy,sigma);


%%

policy1 = bestever.x;
L = reshape(policy1(1:16), 4,4);
S = reshape(policy1(17:end), 4,4);
overall_reward = 0;
for i = 1:length(env_list)
    
    %z = [env_list{i}.length,1];
    z = zeros(1,4);
    z = [env_list{i}.mass_cart, env_list{i}.mass_pole,env_list{1}.length 1];
    policy11 = z*S*L;
    policy11 = [policy11 0]; 
    [~,hisReward,hisAction,stopflag] = trailExploration(policy11,world,env_list{i},true); 
    result_list{i}.reward = -sum(hisReward);
    result_list{i}.hisAction = hisAction;
    result_list{i}.stopflag = stopflag;
    overall_reward = overall_reward + result_list{i}.reward;
end

save('temp/Dec14cma.mat');