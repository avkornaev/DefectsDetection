function [accuracy,precision,recall,Fscore,sensitivity,specificity,...
    numTruePred,numPredU,Ipred,Itar,sampleLength]=...
    accuracyCalcPluralV3(ns,net,inpData,targData,n,nframes,...
    doubtModeReaction)
%The function calculates accuracy on the basis of series of predictions on nframes.
%The series consists of nframes

s=size(targData);
nfb=n/nframes;%number of prediction sets in a test

%check
if rem(n,nframes)~=0
    error('rem(n,nframes)~=0')
end
    
H = net(inpData);%predictions 
[Mpred,Ipred]=max(H);
[Mtar,Itar]=max(targData);
numClasses=ns;
TP=zeros(numClasses,1);%true positives over classes predictions counter 
TN=TP;FP=TP;FN=TP;%true negatives, false positive, false negative

Ipred=reshape(Ipred,nframes,[]);%group predictions into sets
Itar=reshape(Itar,nframes,[]);%grop targets into sets too
numPred=size(Ipred,2);%total number of predictions
sampleLength=ones(1,numPred)*nframes;

numPredU=numPred;% updatable total number of predictions initialisation 
numTruePred=0;%total number of true predictions
testNumber=0;%counter

for j=1:numPred %check all the predictions
    
    if rem(j,nfb)==0
        testNumber=testNumber+1;%the test number counter
    end
    
    pred=mode(Ipred(:,j));%outputs the most frequent pred. value in the set 
    targ=mode(Itar(:,j));%outputs the most frequent target value in the set
    i=0;%counter
    concSample=Ipred(:,j);
    
    switch doubtModeReaction
        case "oneMoreSet"
            while pred==ns+1 && j+i+1< (testNumber+1)*nfb && j<numPred %doubt class inside one test
                i=i+1;
                %Concatinate and predict
                concSample=reshape(Ipred(:,j:(j+i)),1,[]);
                pred=mode(concSample);
                %Calculate sample length
                sampleLength(j)=length(concSample);
            end
        case "pass"
            %concSample=Ipred(:,j);
    end
    
%     %Exclude doubts
%     kk=0;%counter
%     for k=1:sampleLength(j)
%         kk=kk+1;
%         if concSample(kk)==ns+1
%             concSample(kk)=[];
%             kk=kk-1;
%         end
%     end
%     %Final decision on a set
%     if ~isempty(concSample)
%         pred=mode(concSample);
%     else
%         pred=ns+1;
%     end
   
    %Warning, just in case
    if pred==ns+1
        warning(['the ',num2str(j),'-th sample responsed as the doubt class'])
    end
    
    for k=1:numClasses
        if pred == k && targ == k
            TP(k)=TP(k)+1;
        end
        if pred ~= k && targ ~= k
            TN(k)=TN(k)+1;
        end
        if pred == k && targ ~= k
            FP(k)=FP(k)+1;
        end
        if pred ~= k && targ == k
            FN(k)=FN(k)+1;
        end        
    end
       
    if pred == targ%prediction is true
        numTruePred=numTruePred+1;
    end
    
end
%numClasses=numClasses
%PredictionsMatrix=[TP TN FP FN]

%accuracy=mean((TP+TN)./(TP+TN+FP+FN))
accuracy=numTruePred/numPredU;

%Micro averaging
% precision=sum(TP)/(sum(TP)+sum(FP));
% recall=sum(TP)/(sum(TP)+sum(FN));
% Fscore=2*precision*recall/(precision+recall);
% sensitivity=sum(TP)/(sum(TP)+sum(FN));%probability of a positive 
% specificity=sum(TN)/(sum(TN)+sum(FP));

%Macro averaging
precision=median(TP./(TP+FP));
recall=median(TP./(TP+FN));
Fscore=2*median(precision.*recall./(precision+recall));
sensitivity=median(TP./(TP+FN));%probability of a positive 
specificity=median(TN./(TN+FP));

% if size(outp,1)==ns+1%extra class is present
%     sumDoubts=sum(Iout==ns+1);
%     targData=[targData;zeros(1,s(2))];%extra class
%     accuracy=sum(Iout==Itar)/(s(2)-sumDoubts);
% else
%     accuracy=sum(Iout==Itar)/s(2);
% end

end

