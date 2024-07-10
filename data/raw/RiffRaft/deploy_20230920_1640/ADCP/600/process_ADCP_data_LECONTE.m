%function process_ADCP_data_v2(infile)
clear all
clf

% infile='C:\work\delaware_stokes\Raw_data_20220815\ADCP\DELTOWO2022_0_004.PD0';
ofile='ADCP_600_RIFFRAFT_LECONTE23_20230920T165402_032_000000.mat'
 nofile=['ADCP_600_RIFFRAFT_LECONTE23_20230920T165402_032_000000_proc'];

clear global
load(ofile)

data.time=data.time+0/24+0/(86400);
knottom=1/1.9438;
gdata=load('C:\work\LeConte\Data\LeConte_2023\raw\RiffRaft\deploy_20230920_1640\ADCP\600\LeConte_nav_deploy_20230920_1640.mat')

bspd=gdata.bspd;
bdir=gdata.bdir;

navu=bspd.*sin(bdir.*pi/180)*knottom;
navv=bspd.*cos(bdir.*pi/180)*knottom;
navt=gdata.time;
navh=bdir;

navspdmg=navdata.spdmg/1000

tmplon=interp1(gdata.time,gdata.lon,data.time);
tmplat=interp1(gdata.time,gdata.lat,data.time);

btdata.v1(btdata.r1==0)=nan;
btdata.v2(btdata.r2==0)=nan;
btdata.v3(btdata.r3==0)=nan;
btdata.v4(btdata.r4==0)=nan;


btdata.r1(btdata.r1==0)=nan;
btdata.r2(btdata.r2==0)=nan;
btdata.r3(btdata.r3==0)=nan;
btdata.r4(btdata.r4==0)=nan;


btdata.v1(btdata.v1<-10000)=nan;
btdata.v2(btdata.v2<-10000)=nan;
btdata.v3(btdata.v3<-10000)=nan;
btdata.v4(btdata.v4<-10000)=nan;

data.u1(data.u1<-10000)=nan;
data.u2(data.u2<-10000)=nan;
data.u3(data.u3<-10000)=nan;
data.u4(data.u4<-10000)=nan;


data.u1(data.u1<-10000)=nan;
data.u2(data.u2<-10000)=nan;
data.u3(data.u3<-10000)=nan;
data.u4(data.u4<-10000)=nan;

data.u1(data.c1<100)=nan;
data.u2(data.c1<100)=nan;
data.u1(data.c2<100)=nan;
data.u2(data.c2<100)=nan;
data.u1(data.c3<100)=nan;
data.u2(data.c3<100)=nan;
data.u1(data.c4<100)=nan;
data.u2(data.c4<100)=nan;

figure(11)
subplot(2,1,1)
plot(data.time,btdata.v1,'b',data.time,btdata.v2,'r')
grid on
subplot(2,1,2)
plot(data.time,data.heading,'k.-')
grid on

magdec=0;
btenu=[];
degrad=pi/180;
depth=(btdata.r1+btdata.r2+btdata.r3+btdata.r4)/400; % calculate the bathymetry

depth(isnan(depth))=interp1(data.time(isfinite(depth)),depth(isfinite(depth)),data.time(isnan(depth)))


wtmp=navdata.utrue+sqrt(-1)*navdata.vtrue
ang=-5;
ang=-5;
wtmp=wtmp*exp(sqrt(-1)*ang*pi/180);
navdata.utrue=real(wtmp);
navdata.vtrue=imag(wtmp);

for i=1:length(data.heading)

%    data.u1(:,i)=data.u1(:,i)-btdata.v1(i); % calculate the flow velocity compoent toward magnetic east
%    data.u2(:,i)=data.u2(:,i)-btdata.v2(i); % calculate the flow velocity compoent toward magnetic north
    data.u1(:,i)=data.u1(:,i)+navdata.utrue(i); % calculate the flow velocity compoent toward magnetic east
    data.u2(:,i)=data.u2(:,i)+navdata.vtrue(i); % calculate the flow velocity compoent toward magnetic north
    btship=[btdata.v1(i) btdata.v2(i)];

    % correction for magnetic declination angle
    % sh=sin(((data.heading(i)+magdec))*degrad); 
    % ch=cos(((data.heading(i)+magdec))*degrad); 
    sh=sin(((magdec))*degrad); 
    ch=cos(((magdec))*degrad); 
    xform=[ch sh;...
        -sh ch];

    btenu(:,i)=btship(1:2)*xform'; % compensate for the magnetic declination angle in ship velocity.
    for j=1:length(bins)
        uvship=[data.u1(j,i) data.u2(j,i)];      
        uvenu=uvship(1:2)*xform'; % compensate for the magnetic declination angle in flow velocity.
        data.VE(j,i)=uvenu(1)/10; % Eastward flow velocity component
        data.VN(j,i)=uvenu(2)/10; % Northward flow velocity component
    end




end
 %btenu=[btdata.v1;btdata.v2];
 %data.VE=data.u1;
 %data.VN=data.u2;
dt=0/86400;
data.time=data.time-dt;

ahead=data.heading;
%ahead=atan2(-btenu(1,:),-btenu(2,:))*180/pi;
ahead(ahead<0)=ahead(ahead<0)+360;

figure(20)
clf
ax(1)=subplot(3,1,1);
plot(data.time,btenu(1,:)/1000,'b',data.time,btenu(2,:)/1000,'r',navt,-navu,'k',navt,-navv,'m')
grid on
datetick('x','mm/dd HH:MM','keepticks','keeplimits')
legend('BT U','BT V','NAV U','NAV V')
title('Ship velocity')
ax(2)=subplot(3,1,2)
plot(data.time,ahead,'k.-',navt,bdir,'r.-')
grid on
datetick('x','mm/dd HH:MM','keepticks','keeplimits')
legend('ADCP heading','NAV Heading')
title('Ship Heading')
ax(3)=subplot(3,1,3)
plot(data.time,navspdmg,'k.-')
grid on
datetick('x','mm/dd HH:MM','keepticks','keeplimits')

title('Nav spd made good')

linkaxes(ax,'x')
% 
% btdata.lon(btdata.lat==0)=nan;
% btdata.lat(btdata.lat==0)=nan;
% btdata.lon=-(360-btdata.lon);
% 
% navdata.lon(navdata.lat==0)=nan;
% navdata.lat(navdata.lat==0)=nan;

% [bdepth bbin]=meshgrid(depth,bins);
% bdepth=bdepth*0.85;
% Ibad=find(bbin>bdepth);

[bdepth bbin]=meshgrid(btdata.r1/100,bins);
bdepth=bdepth*0.9;
Ibad=find(bbin>bdepth);
data.VE(Ibad)=nan;
data.VN(Ibad)=nan;
[bdepth bbin]=meshgrid(btdata.r2/100,bins);
bdepth=bdepth*0.9;
Ibad=find(bbin>bdepth);
data.VE(Ibad)=nan;
data.VN(Ibad)=nan;
[bdepth bbin]=meshgrid(btdata.r3/100,bins);
bdepth=bdepth*0.9;
Ibad=find(bbin>bdepth);
data.VE(Ibad)=nan;
data.VN(Ibad)=nan;
[bdepth bbin]=meshgrid(btdata.r4/100,bins);
bdepth=bdepth*0.9;
Ibad=find(bbin>bdepth);
data.VE(Ibad)=nan;
data.VN(Ibad)=nan;
figure(22)
subplot(2,1,1)
pcolor(data.time,-bins,bdepth);
shading flat
colorbar
hold on
plot(data.time,depth,'k')
hold off
subplot(2,1,2)
pcolor(data.time,-bins,bbin);
shading flat
colorbar
hold on
plot(data.time,depth,'k')
hold off

data.VE(Ibad)=nan;
data.VN(Ibad)=nan;
data.ei1(Ibad)=nan;
data.ei2(Ibad)=nan;
data.ei3(Ibad)=nan;
data.ei4(Ibad)=nan;

data.c1(Ibad)=nan;
data.c2(Ibad)=nan;
data.c3(Ibad)=nan;
data.c4(Ibad)=nan;

C1=data.c1;
C2=data.c2;
C3=data.c3;
C4=data.c4;


EAA1=data.ei1;
EAA2=data.ei2;
EAA3=data.ei3;
EAA4=data.ei4;
ttemp=data.temperature;
switch cfg.freq
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
C=repmat(ttemp,cfg.nbins,1);
C=127.3./(C+273);
sr=repmat(bins',1,length(data.time));
xmit=0.35;
R=(sr+(0.5*xmit))/cos(20*pi/180);
nd=2.1;
EAA1=(C.*EAA1)+(20*log10(R))+(2*SA*R)-10*log10(xmit/cos(20*pi/180));
EAA2=(C.*EAA2)+(20*log10(R))+(2*SA*R)-10*log10(xmit/cos(20*pi/180));
EAA3=(C.*EAA3)+(20*log10(R))+(2*SA*R)-10*log10(xmit/cos(20*pi/180));
EAA4=(C.*EAA4)+(20*log10(R))+(2*SA*R)-10*log10(xmit/cos(20*pi/180));
tEAA1=data.ei1;
tEAA2=data.ei2;
tEAA3=data.ei3;
tEAA4=data.ei4;
I=find(bins<0.85*nd);
EAA1(I,:)=C(I,:).*tEAA1(I,:)+(20*log10(nd))+(2*SA*R(I,:))-10*log10(xmit/cos(20*pi/180));
EAA2(I,:)=C(I,:).*tEAA2(I,:)+(20*log10(nd))+(2*SA*R(I,:))-10*log10(xmit/cos(20*pi/180));
EAA3(I,:)=C(I,:).*tEAA3(I,:)+(20*log10(nd))+(2*SA*R(I,:))-10*log10(xmit/cos(20*pi/180));
EAA4(I,:)=C(I,:).*tEAA4(I,:)+(20*log10(nd))+(2*SA*R(I,:))-10*log10(xmit/cos(20*pi/180));
I=find(bins>=(0.85*nd) & bins<=(2*nd));
EAA1(I,:)=C(I,:).*tEAA1(I,:)+(20*log10(R(I,:)))+(2*SA*R(I,:))-10*log10(xmit/cos(20*pi/180))+(4*log10(3-(R(I,:)./nd)));
EAA2(I,:)=C(I,:).*tEAA2(I,:)+(20*log10(R(I,:)))+(2*SA*R(I,:))-10*log10(xmit/cos(20*pi/180))+(4*log10(3-(R(I,:)./nd)));
EAA3(I,:)=C(I,:).*tEAA3(I,:)+(20*log10(R(I,:)))+(2*SA*R(I,:))-10*log10(xmit/cos(20*pi/180))+(4*log10(3-(R(I,:)./nd)));
EAA4(I,:)=C(I,:).*tEAA4(I,:)+(20*log10(R(I,:)))+(2*SA*R(I,:))-10*log10(xmit/cos(20*pi/180))+(4*log10(3-(R(I,:)./nd)));
EAA=(EAA1+EAA2+EAA3+EAA4)./4;
EAA(Ibad)=nan;


figure(31)
colormap(jet)
subplot(4,1,1)
pcolor(data.time,-bins,EAA1);
shading flat
colorbar
hold on
plot(data.time,-depth)
hold off
datetick('x','mm/dd HH:MM','keepticks','keeplimits')
subplot(4,1,2)
pcolor(data.time,-bins,EAA2);
shading flat
colorbar
hold on
plot(data.time,-depth)
hold off
datetick('x','mm/dd HH:MM','keepticks','keeplimits')
subplot(4,1,3)
pcolor(data.time,-bins,EAA3);
shading flat
colorbar
hold on
plot(data.time,-depth)
hold off
datetick('x','mm/dd HH:MM','keepticks','keeplimits')
subplot(4,1,4)
pcolor(data.time,-bins,EAA4);
shading flat
colorbar
hold on
plot(data.time,-depth)
hold off
datetick('x','mm/dd HH:MM','keepticks','keeplimits')

figure(32)
colormap(jet)
subplot(4,1,1)
pcolor(data.time,-bins,C1);
shading flat
colorbar
hold on
plot(data.time,-depth)
hold off
datetick('x','mm/dd HH:MM','keepticks','keeplimits')
subplot(4,1,2)
pcolor(data.time,-bins,C2);
shading flat
colorbar
hold on
plot(data.time,-depth)
hold off
datetick('x','mm/dd HH:MM','keepticks','keeplimits')
subplot(4,1,3)
pcolor(data.time,-bins,C3);
shading flat
colorbar
hold on
plot(data.time,-depth)
hold off
datetick('x','mm/dd HH:MM','keepticks','keeplimits')
subplot(4,1,4)
pcolor(data.time,-bins,C4);
shading flat
colorbar
hold on
plot(data.time,-depth)
hold off
datetick('x','mm/dd HH:MM','keepticks','keeplimits')


btenu=btenu./1000;
bttime=data.time;
adcpheading=data.heading;

save BT_DATA_ADCP_COMPASSCAL bttime btenu adcpheading

tdepth=depth;
u=[];
v=[];
b=[];
depth=[];
time=[];
lon=[];
lat=[];

% dfine the time interval for time average
dt=10/(60*60*24); % 30 sec interval
itime=min(data.time);
etime=max(data.time);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% variables used for plotting are defined below
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
endflag=1;
while endflag
    It=find(data.time>itime & data.time<=itime+dt); 

    
    
    u=[u nanmean(data.VE(:,It),2)]; % easthward flow velocity component
    v=[v nanmean(data.VN(:,It),2)]; % northward flow velocity component
    b=[b nanmean(EAA(:,It),2)]; % time averaged backscattering intensity
    time=[time nanmean(data.time(It))]; % time axis
    depth=[depth nanmean(tdepth(It))]; % bathymetry (depth of the seafloor or riverband)
    lon=[lon nanmean(navdata.llon(It))]; % longitude
    lat=[lat nanmean(navdata.llat(It))]; % latitude

    if max(It)+1 >= length(data.time) | isempty(It)
    break
    end
    itime=data.time(max(It)+1);
end
% %calculate the magnitude of flow velocity 
% mag=sqrt(u.^2+v.^2);
% 
% %average velocities over transect
% m_u=nanmean(u,2); % time averaged eastward flow velocity component over the entire transect
% m_v=nanmean(v,2); % time averaged northward flow velocity component over the entire transect
% m_mag=nanmean(mag,2); % time averaged velocity magnitude over the entire transect
% 
% % save important variables as a .mat file





u=u/100;
v=v/100;



% Ig=find(isfinite(depth) & depth<29);
% depth=depth(Ig);
% lat=lat(Ig);
% lon=lon(Ig);
% time=time(Ig);
% u=u(:,Ig);
% v=v(:,Ig);
% b=b(:,Ig);
map=rb_cmp_v2;
figure(12)
colormap(map)
subplot(3,1,1)
pcolor(time,-bins,u);
shading flat
colorbar
hold on
plot(time,-depth)
hold off
caxis([-1 1])
datetick('x','mm/dd HH:MM','keepticks','keeplimits')
subplot(3,1,2)
pcolor(time,-bins,v);
shading flat
colorbar
hold on
plot(time,-depth)
hold off
caxis([-1 1])
datetick('x','mm/dd HH:MM','keepticks','keeplimits')

subplot(3,1,3)
pcolor(time,-bins,b);
shading flat
colorbar
hold on
plot(time,-depth)
hold off
datetick('x','mm/dd HH:MM','keepticks','keeplimits')

% % 
% % gdata=load('C:\work\delaware_plastic\survey_10_23_2019\Delwareplume_0\DELAWARE_PLASTICS_2019_10_24_adcpgps.mat')
mu=nanmean(u(1:10,:));
mv=nanmean(v(1:10,:));
mu2=nanmean(u(19:29,:));
mv2=nanmean(v(19:29,:));
% 
 sc=0.02
figure(30)
LeConte_map
hold on
plot(lon,lat,'r.-');

% plot(tmplon,tmplat,'g-','linewidth',10);
quiver(lon,lat,mu*sc,mv*sc,0,'k')
quiver(lon,lat,mu2*sc,mv2*sc,0,'g')
%plot(tmplon,tmplat,'g+-');
hold off


save(nofile,'lat','lon','depth','b','bins','time','u','v')

