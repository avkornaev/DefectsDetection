function [tbl] = ...
    transformInputs(inputs,targets)
%Function transforms inputs and targets matrices into table

n=size(inputs);
numFeatures=n(1);
[Mtar,Itar]=max(targets);%targets
classID=categorical(Itar');
%numClasses=numel(classID);

% numFeatures=size(tbl{1,1},2);

features=inputs';
classID=categorical(Itar');


%Create table
tbl=table(features(:,1),'VariableNames',{'Feature1'});%the first column
for i=2:numFeatures
    tbl=[tbl table(features(:,i),'VariableNames',{['Feature',num2str(i)]})];
end
 %add targets
tbl=[tbl table(classID,'VariableNames',{'classID'})];

% tbl=table(measurements,classNo);
% %Attributes
% classnames=categories(tbl{:,2});
% numClasses=numel(classnames);
% numFeatures=size(tbl{1,1},2);

% 
% n=size(inputsInit);%number of samples
% tbl=table('Size',[n(1) n(2)+1])
% %Fill the table
% for i=1:n(2)
%     
%     %inputs{i,1}=inputsInit(:,i);
%     %inputs(:,i)=inputsInit(:,i);
%     %targets(i,1)=Itar(i);
%     %categorical(Itar(i))
%     %targets(i,1)=categorical(Itar(i));
% end
% 








% %inputs=cell(n,1);
% inputs=zeros(1600,n);
% %targets=categorical(zeros(n,1));
% targets=zeros(n,1);
% [Mtar,Itar]=max(targetsInit);%targets
% 
% for i=1:n
%     %inputs{i,1}=inputsInit(:,i);
%     %inputs(:,i)=inputsInit(:,i);
%     targets(i,1)=Itar(i);
%     %categorical(Itar(i))
%     %targets(i,1)=categorical(Itar(i));
% end
% 
% inputs=inputsInit;
% 
% tbl=table(inputs', targets(:,1));
%tbl = convertvars(tbl,'targets','categorical');
% mergeTVinputs=[inputsTrain;inputsValidation];
% mergeTVtargets=[targetsTrain;targetsValidation];
% Nm=numel(mergeTVtargets);
% rs=randperm(Nm);
% 
% Ntrain=ceil(Nm*trainRatio);
% 
% %Initialized zero values
% inputsTrain = cell(Ntrain,1);
% targetsTrain=zeros(Ntrain,1);
% inputsValidation=cell(Nm-Ntrain,1);
% targetsValidation=zeros(Nm-Ntrain,1);
% 
% %Fill the sets
% for i=1:Nm
%     if i<=Ntrain
%         inputsTrain{i,1}=mergeTVinputs{rs(i),1};
%         targetsTrain(i,1)=mergeTVtargets(rs(i),1);
%     else
%         inputsValidation{i-Ntrain,1}=mergeTVinputs{rs(i),1};
%         targetsValidation(i-Ntrain,1)=mergeTVtargets(rs(i),1);        
%     end
% end

end

