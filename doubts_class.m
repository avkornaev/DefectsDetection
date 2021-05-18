function [targets,Mpred,Ipred,Mtar,Itar,H,classDistribution]=...
    doubts_class(ns,net,inpData,targData,targets0)
%SUBPROGRAM generates or updates the extra "I Don't know" class 

sumDoubts=0;
%Sizes
si=size(inpData);
st=size(targData);

%Add an extra row for the extra class if it is absent
if st(1)==ns
    targData=[targData;zeros(1,st(2))];%ns+1 raw is for "IDK"
end

%Predictions
H = net(inpData);
[Mpred,Ipred]=max(H);%predictions
[Mtar,Itar]=max(targData);%targets
[Mtar0,Itar0]=max(targets0);%targets

for j=1:st(2)
    %Way into the "IDK" class
    if Itar(j)~=Ipred(j) && Ipred(j)~=ns+1
        targData(:,j)=zeros(ns+1,1);%erase first
        targData(ns+1,j)=1;%
        sumDoubts=sumDoubts+1;
    end
    %Way back for the true predictions
    
    %%%%%%Enter your code here%%%%%%%%
    %Hint: return true label if prediction is true
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

targets=targData;
classDistribution=sum(targets');






% if st(1)==ns%check that it wasn't done before
%     %Empty marix
%     inpP=zeros(si(1),1);
%     
%     %Predicted and target values
%     outp = net(inpData); 
%     [Mout,Iout]=max(outp);%predictions
%     [Mtar,Itar]=max(targData);%targets
% ns
%     %Doubt class extraction
%     count=0;
%     for j=1:st(2)
%         count=count+1;
%         if Iout(count)~=Itar(count)
%             %[Iout(count) Itar(count)]
%             %new class recording
%             inpP = [inpP inpData(:,count)];
%             %targP=[targP zeros(st(1)+1,1)];%empty so far
%             %data marker
%             inpData(:,count)=[];
%             targData(:,count)=[];
%             Iout(count)=[];
%             Itar(count)=[];
%             count=count-1;%roll back
%             %size(inpData)
%         end
%     end
%     %Cut the head    
%     inpP(:,1)=[];
%     %Fill the targP
%     targP=zeros(st(1)+1,size(inpP,2));
%     targP(st(1)+1,:)=1;
%     %Newer inputs and targets formulation
%     if size(targP,2)~=0
%         st=size(targData);%newer (cutted) size
%         inputs =[inpData inpP];
%         targets=[targData;zeros(1,st(2))];%new row of zeros for the doubts class
%         targets=[targets targP];
%     else
%         inputs=inpData;
%         targets=[targData;zeros(1,size(targData,2))];
%     end
%     
% else
%     inputs=inpData;
%     targets=targData;
% end
end

