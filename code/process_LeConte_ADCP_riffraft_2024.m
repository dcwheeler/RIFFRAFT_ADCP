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
rawdir= fullfile(topdir,'\raw\RiffRaft',deployment,'ADCP');
%topdir_proc= 'C:\work\LeConte\Data\LeConte_2023';
procdir= fullfile(topdir_proc,'\processed\RiffRaft',deployment,'ADCP');



GPSflag=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GPS processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if GPSflag
    disp('Processing GPS files')
    gpsoutfile=fullfile(topdir,'\processed\RiffRaft',deployment,'gps',[deployment '_gps']);
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
        enxofile=fullfile(topdir,'\processed\RiffRaft',deployment,'ADCP',[enxfiles(ifi).name(1:end-4) '_proc']);
        disp(enxfile)
        disp(enxofile)
      %  process_ADCP_data_LECONTE_150(enxfile,enxofile)
       process_ADCP_data_LECONTE(enxfile,enxofile,2.5)
    end

    if contains(enxfile,'_600_')
        enxofile=fullfile(topdir,'\processed\RiffRaft',deployment,'ADCP',[enxfiles(ifi).name(1:end-4) '_proc']);
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
enxfiles=dir(fullfile(procdir,'*proc.mat'));

for ifi=1:length(enxfiles)
    disp('----------')
    enxfile=fullfile(enxfiles(ifi).folder,enxfiles(ifi).name);
    disp(['plotting: ' enxfile])
    load(enxfile)
    sc=0.005;

    if contains(enxfile,'_150_')
        figure(1)
        map=rb_cmp;
        colormap(map)
        subplot(3,1,1)
        pcolor(time,-bins,u);
        shading flat
        colorbar
        hold on
        plot(time,-depth)
        hold off
        caxis([-.75 .75])
        title('East/West Velocity')
        set(gca,'ylim',[ -250   0])
        datetick('x','mm/dd HH:MM','keepticks','keeplimits')
        subplot(3,1,2)
        pcolor(time,-bins,v);
        shading flat
        colorbar
        hold on
        plot(time,-depth)
        hold off
        caxis([-.75 .75])
        title('North/South Velocity')
        set(gca,'ylim',[ -250   0])
        datetick('x','mm/dd HH:MM','keepticks','keeplimits')

        subplot(3,1,3)
        pcolor(time,-bins,b);
        shading flat
        colorbar
        hold on
        plot(time,-depth)
        hold off
        title('Acoustic Backscatter')
        set(gca,'ylim',[ -250   0])
        datetick('x','mm/dd HH:MM','keepticks','keeplimits')

        fname=strrep(enxfile,'proc.mat','pc.png')

        set(gcf,'paperposition',[0 0 11 8])
        print(gcf,'-dpng','-r300',fname)
        mu=nanmean(u(1:4,:));
        mv=nanmean(v(1:4,:));
        mu2=nanmean(u(6:8,:));
        mv2=nanmean(v(6:8,:));
        %

        figure(2)
        clf
        LeConte_map
        hold on
        plot(lon,lat,'r-');
        quiver(lon,lat,mu*sc,mv*sc,0,'k')
      %  quiver(lon,lat,mu2*sc,mv2*sc,0,'g')
        hold off

        title('Surface (Black) and Mid depth (Green) Currents')
        set(gca,'xlim',[-132.4069 -132.3354],'ylim',[ 56.8108   56.8466])

        fname=strrep(enxfile,'proc.mat','map.png')
        print(gcf,'-dpng','-r300',fname)
    end

    if contains(enxfile,'_600_')

        figure(1)

        map=rb_cmp;
        colormap(map)
        subplot(3,1,1)
        pcolor(time,-bins,u);
        shading flat
        colorbar
        hold on
        plot(time,-depth)
        hold off
        caxis([-.75 .75])
        title('East/West Velocity')
        datetick('x','mm/dd HH:MM','keepticks','keeplimits')
        subplot(3,1,2)
        pcolor(time,-bins,v);
        shading flat
        colorbar
        hold on
        plot(time,-depth)
        hold off
        caxis([-.75 .75])
        title('North/South Velocity')
        datetick('x','mm/dd HH:MM','keepticks','keeplimits')

        subplot(3,1,3)
        pcolor(time,-bins,b);
        shading flat
        colorbar
        hold on
        plot(time,-depth)
        hold off

        title('Acoustic Backscatter')
        datetick('x','mm/dd HH:MM','keepticks','keeplimits')

        fname=strrep(enxfile,'proc.mat','pc.png')
        set(gcf,'paperposition',[0 0 11 8])
        print(gcf,'-dpng','-r400',fname)

        mu=nanmean(u(6:18,:));
        mv=nanmean(v(6:18,:));
        mu2=nanmean(u(19:29,:));
        mv2=nanmean(v(19:29,:));
        %

        figure(2)
        clf
        LeConte_map
        hold on
        plot(lon,lat,'r-');
        quiver(lon,lat,mu*sc,mv*sc,0,'k')
      %  quiver(lon,lat,mu2*sc,mv2*sc,0,'g')
        hold off

        title('Surface (Black) and Mid depth (Green) Currents')
        set(gca,'xlim',[-132.4069 -132.3354],'ylim',[ 56.8108   56.8466])

        fname=strrep(enxfile,'proc.mat','map.png')
        print(gcf,'-dpng','-r400',fname)
    end

    pause(0.1)

end

