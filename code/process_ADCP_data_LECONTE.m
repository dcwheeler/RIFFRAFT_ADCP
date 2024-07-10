function process_ADCP_data_LECONTE(infile,ofile,ang)

clear global
data=load(infile)
data=QAQC(data);


degrad=pi/180;
depth=(data.btdata.r1+data.btdata.r2+data.btdata.r3+data.btdata.r4)/400; % calculate the bathymetry


wtmp=data.navdata.utrue+sqrt(-1)*data.navdata.vtrue;
wtmp=wtmp*exp(sqrt(-1)*ang*pi/180);
data.navdata.utrue=real(wtmp);
data.navdata.vtrue=imag(wtmp);

data=correct_boatspeed(data,false,0);

data=QAQC2(data,.75);

depth(isnan(depth))=interp1(data.data.time(isfinite(depth)),depth(isfinite(depth)),data.data.time(isnan(depth)));

[bdepth1 bbin1]=meshgrid(data.btdata.r1/100,data.bins);
[bdepth2 bbin2]=meshgrid(data.btdata.r2/100,data.bins);
[bdepth3 bbin3]=meshgrid(data.btdata.r3/100,data.bins);
[bdepth4 bbin4]=meshgrid(data.btdata.r4/100,data.bins);
bdepth1=bdepth1*0.8;
bdepth2=bdepth2*0.8;
bdepth3=bdepth3*0.8;
bdepth4=bdepth4*0.8;

Ibad=find((bbin1>bdepth1) | (bbin2>bdepth2) | (bbin3>bdepth3) | (bbin4>bdepth4));
data.data.data.VE(Ibad)=nan;
data.data.data.VN(Ibad)=nan;
data.data.data.ei1(Ibad)=nan;
data.data.data.ei2(Ibad)=nan;
data.data.data.ei3(Ibad)=nan;
data.data.data.ei4(Ibad)=nan;


data.data.ei4(Ibad)=nan;


C1=data.data.c1;
C2=data.data.c2;
C3=data.data.c3;
C4=data.data.c4;


EAA1=data.data.ei1;
EAA2=data.data.ei2;
EAA3=data.data.ei3;
EAA4=data.data.ei4;
ttemp=data.data.temperature;
switch data.cfg.freq
    case 75
        SA=0.022;
    case 150
        SA=0.039;
    case 300
        SA=0.062;
    case 600
        SA=0.14;
    case 1200
        SA=0.44;
end
C=repmat(ttemp,data.cfg.nbins,1);
C=127.3./(C+273);
sr=repmat(data.bins',1,length(data.data.time));
xmit=0.35;
R=(sr+(0.5*xmit))/cos(20*pi/180);
nd=2.1;
EAA1=(C.*EAA1)+(20*log10(R))+(2*SA*R)-10*log10(xmit/cos(20*pi/180));
EAA2=(C.*EAA2)+(20*log10(R))+(2*SA*R)-10*log10(xmit/cos(20*pi/180));
EAA3=(C.*EAA3)+(20*log10(R))+(2*SA*R)-10*log10(xmit/cos(20*pi/180));
EAA4=(C.*EAA4)+(20*log10(R))+(2*SA*R)-10*log10(xmit/cos(20*pi/180));
tEAA1=data.data.ei1;
tEAA2=data.data.ei2;
tEAA3=data.data.ei3;
tEAA4=data.data.ei4;
EAA=(EAA1+EAA2+EAA3+EAA4)./4;
EAA(Ibad)=nan;

% 
% figure(31)
% colormap(jet)
% subplot(4,1,1)
% pcolor(data.time,-bins,EAA1);
% shading flat
% colorbar
% hold on
% plot(data.time,-depth)
% hold off
% datetick('x','mm/dd HH:MM','keepticks','keeplimits')
% subplot(4,1,2)
% pcolor(data.time,-bins,EAA2);
% shading flat
% colorbar
% hold on
% plot(data.time,-depth)
% hold off
% datetick('x','mm/dd HH:MM','keepticks','keeplimits')
% subplot(4,1,3)
% pcolor(data.time,-bins,EAA3);
% shading flat
% colorbar
% hold on
% plot(data.time,-depth)
% hold off
% datetick('x','mm/dd HH:MM','keepticks','keeplimits')
% subplot(4,1,4)
% pcolor(data.time,-bins,EAA4);
% shading flat
% colorbar
% hold on
% plot(data.time,-depth)
% hold off
% datetick('x','mm/dd HH:MM','keepticks','keeplimits')
% %
% figure(32)
% colormap(jet)
% subplot(4,1,1)
% pcolor(data.time,-bins,C1);
% shading flat
% colorbar
% hold on
% plot(data.time,-depth)
% hold off
% datetick('x','mm/dd HH:MM','keepticks','keeplimits')
% subplot(4,1,2)
% pcolor(data.time,-bins,C2);
% shading flat
% colorbar
% hold on
% plot(data.time,-depth)
% hold off
% datetick('x','mm/dd HH:MM','keepticks','keeplimits')
% subplot(4,1,3)
% pcolor(data.time,-bins,C3);
% shading flat
% colorbar
% hold on
% plot(data.time,-depth)
% hold off
% datetick('x','mm/dd HH:MM','keepticks','keeplimits')
% subplot(4,1,4)
% pcolor(data.time,-bins,C4);
% shading flat
% colorbar
% hold on
% plot(data.time,-depth)
% hold off
% datetick('x','mm/dd HH:MM','keepticks','keeplimits')

%
% btenu=btenu./1000;
% bttime=data.time;
% adcpheading=data.heading;
%
% save BT_DATA_ADCP_COMPASSCAL bttime btenu adcpheading

tdepth=depth;
u=[];
v=[];
b=[];
depth=[];
time=[];
lon=[];
lat=[];

% % define the time interval for time average
% dt=30/(60*60*24); % 30 sec interval
% itime=min(data.time);
% etime=max(data.time);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% variables used for plotting are defined below
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% endflag=1;
% while endflag
%     It=find(data.time>itime & data.time<=itime+dt);
% 
%     if isempty(It)
%         break
%     end
    % 
    % 
    % 
    % u=[u nanmean(data.VE(:,It),2)]; % easthward flow velocity component
    % v=[v nanmean(data.VN(:,It),2)]; % northward flow velocity component
    % b=[b nanmean(EAA(:,It),2)]; % time averaged backscattering intensity
    % time=[time nanmean(data.time(It))]; % time axis
    % depth=[depth nanmean(tdepth(It))]; % bathymetry (depth of the seafloor or riverband)
    % lon=[lon nanmean(navdata.llon(It))]; % longitude
    % lat=[lat nanmean(navdata.llat(It))]; % latitude

%     if max(It)+1 >= length(data.time)
%         break
%     end
%     itime=data.time(max(It)+1);
% end



u=data.data.VE; % easthward flow velocity component
v=data.data.VN; % northward flow velocity component
b=EAA; % time averaged backscattering intensity
time=data.data.time; % time axis
depth=tdepth; % bathymetry (depth of the seafloor or riverband)
lon=data.navdata.llon; % longitude
lat=data.navdata.llat; % latitude
bins=data.bins;




% Ig=find(isfinite(depth) & depth<29);
% depth=depth(Ig);
% lat=lat(Ig);
% lon=lon(Ig);
% time=time(Ig);
% u=u(:,Ig);
% v=v(:,Ig);
% b=b(:,Ig);
% map=rb_cmp_v2;
% figure(12)
% colormap(map)
% subplot(3,1,1)
% pcolor(time,-bins,u);
% shading flat
% colorbar
% hold on
% plot(time,-depth)
% hold off
% caxis([-1 1])
% datetick('x','mm/dd HH:MM','keepticks','keeplimits')
% subplot(3,1,2)
% pcolor(time,-bins,v);
% shading flat
% colorbar
% hold on
% plot(time,-depth)
% hold off
% caxis([-1 1])
% datetick('x','mm/dd HH:MM','keepticks','keeplimits')

% subplot(3,1,3)
% pcolor(time,-bins,b);
% shading flat
% colorbar
% hold on
% plot(time,-depth)
% hold off
% datetick('x','mm/dd HH:MM','keepticks','keeplimits')
%
% % %
% % % gdata=load('C:\work\delaware_plastic\survey_10_23_2019\Delwareplume_0\DELAWARE_PLASTICS_2019_10_24_adcpgps.mat')
% mu=nanmean(u(1:2,:));
% mv=nanmean(v(1:2,:));
% mu2=nanmean(u(6:8,:));
% mv2=nanmean(v(6:8,:));
% %
% %
%  sc=0.02
% figure(30)
% LeConte_map
% hold on
% plot(gdata.lon,gdata.lat,'r.-',lon,lat,'b.-');
%
%
%
% % plot(tmplon,tmplat,'g-','linewidth',10);
% quiver(lon,lat,mu*sc,mv*sc,0,'k')
% quiver(lon,lat,mu2*sc,mv2*sc,0,'g')
% %plot(tmplon,tmplat,'g+-');
% hold off

navdata=data.navdata;
btdata=data.btdata;
save(ofile,'lat','lon','depth','b','bins','time','u','v','navdata','btdata')

