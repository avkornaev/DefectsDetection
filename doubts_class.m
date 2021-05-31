function [targets,Ipred,Mtar,Itar,classDistribution]=...
    doubts_class(ns,net,inpData,targData,targets0,maxDoubtsRatio,...
    netType,GaussianNoise)
%SUBPROGRAM generates or updates the extra "I Don't know" class 

sumDoubts=0;
%Sizes
si=size(inpData);
st=size(targData);

%Add an extra row for the extra class if it is absent
if st(1)==ns
    targData=[targData;zeros(1,st(2))];%ns+1 raw is for "IDK"
end



classDistribution=sum(targData,2);
%classDistribution(end)== max(classDistribution)
GNV=GaussianNoise.value;
GNT=GaussianNoise.treshold;
ic=0;
while (GNV < GNT || classDistribution(end)~= max(classDistribution))&& ic<1
    ic=ic+1%counter
    %Add noise to make predictions harder
    if GaussianNoise.switch == "on"
        inpData=awgn(inpData,GaussianNoise.value,'measured');
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
        end
        %Way back for the true predictions
        if Itar(j)~=Ipred(j) && Ipred(j)==Itar0(j)
            targData(:,j)=zeros(ns+1,1);%erase first
            targData(Itar0(j),j)=1;%
            sumDoubts=sumDoubts-1;
        end
    end

    targets=targData;
    classDistribution=sum(targets,2)
    GNV=GNV+10
    
    GNV < GNT
    classDistribution(end)~= max(classDistribution)
end

end

