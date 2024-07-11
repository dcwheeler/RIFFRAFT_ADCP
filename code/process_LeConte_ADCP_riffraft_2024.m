function    process_LeConte_ADCP_riffraft_2024(deployment,topdir,topdir_proc)
%Convert and process adcp data from the RiffRaft deployments in LeConte Bay
%in 2023.
% Steps:
%1) Convert GPS NMEA data
%2) Convert raw VMDAS outputn files to matlab format.
%3) Basic quality control and process ADCP velocities to CUrrent
%velocities.


disp(['Processing deployment: ' deployment])
%topdir= 'C:\work\LeConte\Data\LeConte_2023';
rawdir= fullfile(topdir,'raw/RiffRaft',deployment,'ADCP');
%topdir_proc= 'C:\work\LeConte\Data\LeConte_2023';
procdir= fullfile(topdir_proc,'processed/RiffRaft',deployment,'ADCP');



GPSflag=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GPS processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if GPSflag
    disp('Processing GPS files')
    gpsoutfile=fullfile(topdir,'processed/RiffRaft',deployment,'gps',[deployment '_gps']);
    get_adcp_nav_data_vmdas_leconte_2024(rawdir,gpsoutfile)

    gdata=load(gpsoutfile);

    figure(1)
    LeConte_map
    hold on
    plot(gdata.lon,gdata.lat,'.r-')
    hold off
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Convert VMDAS PD0 files to *.mat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

enrfiles=dir(fullfile(rawdir,'*','*.ENR'));


disp('##############################')
disp('Converting ENX,ENS,ENX FILES')
for ifi=1:length(enrfiles)
    disp('-------')
    enrfile=fullfile(enrfiles(ifi).folder,enrfiles(ifi).name);
    ensfile=strrep(enrfile,'ENR','ENS');
    enxfile=strrep(enrfile,'ENR','ENX');
    disp(enrfile)
    disp(ensfile)
    disp(enxfile)
    oenrfile=strrep(enrfile,'.ENR','enr.mat');
    oensfile=strrep(ensfile,'.ENS','ens.mat');
    oenxfile=strrep(enxfile,'.ENX','enx.mat');


    if exist(oenrfile)
        disp([oenrfile ' exists'])
    else
        if exist(enrfile)
            read_ADCP_PD0_vmdas(enrfile,oenrfile)
        end
    end

    if exist(oensfile)
        disp([oensfile ' exists'])
    else

        if exist(ensfile)
            read_ADCP_PD0_vmdas(ensfile,oensfile)
        end
    end
    if exist(oenxfile)
        disp([oenxfile ' exists'])
    else
        if exist(enxfile)
            read_ADCP_PD0_vmdas(enxfile,oenxfile)
        end
    end

end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Process ENX files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('##############################')
disp('PROCESSING ENX FILES')
enxfiles=dir(fullfile(rawdir,'*','*enx.mat'));

for ifi=1:length(enxfiles)
    disp('----------')
    enxfile=fullfile(enxfiles(ifi).folder,enxfiles(ifi).name);
    if contains(enxfile,'_150_')
        enxofile=fullfile(topdir,'processed/RiffRaft',deployment,'ADCP',[enxfiles(ifi).name(1:end-4) '_proc']);
        disp(enxfile)
        disp(enxofile)
      %  process_ADCP_data_LECONTE_150(enxfile,enxofile)
       process_ADCP_data_LECONTE(enxfile,enxofile,2.5)
    end

    if contains(enxfile,'_600_')
        enxofile=fullfile(topdir,'processed/RiffRaft',deployment,'ADCP',[enxfiles(ifi).name(1:end-4) '_proc']);
        disp(enxfile)
        disp(enxofile)
    %   process_ADCP_data_LECONTE_600(enxfile,enxofile)
       process_ADCP_data_LECONTE(enxfile,enxofile,-6.5)
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plot processed files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('##############################')
disp('Plotting ENX FILES')
enxfiles=dir(fullfile(procdir,'*.mat'));

for ifi=1:length(enxfiles)
    disp('----------')
    enxfile=fullfile(enxfiles(ifi).folder,enxfiles(ifi).name);
    disp(['plotting: ' enxfile])
    plot_ADCP_data_LECONT(enxfile,true) %plot smoothed data
    plot_ADCP_data_LECONT(enxfile,false) %plot raw data
    
    pause(0.1)

end

