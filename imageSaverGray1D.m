function imageSaverGray1D(inputs,targets,folder,classes,saveSubDir)
%��������� � ���������� ����������� � ������� �� ������� �-� inputs

%��������������� ��������
n=size(inputs);
picSize=ones(n(1),1);
cd DataSet %������� � ����� �������
cd(folder)%path to train, val, or test folder
currentClassNo=1;%��������� ��������
cd (classes(currentClassNo))%����� ��� 1 ������

for i=1:n(2)%���� �� ������� ��������
    [M, I]=max(targets(:,i));%����������� ������ �� �-�� �����
    newClassNo=I;
    Im=inputs(:,i);
    %����� ���������� (���� ����������) ��� ���������� 
    if newClassNo~=currentClassNo
        currentClassNo=newClassNo;
        cd (saveSubDir)
        cd(folder)
        cd (classes(currentClassNo))
    end
    imwrite(Im,(['data',num2str(i),'.jpeg']))

end
cd (saveSubDir)%������� � ����� ��������
end

