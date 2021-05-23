%% 0. Downloading and mixing martices
clear
clc
close all

cd 'H:\Exp_Defects_Detecting_Competition_mar_2020'
load dataSet


%Modal value
%n=100;% кол-во обучающих выборок из 1 опыта
nmoda=n;% number of samples from one test 
nframes=10;%number of samples for one decision
edge=400;

%Settings, including net.trainParam
hiddenLayerSize = [8 8 8 8];%sizes of hidden layers
maxEpochs=500;%Maximum Epochs
performanceGoal=0;%Performance Goal
minGrad=1e-8;%minimal value of the gradient 
maxValChecks=1e8;%Maximum Validation Checks
%lambda=5e-5;%Lambda parameter
%divideDataSet=[0.7,0.2,0.1];%training,validation and test subsets
maxTrainIter=50;%number of training cicles
maxDoubtsRatio=0.8;%maximum Doubts Ratio

%Switches
newClassDesign="on";%a new class design switch, "on","off"
doubtModeReaction="oneMoreSet";% reaction on the doubt response is "oneMoreSet" or "pass"

%Initialisation
classDistribution=zeros(maxTrainIter,ns+1);
classDistribution_val=zeros(maxTrainIter,ns+1);

%% 1. Training using inputs,targets

        acDyn=0; acMVDyn=0; doubtClassDyn=0;
        for c=1:maxTrainIter
            if c==1
                %Mix matrices and create dataset 
                [inputs,targets]=mix_col(inputs,targets);
                [inputs_val,targets_val]=mix_col(inputs_val,targets_val);
                %[inputs_test,targets_test]=mix_col(inputs_test,targets_test);
                ns%number of classes is taken from dataSet.mat
                
                targets0=targets; targets_val0=targets_val;%save initial labels
                
                %Caclulate number of samples  
                nTrain=length(targets);
                nValidation=length(targets_val);
                nTest=length(targets_test);
                nAll=nTrain+nValidation+nTest;
                
                %Merge subsets into the main set
                inp=[inputs inputs_val inputs_test];
                tar=[targets targets_val targets_test];
                
            end
                        
            %Correct the labels
            if c==2 && newClassDesign=="on"
                %The test set is out of relabeling.
                %So, simply add zeros in the targets_test for the extra class
                targets_test=...
                     [targets_test;zeros(1,size(targets_test,2))];
                %Rewrite targets in the main set
                tar=[targets targets_val targets_test]; 
            end
            
                %Create the ANN template
                net = patternnet(hiddenLayerSize); 
                net.divideFcn='divideind';
                [trainInd,valInd,testInd] = divideind(nAll,(1:nTrain),...
                                     ((nTrain+1):(nTrain+nValidation)),...
                    ((nTrain+nValidation+1):(nTrain+nValidation+1+nTest)));
                net.divideParam.trainInd=trainInd;
                net.divideParam.valInd=valInd;
                net.divideParam.testInd=testInd;
                
                net.trainFcn='trainscg';
                
                net.trainParam.epochs = maxEpochs; 
                net.trainParam.goal = performanceGoal; 
                net.trainParam.max_fail = maxValChecks; 
                net.trainParam.min_grad=minGrad;
                %net.trainParam.lambda=lambda;
                
            %Train the ANN
%             if c>2
%                 %load pretrained net
%                 load MyCheckpoint
%                 net=checkpoint.net;
%                 %load the newer data
% %                 net.divideParam.trainInd=trainInd;
% %                 net.divideParam.valInd=valInd;
% %                 net.divideParam.testInd=testInd;
%             end
            [net,tr] = train(net,inp(1:edge,:),tar);%,'CheckpointFile','MyCheckpoint');
            
            figure
            plotperform(tr)
            
        if newClassDesign=="on"
            %[inputs,targets]=doubts_class(ns,net,inputs,targets);
            [targets,Mpred,Ipred,Mtar,Itar,H,classDistr]=...
                  doubts_class(ns,net,inputs(1:edge,:),targets,targets0,...
                  maxDoubtsRatio);
            %DoubtsVsTrain=[sumDoubts nTrain]
            [targets_val,Mpred,Ipred,Mtar,Itar,H,classDistr_val]=...
                  doubts_class(ns,net,inputs_val(1:edge,:),targets_val,targets_val0,...
                  maxDoubtsRatio);                    
            
            classDistribution(c,:)=classDistr;
            classDistribution_val(c,:)=classDistr_val;  
            Ipred2Remember=Ipred;
            Itar2Remember=Itar;
            %DoubtsVsValidation=[sumDoubts nValidation]
            
            %doubtClassDyn=[doubtClassDyn sumDoubts];
        end
        
        [accuracy,numTruePred,numPredU,IpredU,ItarU,sampleLength]=...
            accuracyCalcPluralPlus(ns,net,inputs_test(1:edge,:),targets_test,...
            n,nframes,doubtModeReaction);
         currentAccuracy(c)=accuracy;
         currentAccuracy(end)
         [numTruePred numPredU c]
        end

meanAccuracy=mean(currentAccuracy)
medianAccuracy=median(currentAccuracy)
        

%% Visualisation

if newClassDesign=="on"
figure ('Color','w')
numIter=linspace(1,maxTrainIter,maxTrainIter);
plot(numIter,classDistribution(:,1),'-y',...
     numIter,classDistribution(:,2),'-m',...
     numIter,classDistribution(:,3),'-c',...
     numIter,classDistribution(:,4),'-r',...
     numIter,classDistribution(:,5),'-g',...
     numIter,classDistribution(:,6),'-b',...
     numIter,classDistribution(:,7),'-k',...
     numIter,sum(classDistribution,2),'ok')
legend('class1','class2','class3','class4','class5','class6','class7','total')
xlabel('# iteration')
ylabel('# samples')
title ('Train class distribution')

figure ('Color','w')
numIter=linspace(1,maxTrainIter,maxTrainIter);
plot(numIter,classDistribution_val(:,1),'-y',...
     numIter,classDistribution_val(:,2),'-m',...
     numIter,classDistribution_val(:,3),'-c',...
     numIter,classDistribution_val(:,4),'-r',...
     numIter,classDistribution_val(:,5),'-g',...
     numIter,classDistribution_val(:,6),'-b',...
     numIter,classDistribution_val(:,7),'-k',...
 numIter,sum(classDistribution_val,2),'ok')
legend('class1','class2','class3','class4','class5','class6','class7','total')
xlabel('# iteration')
ylabel('# samples')
title ('Validation class distribution')

figure('Color','w')
plot(sampleLength,'xr')
xlabel('Sample number')
ylabel('Sample length')

end

figure
plot(currentAccuracy)
xlabel('# iteration')
title ('Accuracy Dynamics')

figure('Color','w')
testNo=linspace(1,length(ItarU),length(ItarU));
plot(testNo,mode(ItarU),'ok',testNo,mode(IpredU),'xr');
legend('target class No','predicted class No')
title ('Predictions vs Targets for the test set')














% figure
% plot(acMVDyn)
% xlabel('# iteration')
% title ('Accuracy Modal values Dynamics')


% 
% %The ANN check using new data from inputs_val and targets_val
% Accuracy=accuracy_calc(ns,net,inputs_val,targets_val)

% %% 2. Doubts class formulation
% switch newClassDesign
% case "on"
% [inputs,targets]=doubts_class(ns,net,inputs,targets);
% [inputs_val,targets_val]=doubts_class(ns,net,inputs_val,targets_val);
% if size(targets_test,1)==ns
%     targets_test=[targets_test;zeros(1,size(targets_test,2))];
% end
% end
% %Deliting
% net=[];tr=[];inp=[];tar=[];
% %% 3. Training using newer dataset with a new class
% inp=[inputs inputs_val];
% tar=[targets targets_val];
% 
% %The ANN design and settings 
% net = patternnet(hiddenLayerSize); 
% net.trainParam.epochs = maxEpochs; 
% net.trainParam.goal = performanceGoal; 
% net.trainParam.max_fail = maxValChecks; 
% net.trainParam.min_grad=minGrad;
% %net.trainParam.lambda=lambda;
% net.divideParam.trainRatio = divideDataSet(1);
% net.divideParam.valRatio = divideDataSet(2);
% net.divideParam.testRatio = divideDataSet(3);
% 
% %Training
% [net,tr] = train(net,inp,tar);
% figure
% plotperform(tr)
% 
% %The ANN check using new data from inputs_test and targets_