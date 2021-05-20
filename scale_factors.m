function [maxVals,minVals,deltaVals] = ...
            scale_factors(lingVar,Nexp,Npar,Nmeas,saveDir)
%������������ ������ ���������� � ���������� �������� � ���������� ��������
%   �������� ��� ������������ ������������ ����� �������� ����� ��������.
cd DataSet
maxVals=ones(length(Nmeas),1)*(-1e9);%�������� ����� ��������
minVals=ones(length(Nmeas),1)*1e9;%�������� ������� ��������
for i=1:Nexp*Npar
    load (['saved',num2str(i)])
    switch lingVar
        case "NI"
            buf=([CRRSm;FCout;PPGreen;PPGreenSm;...
                PPOrange;PPOrangeSm;Pressure;pSm]);
            
        case "BK"
            n=size(FFT_micro);
            buf=([reshape(FFT_micro,[1,n(1)*n(2)]);...
                  reshape(FFT_micro,[1,n(1)*n(2)]);...
                  reshape(FFT_vibro1,[1,n(1)*n(2)]);...
                  reshape(FFT_vibro2,[1,n(1)*n(2)]);...
                  reshape(FFT_vibro3,[1,n(1)*n(2)])]);
    end
    buf=buf';
    maxVals=max(max(buf)',maxVals);
    minVals=min(min(buf)',minVals);
end
deltaVals=maxVals-minVals;
cd (saveDir)
end

