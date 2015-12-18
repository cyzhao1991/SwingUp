% load('STLvsMTL.mat','world','env_list');
% lengthList = [0.2 0.5 1 1.5];
% sigma = 10;
% initPolicy = zeros(4,1);
% for i = 1:4
%     env_list{i}.mass_pole = 0.2;
%     env_list{i}.length = lengthList(i);
% end
% 
% for i = 1:4
%     reward = valueFun(initPolicy,world,env_list{i});
%     [xmin,fmin,counteval,stopflag,out,bestever] = cmaes('valueFun',initPolicy,sigma);
%     result_list{i} = bestever;
% 
% end
% 
% %%
% 
% for i = 1:4
%     finalPolicy = [result_list{i}.x;0]';
%     [~,hisReward,hisAction,~] = trailExploration(finalPolicy,world_test,env_list{i},false);
%     result_list{i}.reward = sum(hisReward);
%     result_list{i}.hisAction = hisAction;
% end

%%
clear all;
load('temp/Dec14.mat', 'world', 'env_list')
env = env_list{3};
world.learnerType = 3;
world.timeStep = 1000;
world.sinit = [0; 0; pi-0.01; 0];
sigma = 10;
initPolicy = zeros(255,1);
reward = valueFun(initPolicy,world,env);

[xmin,fmin,counteval,stopflag,out,bestever] = cmaes('valueFun',initPolicy,sigma);
save('temp/Dec18SwingUp.mat')
%%
% trailExploration(finalPolicy,world,env,true);