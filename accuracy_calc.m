function [accuracy,Ipred,Itar]=accuracyCalcPlural(ns,net,inpData,targData,n,nframes)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

s=size(targData);
nfb=n/nframes

%check
if rem(n,nframes)~=0
    error('rem(n,nframes)~=0')
end
    
H = net(inpData);%predictions 
[Mpred,Ipred]=max(H);
[Mtar,Itar]=max(targData);

Ipred=reshape(Ipred,nframes,nfb);
Itar=reshape(Itar,nframes,nfb);

nfbU=nfb;
numTruePred=0;
for j=1:nfb
    
    pred=mode(Ipred(:,j));%outputs the most frequent pred. value in array 
    targ=mode(Itar(:,j));%outputs the most frequent target value in array 
    i=0;%counter
    
    while pred==ns+1 && j+i<n %doubt class or the number of frames is 2 big
        warning('the doubt class has been predicted')
        i=i+1;
        pred=mode(Ipred(:,j+i));%shift the data
        nfbU=nfbU-1;%exclude one frame
    end
      
    if nfbU == j
        break %samples are over
    end
    
    if pred == targ
        numTruePred=numTruePred+1;
    end
end

if size(outp,1)==ns+1%extra class is present
    sumDoubts=sum(Iout==ns+1);
    %targData=[targData;zeros(1,s(2))];%extra class
    accuracy=sum(Iout==Itar)/(s(2)-sumDoubts);
else
    accuracy=sum(Iout==Itar)/s(2);
end

end

