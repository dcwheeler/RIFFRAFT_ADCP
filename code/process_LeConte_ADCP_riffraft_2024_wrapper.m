clear all


addpath C:\work\LeConte\GIT\RIFFRAFT_ADCP\map\
% topdir= 'C:\work\LeConte\Data\LeConte_2023';
% topdir_proc= 'C:\work\LeConte\Data\LeConte_2023

topdir= 'C:\work\LeConte\GIT\RIFFRAFT_ADCP\data';
topdir_proc= 'C:\work\LeConte\GIT\RIFFRAFT_ADCP\data';
deployment{1}='deploy_20230920_1640';




for idep=1:length(deployment)

    disp('################################################')
    gpsdirec_proc=fullfile(topdir,'\processed\RiffRaft',deployment{idep},'gps');
    if exist(gpsdirec_proc)
        disp([gpsdirec_proc ' exists'])
    else
        disp([gpsdirec_proc ' does not exist'])
        mkdir(gpsdirec_proc)
    end
    adcpdirec_proc=fullfile(topdir,'\processed\RiffRaft',deployment{idep},'adcp');
    if exist(adcpdirec_proc)
        disp([adcpdirec_proc ' exists'])
    else
        disp([adcpdirec_proc ' does not exist'])
        mkdir(adcpdirec_proc)
    end
       process_LeConte_ADCP_riffraft_2024(deployment{idep},topdir,topdir_proc)

end

