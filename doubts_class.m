function [targets,Ipred,Mtar,Itar,classDistribution]=...
    doubts_class(ns,net,inpData,targData,targets0,maxDoubtsRatio,...
    netType,GaussianNoise)
%SUBPROGRAM generates or updates the extra "I Don't know" class 

sumDoubts=0;
%Sizes
si=size(inpData);
st=size(targData);
%targDataU=targData;%updatable targets 
inpDataU=inpData;%updatable inputs (by noize)

%Add an extra row for the extra class if it is absent
if st(1)==ns
    targData=[targData;zeros(1,st(2))];%ns+1 raw is for "IDK"
    %targDataU=[targDataU;zeros(1,st(2))];%ns+1 raw is for "IDK"
end

classDistribution=sum(targData,2);
%classDistribution(end)== max(classDistribution)
%GNV=GaussianNoise.value;
%GNT=GaussianNoise.treshold;
ic=0;

%At least 1 time and while doubt class is not the largest, and GNV<GNT 
while ( ic<1 || classDistribution(end) == max(classDistribution)) && ...
        GaussianNoise.value < GaussianNoise.treshold
    ic=ic+1%counter
    targDataU=targData;%updatable targets
    %Add noise to make predictions harder
    if GaussianNoise.switch == "on"
        inpDataU=awgn(inpData,GaussianNoise.value,'measured');
    end
    %Predictions
    switch netType
        case 'patternNet'
            H = net(inpDataU);
            [Mpred,Ipred]=max(H);%predictions
        case 'mlp'
            Ipred = double(classify(net,inpDataU'));
    end
    [Mtar,Itar]=max(targData);%targets
    [Mtar0,Itar0]=max(targets0);%targets
    for j=1:st(2)*maxDoubtsRatio
        %Way into the "IDK" class
        if Itar(j)~=Ipred(j) && Ipred(j)~=ns+1
            targDataU(:,j)=zeros(ns+1,1);%erase first
            targDataU(ns+1,j)=1;%
            sumDoubts=sumDoubts+1;
        end
        %Way back for the true predictions
        if Itar(j)~=Ipred(j) && Ipred(j)==Itar0(j)
            targDataU(:,j)=zeros(ns+1,1);%erase first
            targDataU(Itar0(j),j)=1;%
            sumDoubts=sumDoubts-1;
        end
    end
    classDistribution=sum(targDataU,2)
    GaussianNoise.value=GaussianNoise.value+10
end

targets=targDataU;
end

