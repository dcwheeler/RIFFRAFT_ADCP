function [] = plot_ADCP_data_LECONT(enxfile,smooth)
clear global

if smooth
    load(enxfile,'time','uAv','bins','depth','vAv','b','lon','lat')
    u = uAv;
    v = vAv;
else
    load(enxfile,'time','u','bins','depth','v','b','lon','lat')
end
sc=0.005;

figure(1)
map=load('cmapVel.mat').cmapVel;
colormap(map)
subplot(3,1,1)
pcolor(time,-bins,u);
shading flat
colorbar
hold on
plot(time,-depth)
hold off
clim([-.75 .75])
if smooth
    title('Smoothed East/West Velocity')
else
    title('East/West Velocity')
end
set(gca,'ylim',[ -250   0])
datetick('x','mm/dd HH:MM','keepticks','keeplimits')

subplot(3,1,2)
pcolor(time,-bins,v);
shading flat
colorbar
hold on
plot(time,-depth)
hold off
clim([-.75 .75])
if smooth
    title('Smoothed North/South Velocity')
else
    title('North/South Velocity')
end
set(gca,'ylim',[ -250   0])
datetick('x','mm/dd HH:MM','keepticks','keeplimits')

ax3 = subplot(3,1,3);
pcolor(time,-bins,b);
shading flat
colormap(ax3,cmocean('amp'))
colorbar
hold on
plot(time,-depth)
hold off
title('Acoustic Backscatter')
set(gca,'ylim',[ -250   0])
datetick('x','mm/dd HH:MM','keepticks','keeplimits')

if smooth
    fname = replace(enxfile,'proc.mat','pc_smoothed.png');
else
    fname = replace(enxfile,'proc.mat','pc.png');
end

set(gcf,'paperposition',[0 0 11 8])
print(gcf,'-dpng','-r300',fname)
mu=mean(u(1:4,:),'omitnan');
mv=mean(v(1:4,:),'omitnan');
%mu2=mean(u(6:8,:),'omitnan');
%mv2=mean(v(6:8,:),'omitnan');
%

figure(2)
clf
LeConte_map
hold on
plot(lon,lat,'r--','DisplayName','RiffRaft path');
quiver(lon,lat,mu*sc,mv*sc,0,'k','DisplayName','surface velocities')
%quiver(lon,lat,mu2*sc,mv2*sc,0,'g','DisplayName','mid depth velocities')
hold off

if smooth
    title('Map With Smoothed Currents')
else
    title('Map With Raw Currents')
end

set(gca,'xlim',[-132.4069 -132.3354],'ylim',[ 56.8108   56.8466])

if smooth
    fname = replace(enxfile,'proc.mat','map_smoothed.png');
else
    fname = replace(enxfile,'proc.mat','map.png');
end

print(gcf,'-dpng','-r300',fname)

end

