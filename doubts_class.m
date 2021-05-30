function [targets,Ipred,Mtar,Itar,classDistribution]=...
    doubts_class(ns,net,inpData,targData,targets0,maxDoubtsRatio,...
    netType)
%SUBPROGRAM generates or updates the extra "I Don't know" class 

sumDoubts=0;
%Sizes
si=size(inpData);
st=size(targData)

%Add an extra row for the extra class if it is absent
if st(1)==ns
    targData=[targData;zeros(1,st(2))];%ns+1 raw is for "IDK"
end

%Predictions
switch netType
    case 'patternNet'
        H = net(inpData);
        [Mpred,Ipred]=max(H);%predictions
    case 'mlp'
        Ipred = double(classify(net,inpData'));
end
[Mtar,Itar]=max(targData);%targets
[Mtar0,Itar0]=max(targets0);%targets


for j=1:st(2)*maxDoubtsRatio
    %Way into the "IDK" class
    if Itar(j)~=Ipred(j) && Ipred(j)~=ns+1
        targData(:,j)=zeros(ns+1,1);%erase first
        targData(ns+1,j)=1;%
        sumDoubts=sumDoubts+1;
        %wiIDK=targData(:,j)
    end
    %Way back for the true predictions
    if Itar(j)~=Ipred(j) && Ipred(j)==Itar0(j)
        targData(:,j)=zeros(ns+1,1);%erase first
        targData(Itar0(j),j)=1;%
        sumDoubts=sumDoubts-1;
        %wbiIDK=targData(:,j)
    end
end

targets=targData;
classDistribution=sum(targets,2);
end

