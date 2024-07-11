function process_ADCP_data_LECONTE(infile,ofile,ang)

clear global
data=load(infile);
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
data.data.VE(Ibad)=nan;
data.data.VN(Ibad)=nan;
data.data.ei1(Ibad)=nan;
data.data.ei2(Ibad)=nan;
data.data.ei3(Ibad)=nan;
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

tdepth=depth;
u=[];
v=[];
b=[];
depth=[];
time=[];
lon=[];
lat=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% variables used for plotting are defined below
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

u=data.data.VE; % easthward flow velocity component
v=data.data.VN; % northward flow velocity component
b=EAA; % time averaged backscattering intensity
time=data.data.time; % time axis
depth=tdepth; % bathymetry (depth of the seafloor or riverband)
lon=data.navdata.llon; % longitude
lat=data.navdata.llat; % latitude
bins=data.bins;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make smoothed velocities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

smoothTime = 60; %seconds

dt = mean(diff(time))*24*60*60; %find sampling rate of adcp
windowSize = floor(smoothTime/dt); %calculate window size, ensuring it is odd
if mod(windowSize,2)==0
    windowSize = windowSize + 1;
end
uAv = movmean(u,windowSize,2,'omitnan'); %do a simple running mean for now
vAv = movmean(v,windowSize,2,'omitnan');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Rotate Velocities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%tbd

navdata=data.navdata;
btdata=data.btdata;
save(ofile,'lat','lon','depth','b','bins','time','u','v','navdata','btdata','uAv','vAv')

