 function [hisState, hisReward, hisAction, noise] = trailExploration(policy, worldPara, env, visualize)

    global hf axis_range pole_length tau
    
    sinit = worldPara.sinit;
    sgoal = worldPara.sgoal;
    timeDiscountFactor = worldPara.timeDiscountFactor;
    timeStep = worldPara.timeStep;
    R = worldPara.R;
    learnerType = worldPara.learnerType;

    state = sinit;
    hisAction = zeros(1,timeStep);
    hisReward = zeros(1,timeStep);
    hisState = zeros(length(state),timeStep);
    timeDiscount = timeDiscountFactor;
    timeDis = 1;
    
    noise = 0;
    
    if learnerType == 2 
        noise = generateNoise(policy);
        newpolicy = bsxfun(@plus, noise , policy(:,1:end-1));
        newpolicy = [newpolicy, zeros(timeStep,1)];
    elseif learnerType == 1 || learnerType == 3
        newpolicy = repmat(policy, [timeStep,1]);
    end
    
    if visualize, tic; end
    
    for i=1:timeStep
        hisState(:,i) = state; 
        action = drawAction( newpolicy(i,:), state, learnerType );
        
        %action = policy(1:4)*state;
        
        state = cart_pole( state, action ,env);
        hisAction(i) = action;
        timeDis = timeDis*timeDiscount;
        reward = drawReward( state, sgoal, R, timeDis , action);
        hisReward(i) = reward;
        if ~(state(1)<2.5 && state(1)>-2.5) %% && state(3)<pi/4 && state(3)>-pi/4)
            hisState(:,i:end) = [];
            hisAction(i:end) = [];
            hisReward(i:end) = -30;
             noise = 1;
             break
        end
        if visualize
            while toc<tau, end
            cpvisual( hf, pole_length, state, axis_range );
            tic;
        end
        
    end     
    
end