clear all


addpath /Users/dwheel03/Desktop/GitHub/Tufts_Code/RiffRaft_ADCP/map 
% addpath C:\work\LeConte\GIT\RIFFRAFT_ADCP\map\
% topdir= 'C:\work\LeConte\Data\LeConte_2023';
% topdir_proc= 'C:\work\LeConte\Data\LeConte_2023

topdir = '/Users/dwheel03/Library/CloudStorage/Box-Box/LeConte202407/data';
topdir_proc = '/Users/dwheel03/Library/CloudStorage/Box-Box/LeConte202407/data';
%topdir = '/Users/dwheel03/Desktop/GitHub/Tufts_Code/RiffRaft_ADCP/data';
%topdir_proc = '/Users/dwheel03/Desktop/GitHub/Tufts_Code/RiffRaft_ADCP/data';
%topdir= 'C:\work\LeConte\GIT\RIFFRAFT_ADCP\data';
%topdir_proc= 'C:\work\LeConte\GIT\RIFFRAFT_ADCP\data';

%deployment={'deploy_20240710_2100','deploy_20240711_1700'};
deployment{1} = 'deploy_20240710_2100';
%deployment{1} = 'deploy_20230920_1640';


for idep=1:length(deployment)

    disp('################################################')
    gpsdirec_proc=fullfile(topdir,'processed/RiffRaft',deployment{idep},'gps');
    if exist(gpsdirec_proc)
        disp([gpsdirec_proc ' exists'])
    else
        disp([gpsdirec_proc ' does not exist'])
        mkdir(gpsdirec_proc)
    end
    adcpdirec_proc=fullfile(topdir,'processed/RiffRaft',deployment{idep},'adcp');
    if exist(adcpdirec_proc)
        disp([adcpdirec_proc ' exists'])
    else
        disp([adcpdirec_proc ' does not exist'])
        mkdir(adcpdirec_proc)
    end


       process_LeConte_ADCP_riffraft_2024(deployment{idep},topdir,topdir_proc)

end

