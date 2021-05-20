%%
inputsSVD = inputs';
targetsSVD0 = targets';
targetsSVD = zeros(size(inputsSVD,1),1);
for i =1:size(targetsSVD0,1)
    for j = 1:Nexp
        if targetsSVD0(i,j) == 1
            targetsSVD(i) = j;
        end
    end
end

[U,S,V] = svd(inputsSVD,'econ');
figure; hold on 

for i=1:size(inputsSVD,1)
    x = V(:,1)'*inputsSVD(i,:)';
    y = V(:,2)'*inputsSVD(i,:)';
    z = V(:,3)'*inputsSVD(i,:)';
    
    t0 = targetsSVD(i);
    
    switch (t0)
        case 1 %����� 1, ��������� �������
            plot3(x,y,z,'rx','LineWidth',2); 
        case 2 %����� 2, ��������� �����
            plot3(x,y,z,'bo','LineWidth',2);
        case 3 % ����� 3, ��������� �������
            plot3(x,y,z,'c>','LineWidth',2);
        case 4 %����� 4, ��������� ������
            plot3(x,y,z,'yd','LineWidth',2);
        case 5 %����� 5, ��������� ���������
            plot3(x,y,z,'mv','LineWidth',2);
        otherwise %����� 6, ��������� �������
            plot3(x,y,z,'g+','LineWidth',2);
    end
   
end
view(85,25), grid on
xlabel('PC1'), ylabel('PC2'), zlabel('PC3')