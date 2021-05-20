function check_settings(normData,data2img,nval,Nexcl)
%ПРОВЕРКА НАСТРОЕК

%Генерация изображений из м-ц inputs требует нормализации данных 
if normData=="off" && (data2img=="GrayData" || data2img=="ColorData")
    error ('Wrong settings. Turn on normData switch if data2img=="GrayData" or data2img=="ColorData"')
end
%Всякое
if nval>=Nexcl && Nexcl>0
    error ('Wrong settings. The nval should be less than Nexcl')
end
end

