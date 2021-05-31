%% 0. Downloading and mixing martices
clear
clc
%close all

cd 'G:\DefectsDetection'
load dataSet

nframes=10;%number of samples for one decision
edge=size(inputs,1);%edge=400;
ms=3;%averaging when calculating accuracy starts from the ms-th iteration
maxTrainIter=10;%number of training cicles
GNratio=1;%the gaussian noise ratio when GaussianNoise="on" 
maxDoubtsRatio=0.8;%maximum Doubts Ratio

%Networks settings
%The patternnet settings, including net.trainParam
hiddenLayerSize = [8 8 8 8];%sizes of hidden layers
trainAlgorithmPN='traincgf';
maxEpochs=33;%Maximum Epochs
performanceGoal=0;%Performance Goal
minGrad=1e-8;%minimal value of the gradient 
maxValChecks=1e8;%Maximum Validation Checks

%The MLP settings
trainAlgorithm = 'sgdm';% 'sgdm', 'adam'
InitLearnRate = 5e-3;%initial learning rate
LearnRateDropFac=0.5;
LearnRateDropPer=1;
MaxEp = 1;%max epoches
MiniBatchS = 20;
GradientThres=2;
validationFrequency = floor(length(targets)/MiniBatchS);
checkpointPath = 'SaveCheckpoints';

%Switches
newClassDesign="off";%a new class design switch, "on","off"
doubtModeReaction="oneMoreSet";% reaction on the doubt response is "oneMoreSet" or "pass"
netType='mlp';% 'mlp', 'patternNet'
modeN="useNetTemplate";%загрузка шаблона или обученной сети:
% "useNetTemplate","useTrainedNet"
GaussianNoise=struct('switch',"on",'value',10,'treshold',100);%add gaussian noise to signals while relabeling
switchSet=struct('newClassDesign',newClassDesign,...
    'doubtModeReaction',doubtModeReaction,'netType',netType,'modeN',modeN,...
    'GaussianNoise',GaussianNoise);%all switches are in one structure

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
            
            switch netType
                case 'patternNet'
                    [net] = patternNet(trainAlgorithmPN,hiddenLayerSize,...
                        nAll,nTrain,nValidation,nTest,maxEpochs,...
                        performanceGoal,maxValChecks,minGrad);
                    [net,tr] = train(net,inp(1:edge,:),tar);%,'CheckpointFile','MyCheckpoint');
                    figure
                    plotperform(tr)
                case 'mlp'
                    numClasses=size(targets,1)
                    numFeatures=size(inputs(1:edge,:),1);
                    [tbl] = transformInputs(inputs(1:edge,:),targets);
                    [tbl_val] = transformInputs(inputs_val(1:edge,:),targets_val);
                    [tbl_test] = transformInputs(inputs_test(1:edge,:),targets_test);
                    
                    switch switchSet.modeN
                        case "useNetTemplate"
                            [layers] = ...
                            mlp(numFeatures,hiddenLayerSize(1),numClasses);
                            %analyzeNetwork(layers)
                        case "useTrainedNet"
                            %Download a trained network
                            load trained_net;%
                    end
                    %InitLearnRate=InitLearnRate*LearnRateDropFac/c;
                    opts = trainingOptions(trainAlgorithm, ...
                    'InitialLearnRate',InitLearnRate, ...
                    'LearnRateDropFactor',LearnRateDropFac, ...
                    'LearnRateDropPeriod',LearnRateDropPer, ...
                    'GradientThreshold',GradientThres, ...
                    'MaxEpochs',MaxEp, ...
                    'MiniBatchSize',MiniBatchS,...
                    'ValidationData',tbl_val, ...
                    'Verbose',true, ...
                    'CheckpointPath',checkpointPath);%,...
                    %'Plots','training-progress');
                    
                    if c<=2
                        net = trainNetwork(tbl,layers,opts)
                    else
                        trainedNet=[];
                        net = trainNetwork(tbl,net.Layers,opts)%use trained
                    end 
                
            end
            
            if newClassDesign=="on"
            %[inputs,targets]=doubts_class(ns,net,inputs,targets);
            [targets,Ipred,Mtar,Itar,classDistr]=...
                  doubts_class(ns,net,inputs(1:edge,:),targets,targets0,...
                  maxDoubtsRatio,netType,GaussianNoise);
            %DoubtsVsTrain=[sumDoubts nTrain]
            [targets_val,Ipred,Mtar,Itar,classDistr_val]=...
                  doubts_class(ns,net,inputs_val(1:edge,:),targets_val,targets_val0,...
                  maxDoubtsRatio,netType,GaussianNoise);                    
            
            classDistribution(c,:)=classDistr;
            classDistribution_val(c,:)=classDistr_val;  
            Ipred2Remember=Ipred;
            Itar2Remember=Itar;
            end
            
        [accuracy,precision,recall,Fscore,sensitivity,specificity,...
            numTruePred,numPredU,IpredU,ItarU,sampleLength]=...
            accuracyCalcPluralV3(ns,net,inputs_test(1:edge,:),...
            targets_test,n,nframes,doubtModeReaction,netType);
         currentaccuracy(c)=accuracy;
         currentprecision(c)=precision;
         currentrecall(c)=recall;
         currentFscore(c)=Fscore;
         currentsensitivity(c)=sensitivity;
         currentspecificity(c)=specificity;
         
         
         currentaccuracy(end)
         [numTruePred numPredU c]
        end
        

%meanAccuracy=mean(currentAccuracy)
%The median values are calculated starting from the ms-th iteration

      

%% Visualisation
accuracy=median(currentaccuracy(ms:end))%
precision=median(currentprecision(ms:end))%
recall=median(currentrecall(ms:end))%
Fscore=median(currentFscore(ms:end))%
sensitivity=median(currentsensitivity(ms:end))%probability of a negative test given that the patient is well
specificity=median(currentspecificity(ms:end))%probability of a negative test given that the patient is well

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

figure('Color','w')
testNo=linspace(1,size(ItarU,2),size(ItarU,2));
plot(testNo,mode(ItarU),'ok',testNo,mode(IpredU),'xr');
legend('target class No','predicted class No')
title ('Predictions vs Targets for the test set')

figure
numIter=linspace(1,maxTrainIter,maxTrainIter);
plot(numIter,currentaccuracy,'-k',numIter,currentprecision,'--b',numIter,currentrecall,'-.b',...
    numIter,currentFscore,'-b',numIter,currentsensitivity,'xg',numIter,currentspecificity,'og')
legend('accuracy','precision','recall','Fscore','sensitivity','specificity')
xlabel('# iteration')
title (['Median a=',num2str(accuracy),...
        'p' Dynamics'])

inputsN=awgn(inputs,30,'measured');
figure
plot(inputs(:,121),'-r')
hold on
plot(inputsN(:,121),':b')
hold off

% switch netType
%     case 'patternNet'
%         H = net(inputs_test(1:edge,:));
%         [Mpred,Ipred]=max(H);%predictions
%     case 'mlp'
%         Ipred = double(classify(net,inputs_test(1:edge,:)'));
% end
% [Mtar,Itar]=max(targets_test);
% 
% figure
% plotconfusion(Ipred, Itar);










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
