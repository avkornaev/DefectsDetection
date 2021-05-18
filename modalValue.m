function accuracyMV=modalValue(ns,net,n,nmoda,inpData,targData)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

s=size(targData);
N=s(2)/nmoda;
if rem(n,nmoda)~=0
    error('Number of nmoda ougth to be proportional to the number of samples n')
end

count=0;

trueModals=zeros(N,1);

%outp = net(inpData); 
%[Mout,Iout]=max(outp);
%[Mtar,Itar]=max(targData);


%for i=1:nmoda:n
    
 %   if size(outp,1)==ns+1%extra class is present
        for i=1:nmoda:s(2)
            count=count+1;
            startP=i;%start point
            stopP=i+nmoda-1;%stop poin
            
            %Predictions
            pred=net(inpData(:,startP:stopP));%predictions
            trans=(pred==max(pred(1:ns,:)));%transitional matrix
            transSum=sum(trans,2)%sum for the each row
            [M,I]=max(transSum);%the maximum M and its position I
            mv(count)=I;
            if I==ns+1
                warning("the nmoda prediction is I Don't Know")
            end
            
            %Targets
            targ=targData(:,startP:stopP);%target values
            targSum=sum(targ,2)
            [M,I]=max(targSum);
            
            %True predictions
            if mv(count)==I
                trueModals(count)=1;
            end
        end
accuracyMV=sum(trueModals)/N;        
end
