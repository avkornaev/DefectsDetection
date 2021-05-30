function [net] = patternNet(trainAlgorithmPN,hiddenLayerSize,...
                        nAll,nTrain,nValidation,nTest,maxEpochs,...
                        performanceGoal,maxValChecks,minGrad)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%Create the ANN template
net = patternnet(hiddenLayerSize); 
net.divideFcn='divideind';
[trainInd,valInd,testInd] = divideind(nAll,(1:nTrain),...
     ((nTrain+1):(nTrain+nValidation)),...
     ((nTrain+nValidation+1):(nTrain+nValidation+1+nTest)));
net.divideParam.trainInd=trainInd;
net.divideParam.valInd=valInd;
net.divideParam.testInd=testInd;
net.trainFcn=trainAlgorithmPN;%'traingdm';%'trainscg';
net.trainParam.epochs = maxEpochs; 
net.trainParam.goal = performanceGoal; 
net.trainParam.max_fail = maxValChecks; 
net.trainParam.min_grad=minGrad;
%net.trainParam.lambda=lambda;
end

