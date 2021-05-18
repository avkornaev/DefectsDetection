function [accuracy,numTruePred,numPred,Ipred,Itar]=...
    accuracyCalcPlural(ns,net,inpData,targData,n,nframes)
%The function calculates accuracy on the basis of series of predictions.
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

Ipred=reshape(Ipred,nframes,[]);%group predictions into sets
Itar=reshape(Itar,nframes,[]);%grop targets into sets too
numPred=length(Ipred);%total number of predictions

%numPredU=numPred;% updatable total number of predictions initialisation 
numTruePred=0;%total number of true predictions
testNumber=0;%counter

for j=1:numPred %check all the predictions
    
    if rem(j,nfb)==0
        testNumber=testNumber+1%the test number counter
        [Ipred(:,j) Itar(:,j)]
        [mode(Ipred(:,j)) mode(Itar(:,j))]
    end
    
    pred=mode(Ipred(:,j));%outputs the most frequent pred. value in the set 
    targ=mode(Itar(:,j));%outputs the most frequent target value in the set
    i=0;%counter
    
    %whileCondition=(pred==ns+1 && j+i< testNumber*n)
%     cksmth0=(pred==ns+1)
%     checksmth=(pred==ns+1 && j+i+1< testNumber*nfb)
%     interval=[j (j+i)]
%     testNumber*nfb
    while pred==ns+1 && j+i+1< (testNumber+1)*nfb && j<numPred %doubt class inside one test
        warning('the doubt class is predicted')
        i=i+1
        interval=[j (j+i)]
        maxval=(testNumber+1)*nfb
        size (Ipred(:,j:(j+i)))
        reshapedPred=reshape(Ipred(:,j:(j+i)),1,[])
        pred=mode(reshape(Ipred(:,j:(j+i)),1,[]))%concatination
        %numPredU=numPredU-1;%exclude one predition from its total number
    end
       
%     if nfbU == j
%         break %samples are over
%     end
    
    if pred == targ && pred~=ns+1 %prediction is true and not the doubt class
        numTruePred=numTruePred+1;
    end
end

accuracy=numTruePred/numPred;

% if size(outp,1)==ns+1%extra class is present
%     sumDoubts=sum(Iout==ns+1);
%     targData=[targData;zeros(1,s(2))];%extra class
%     accuracy=sum(Iout==Itar)/(s(2)-sumDoubts);
% else
%     accuracy=sum(Iout==Itar)/s(2);
% end

end

