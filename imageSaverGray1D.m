function imageSaverGray1D(inputs,targets,folder,classes,saveSubDir)
%ГЕНЕРАЦИЯ И СОХРАНЕНИЕ ИЗОБРАЖЕНИЙ В ДАТАСЕТ ИЗ КОЛОНОК М-Ц inputs

%Вспомогательные величины
n=size(inputs);
picSize=ones(n(1),1);
cd DataSet %переход в папку датасет
cd(folder)%path to train, val, or test folder
currentClassNo=1;%начальное значение
cd (classes(currentClassNo))%папка для 1 класса

for i=1:n(2)%цикл по номерам столбцов
    [M, I]=max(targets(:,i));%определения класса по м-це меток
    newClassNo=I;
    Im=inputs(:,i);
    %Смена директории (если необходимо) для сохранения 
    if newClassNo~=currentClassNo
        currentClassNo=newClassNo;
        cd (saveSubDir)
        cd(folder)
        cd (classes(currentClassNo))
    end
    imwrite(Im,(['data',num2str(i),'.jpeg']))

end
cd (saveSubDir)%возврат в папку дадасета
end

