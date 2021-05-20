function imageSaverNewer(l,inputs,targets,classes,saveSubDir)
%ГЕНЕРАЦИЯ И СОХРАНЕНИЕ ИЗОБРАЖЕНИЙ В ДАТАСЕТ ИЗ КОЛОНОК М-Ц inputs

%Вспомогательные величины
n=size(inputs);
%picSize=ones(1,2)*ceil(sqrt(n(1)));%размер изобр. >= кв.корня кол-ва измер.
picSize=[l,ceil(n(1)/l)];%размер изобр.
cd DataSet %переход в папку датасета
currentClassNo=1;%начальное значение
ar0=zeros(picSize(1)*picSize(2),1);%заготовка столбца
cd (classes(currentClassNo))%папка для 1 класса

for i=1:n(2)%цикл по номерам столбцов
    [M, I]=max(targets(:,i));%определения класса по м-це меток
    newClassNo=I;
    %Дополнение столбцов матриц нулями
    ar=ar0;
    ar(1:n(1))=inputs(:,i);
    %Формирование изображения
    Im=reshape(ar,picSize);%
    %I = mat2gray(mat,range);
    %imshow(Im)
    %colormap default
    %Смена директории (если необходимо) для сохранения 
    if newClassNo~=currentClassNo
        currentClassNo=newClassNo;
        cd (saveSubDir)
        cd (classes(currentClassNo))
    end
    %saveas(h,(['data',num2str(i)]),'jpg')
    imwrite(Im,(['data',num2str(i),'.jpg']))
    
end
cd (saveSubDir)%возврат в папку дадасета
end

