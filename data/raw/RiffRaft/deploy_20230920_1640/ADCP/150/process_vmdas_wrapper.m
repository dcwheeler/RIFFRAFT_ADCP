direc='C:\work\LeConte\Data\LeConte_2023\deploy_20230920_1640\ADCP\150\';
files=dir([direc '*.EN*']);


for ifi=1:length(files)
    file=fullfile(direc,files(ifi).name);
    disp(file)
    read_ADCP_PD0_vmdas(file,file(1:end-4));

end
