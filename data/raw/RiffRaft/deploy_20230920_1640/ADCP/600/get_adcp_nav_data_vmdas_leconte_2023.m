clear all
addpath C:\work\LeConte\map

direc='./';

files=dir([direc '*.N1R']);
%
% NAV 2022/05/31 12:00:00.233 GPS $GPZDA,120000.00,31,05,2022,00,00*60
% NAV 2022/05/31 12:00:00.433 GPS $GPRMC,120000.00,A,4131.426796,N,07040.338412,W,0.01,329.0,310522,,,D*77
% NAV 2022/05/31 12:00:00.433 GPS $GPVTG,329.0,T,,M,0.01,N,0.02,K,D*03
% NAV 2022/05/31 12:00:00.536 GPS $GPGGA,120000.00,4131.426796,N,07040.338412,W,2,15,0.7,25.300,M,-30.062,M,6.0,0402*4E
% NAV 2022/05/31 12:00:01.232 GPS $GPZDA,120001.00,31,05,2022,00,00*61
% NAV 2022/05/31 12:00:01.432 GPS $GPRMC,120001.00,A,4131.426796,N,07040
% time=[];
% nlon=[];
% nlat=[];
ndata=[];

lskip=0;
for ig=1:length(files)
    file=fullfile(direc,files(ig).name);
    disp(file)
    fid=fopen(file,'r');
    
    while ~feof(fid)
        
        
        ln=fgetl(fid);
%         ln
%         tmp=strsplit(ln,'GPS ');
%         ln=tmp{2};
        if  length(ln)>10 & strcmp(ln(1:6),'$GPRMC')
          

            j=1;
            remd=ln;
            while (any(remd))
                [ch,remd]=strtok(remd,',');
                str{j}=ch;
                j=j+1;
            end
            
            try
                lon=str{6};
                lat=str{4};
                time=str{2};
                date=str{10};
                bspd=str{8};
                bdir=str{9};
                data=[date(5:6) ' ' date(3:4) ' ' date(1:2) ' '  time(1:2) ' ' time(3:4) ' ' time(5:6) ' ' lon(1:3)...
                    ' ' lon(4:end) ' ' lat(1:2) ' ' lat(3:end) ' ' bspd ' ' bdir];
                
                ndata=[ndata;str2num(data)];
                
            catch
                disp(ln)
                disp('bad')
                continue
            end
        end
    end
    
    fclose(fid)
    
end

ndata(:,1)=ndata(:,1)+2000;
lon=-(ndata(:,7)+ndata(:,8)/60);
lat=ndata(:,9)+ndata(:,10)/60;
bspd=ndata(:,11);
bdir=ndata(:,12);
time=datenum(ndata(:,1:6));


save LeConte_nav_deploy_20230920_1640 lon lat time bspd bdir

% 
figure(2)
LeConte_map
hold on
plot(lon,lat,'.r-')
hold off