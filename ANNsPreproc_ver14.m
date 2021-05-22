%% ��������� ���������� ������� ��� �������� ���. ��������� ���� � �������
%������ ������������� � ����������� �������, ������ ���-�� �������������. 
%� ���������� ���������� ��������� ����������� ������� "inputs", "targets"
%��� �������� ���, � ����� "inputs_test", "targets_test" ��� ���.������.

clear
clc
tic%������ �������
%% 1.�������� ������ 
%���� 'Plan_exp301119.xls' ������� 6 ������������� �� 5 ������. ������,
%���.���� 'Plan_exp_mar_03_2020.xls' ���.6 ������������� �� 5 ������. ������
%��� �����, ����� ������ � ������� Ntest ������������ ��� �������� ���.
%������������ ��� ������� �����. ���.������������: ����� NI � Bruel&Kjaer

% �������� ����������
cd %'G:\Exp_Defects_Detecting_Competition_mar_2020'
saveDir = cd;

% ��������� ������������ ��������
Nexp=6;%���-�� ����.�� ����� ����.
Npar=10;%���-�� ������������ ������ � ����. ����. �� ����� ����.
Nexcl=3;%���-�� ����������� ������ � ������ ����., ���.��� �����. � ������.
nval=2;ntest=Nexcl-nval;%���-�� ������ ��� �����. � ������. �����.
%[Ntest,Nval]=random_test_numbers(Nexp,Npar,Nexcl)
[Ntest,Nval]=random_test_numbers(Nexp,Npar,ntest,nval);%����.������ ������ ��� ������.
Ntest=[3;17;26;40;44;60];Nval=[5 6; 12 19; 24 29; 33 38; 48 50; 54 57];%specific numbers

% ������
ns=Nexp;%���������� ���������: 2 (�����, ������.) ��� Nexp
normData="useSaved";%������������ ������, "off","calculate","useSaved"
preClustering="off";%pre-clusterization of inputs and inputs_test
data2img ="off";%��������� �������� �� ������ ��������� ���������:
%"off"-����.,%"GrayData"-�� ��, �� �����
imDim="2D";% "1D" or "2D"
%lingVar="train";%�����.����������.�����.,"train","test","NI","BK" 
witchHunt="off";%����.������� � ��������� ������� ("off","manual","auto")
fm=0;%���������� ��� � �������� BK: 0- ����., 1-���.
dNI=0;%����������������� �������� � NI: 0- ����., 1-���.
cutBK=1;%������� ����������� � B&K �� ������� l: 0-����., 1-���.
fr=0;%��� ��� ����������������: 0- ����., 1-���. !!!!!!!!!!�� �������� ����
useAutoencoderedBKOnly="on";%Use autoencodered data by I.Stebakov

% ��������� ��������� ������
alp=0.05; %������� ���������� ��� �������� ������� � ��������� �������
rate1=1e+1;%������� ������ ��������
LF=2^9-1;%����� ����� ��� ���
DR=0;%�������� ������� ��������� [] ��� 0, ���� ���� ����.
 % ��������� ��������� ������ � ����� NI
 l =400;% ���-�� ��������� 1 ������� ��� 1 ��������� �������
 n =1200;% ���-�� ��������� ������� �� 1 �����
 % ��������� ��������� ������ � Bruel&Kjaer
 %ld - ���-�� ��������� 1 ������� ��� 1 ��������� ������� �����������
 %��������� � ����� ������ 
 SGFiltOrder=3;%������� ������� ���������-�����
 CadrLeng=9;%����� �����

% ��������� ��������� ����������� ���������� (��������)
X1minv=550; X1maxv=850;
X2minv=900; X2maxv=1200;
leng1v=143.6; leng2v=143.6;
%������������ ���������� ��������
npic=9;%���-�� �����������

%����� ����� ��������� ��� ��������: 
%NI chasis
%CRRSm - ����������� ��. ������������� ���������� ���� �����, � (1);
%FCout - �������� �� ������ �� ���������� �������.����������, � (2);
%PPGreen - ���������������� �����., ��� (3);
%PPGreenSm - ���������������� �����. ����������, ��� (4);
%PPOrange- ���������������� ����., ��� (5);
%PPOrangeSm- ���������������� ����. ����������, ��� (6);
%Pressure - ��������, ��� (7);
%pSm - �������� ����������, ��� (8);
Nmeas=[0 0 0 0 0 0 0 0];%0 - ��������� ����., 1- ��������� ���.

%Bruel&Kjaer
%FFTMicro - (1);
%CPBMicro - (2);
%FFTVibro1- (3);
%FFTVibro2- (4);
%FFTVibro3- (5);
NmeasBruel=[1 0 1 0 0];%0 - ��������� ����., 1- ��������� ���.
%NmeasBruel=[1 0 0 0 0]

%% 2. �������� ��������� ��������
check_settings(normData,data2img,nval,Nexcl)
if useAutoencoderedBKOnly == "on"
    Nmeas=[0 0 0 0 0 0 0 0];
    NmeasBruel=[1 0 1 1 1];
end
   
%% 3. ���������� ������������ ������, ���� �. ����������
%����� �. ��� ����� �����.� ����.�� 0 �� 1 
    
MinVals=zeros(length(Nmeas),1);MinValsBruel=zeros(length(NmeasBruel),1);
DeltaVals=MinVals+1;DeltaValsBruel=MinValsBruel+1;%������� ��� �.
switch normData
    case "calculate"
        if sum(Nmeas)>0 %�������� ������� ������������� ������ � NI
            [MaxVals,MinVals,DeltaVals]=...
                scale_factors("NI",Nexp,Npar,Nmeas,saveDir);
        end
        if sum(NmeasBruel)>0 %�������� ������� ������������� ������ � ��
            [MaxValsBruel,MinValsBruel,DeltaValsBruel]=...
                scale_factors("BK",Nexp,Npar,NmeasBruel,saveDir);
        end
    case "useSaved"
        MinVals=[0.016828791205853;0.013187689000000;4.289881004362182e+02;7.391443350568824e+02;2.498822770843990e+02;4.259113744973018e+02;-0.139759697690399;0.333950503116824];
        MinValsBruel=[-3.451290000000000;-3.451290000000000;-1.608340000000000e+02;-1.568270000000000e+02;-1.516540000000000e+02];
        DeltaVals=[1.316440528906987;0.270102371000000;1.003993519134704e+03;5.695451327544964e+02;1.113321885264418e+03;5.554771180049149e+02;2.598506219533248;0.206796662541645];
        DeltaValsBruel=[1.058642900000000e+02;1.058642900000000e+02;98.155100000000000;92.382500000000000;94.649800000000000];
end

%% 4. �������� ����� ��� �����������, ���� ����������
cd DataSet
saveSubDir=cd;
folders=["train","val","test"];
if data2img =="ColorData" || ...
        data2img =="GrayData" %��.���.�����.�����. ������ ���������
    %�������� ����� �� �������
    classes=["N1Normal", "N2BedBolt2", "N3BedBolts2and3",...
        "N4MotorScrew2","N5HighImbalance", "N6BedBolt2andMotorScrew2"];
for i=1:length(folders)
    mkdir (folders(i))
    cd (folders(i))
    for k=1:Nexp %��������� ����� ��� �������� � ������������ � ��������
        mkdir (classes(k))%��������
    end
    cd (saveSubDir)
end    
%     classes_val=["valN1Normal", "valN2BedBolt2", "valN3BedBolts2and3",...
%         "valN4MotorScrew2","valN5HighImbalance", "valN6BedBolt2andMotorScrew2"];
%     classes_test=["testN1Normal", "testN2BedBolt2", "testN3BedBolts2and3",...
%         "testN4MotorScrew2","testN5HighImbalance", "testN6BedBolt2andMotorScrew2"];
% for k=1:Nexp %��������� ����� ��� �������� � ������������ � ��������
%         mkdir (classes(k))%��������
%         mkdir (classes_val(k))% ���������
%         mkdir (classes_test(k))%������������
% end
end
cd (saveDir)
%% 5. �������� ������� � ��������� �������, ���� ����������
Ndef=0;%��������� ������� � �������� ��������� ������, ������� ������� ������
switch witchHunt
    case "off"
    case "manual"
        [Z_p,Z_kr,X,Ndef]=witch_hunting(Nmeas,NmeasBruel,Nexp,Npar,...
            l,MinVals,DeltaVals,MinValsBruel,DeltaValsBruel,alp,saveDir);
        prompt = 'Enter the numbers of the defective tests using matrix format [1 2 3], or just push Enter ';
        %Ndef = input(prompt)
        Ndef %actual numbers of suspicious tests
        Ndef=[24];%assumed numbers of ...
        NoOfDefectiveTests=length(Ndef)
    case "auto"
        [Z_p,Z_kr,X,Ndef]=witch_hunting(Nmeas,NmeasBruel,Nexp,Npar,...
            l,MinVals,DeltaVals,MinValsBruel,DeltaValsBruel,alp,saveDir);
        Ndef=Ndef
        NoOfDefectiveTests=length(Ndef)
end

%% 6. �������� ������ ������������. NI chasis
[inputs,targets,inputs_test,targets_test,inputs_val,targets_val]=...
    dataSetNI(Nexp,Npar,Nexcl,Ntest,Nval,Ndef,n,l,Nmeas,ns,fr,DR,...
    MinVals,DeltaVals,saveDir);
if dNI==1
    inputs=diff(inputs);
    inputs_test=diff(inputs_test);
    inputs_val=diff(inputs_val);
end
%% 7. �������� ������ ������������. Bruel&Kjaer
if sum(NmeasBruel)~=0
    [inputsBruel,inputs_testBruel,inputs_valBruel]=...
        dataSetBK(Nexp,Npar,Nexcl,Ntest,Nval,Ndef,n,l,NmeasBruel,fm,...
        cutBK,MinValsBruel,DeltaValsBruel,saveDir,useAutoencoderedBKOnly);
    % ����������� ������
    inputs=[inputs;inputsBruel];    
    inputs_test=[inputs_test;inputs_testBruel];
    inputs_val=[inputs_val;inputs_valBruel];
end
inputsBruel=[];inputs_testBruel=[];inputs_valBruel=[];

%% 8. ���������� ����� ������ �� �-� inputs_test,targets_test ��� ���������
% The section is obsolet

% [inputs_test,targets_test,inputs_val,targets_val] =...
%     val_set_extraction(inputs_test,targets_test,nval,n);
%% 8 1/2. Preclustering
if preClustering=="on"
[preclustInfo]=preclustering(inputs,targets);%separates coulumns into 2 clusters of relativelly normal and abnormal data  
[clustInfo]=clustering(inputs,targets);%separates coulumns into 2 clusters of normal and defected
end
%% 9. ������������� ������ � ���� �����������, ���� ����������
switch data2img
%     case "ColorData"
%         cd(saveDir)
%         imageSaver(inputs,targets,classes,saveSubDir)
%         cd(saveDir)
%         imageSaver(inputs_val,targets_val,classes_val,saveSubDir)
%         cd (saveDir)
%         imageSaver(inputs_test,targets_test,classes_test,saveSubDir)
%         cd (saveDir)
    case "GrayData"
        cd(saveDir)
        imageSaverGray1D(inputs,targets,folders(1),classes,saveSubDir)
        cd(saveDir)
        imageSaverGray1D(inputs_val,targets_val,folders(2),classes,saveSubDir)
        cd (saveDir)
        imageSaverGray1D(inputs_test,targets_test,folders(3),classes,saveSubDir)
        cd (saveDir)
end
simulationTime=toc

%% 10. ���������� ������ inputs,targets � ��. ��� ������������ ��������
clearvars alp CadrLeng cutBK data2img DeltaVals DeltaValsBruel dNI DR ...
 fm fr inputs_testBruel inputsBruel leng1v leng2v LF MinVals ...
 MinValsBruel Ndef Nexcl normData Npar ntest ...
 nval rate1 saveDir saveSubDir SGFiltOrder simulationTime ...
 witchHunt X1maxv X1minv X2maxv X2minv
save dataSet

%% 11. �������������� ������������ ���������� ��������
%������������
if sum(Nmeas) == 0 && sum(NmeasBruel) == 2
    npic=9;
    %size(targets,2)
    idx = randperm(size(targets,2),npic);
    figure ('Color','w')
    for i = 1:npic
        subplot(sqrt(npic),sqrt(npic),i)
        semilogy(inputs(:,idx(i)))
        text(0, 0.9, 'Mic.')
        text(400, 0.9, 'Vibroacc.')
        [M,I]=max(targets(:,idx(i)));
        label = [num2str(i),'. Class ',num2str(I)];
        title(string(label));
        %axis ([1 (size(inputs(:,1),1)-2) 0 1])
        grid on
    end
end