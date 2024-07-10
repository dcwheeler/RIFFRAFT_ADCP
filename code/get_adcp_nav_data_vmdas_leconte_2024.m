function get_adcp_nav_data_vmdas_leconte_2023(direc,outfile)
%Reads the GPRMC line from an NMEA data stream saved to a text file


files=dir(fullfile(direc,'*','*.N1R'));

disp(['There are ' num2str(length(files)) ' N1R files'])
ndata=[];

lskip=0;
for ig=1:length(files)
    file=fullfile(files(ig).folder,files(ig).name);
    disp(file)
    fid=fopen(file,'r');

    while ~feof(fid)


        ln=fgetl(fid);
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

    fclose(fid);

end

ndata(:,1)=ndata(:,1)+2000;
ndata=unique(ndata,'rows');


lon=-(ndata(:,7)+ndata(:,8)/60);
lat=ndata(:,9)+ndata(:,10)/60;
bspd=ndata(:,11);
bdir=ndata(:,12);
time=datenum(ndata(:,1:6));

save(outfile,'lon','lat','time','bspd','bdir')
