% LeConte_2016_20m_seafloorbathymetry.nc                                        
% LeConte_2016_4m_seafloorbathymetry.nc                                   
% LeConte_2017_seafloorbathymetry.nc                                                                
% LeConte_2018_seafloorbathymetry.nc  

x= ncread('LeConte_2018_seafloorbathymetry.nc','x');
y= ncread('LeConte_2018_seafloorbathymetry.nc','y');
z1= ncread('LeConte_2018_seafloorbathymetry.nc','z');
[lat1,lon1]=utm2ll(x,y,8,'WGS84');
dims=size(x);
lat1=reshape(lat1,dims(1),dims(2));
lon1=reshape(lon1,dims(1),dims(2));
z1(z1<0)=nan;
% 
% 
% x2= ncread('LeConte_2017_seafloorbathymetry.nc','x');
% y2= ncread('LeConte_2017_seafloorbathymetry.nc','y');
% z2= ncread('LeConte_2017_seafloorbathymetry.nc','z');
% [lat2,lon2]=utm2ll(x2,y2,8,'WGS84');
% dims=size(x2);
% lat2=reshape(lat2,dims(1),dims(2));
% lon2=reshape(lon2,dims(1),dims(2));
% z2(z2<0)=nan;
% 
% x3= ncread('LeConte_2016_4m_seafloorbathymetry.nc','x');
% y3= ncread('LeConte_2016_4m_seafloorbathymetry.nc','y');
% z3= ncread('LeConte_2016_4m_seafloorbathymetry.nc','z');
% [lat3,lon3]=utm2ll(x3,y3,8,'WGS84');
% dims=size(x3);
% lat3=reshape(lat3,dims(1),dims(2));
% lon3=reshape(lon3,dims(1),dims(2));
% z3(z3<0)=nan;
% 
% x4= ncread('LeConte_1999_2000_seafloorbathymetry.nc','x');
% y4= ncread('LeConte_1999_2000_seafloorbathymetry.nc','y');
% z4= ncread('LeConte_1999_2000_seafloorbathymetry.nc','z');
% [lat4,lon4]=utm2ll(x4,y4,8,'WGS84');
% dims=size(x4);
% lat4=reshape(lat4,dims(1),dims(2));
% lon4=reshape(lon4,dims(1),dims(2));
% z4(z4<0)=nan;

%pcolor(lon1,lat1,z1)
% pcolor(lon4,lat4,z4);

hold on

%tdata=shaperead('C:\work\LeConte\Data\LeConte_2023\terminusPosition\leconte_20230913_terminus_wgs84.shp');
% tdata=shaperead('C:\work\LeConte\Data\LeConte_2023\raw\terminusPosition\leconte_20230917_terminus_wgs84.shp');
% kmlwriteline('C:\work\LeConte\Data\LeConte_2023\raw\terminusPosition\leconteterm_20230917.kml',tdata.Y,tdata.X)
% tdata=shaperead('C:\work\LeConte\Data\LeConte_2023\raw\terminusPosition\leconte_20230919_1013_terminus_wgs84.shp');
% kmlwriteline('C:\work\LeConte\Data\LeConte_2023\raw\terminusPosition\leconteterm_20230919.kml',tdata.Y,tdata.X)
% tdata=shaperead('C:\work\LeConte\Data\LeConte_2023\raw\terminusPosition\leconte_20230920_terminus_wgs84.shp');
% kmlwriteline('C:\work\LeConte\Data\LeConte_2023\raw\terminusPosition\leconteterm_20230920.kml',tdata.Y,tdata.X)
% 
% tdata=shaperead('C:\work\LeConte\Data\LeConte_2023\raw\terminusPosition\leconte_20230922_terminus_wgs84.shp');
% kmlwriteline('C:\work\LeConte\Data\LeConte_2023\raw\terminusPosition\leconteterm_20230922.kml',tdata.Y,tdata.X)
tdataNew = load('/Users/dwheel03/Library/CloudStorage/Box-Box/LeConte202407/data/raw/LeconteTermVert07102024.mat');
tdataOld=shaperead('/Users/dwheel03/Desktop/GitHub/Tufts_Code/RIFFRAFT_ADCP/data/raw/terminusPosition/leconte_20230923_terminus_wgs84.shp');
% kmlwriteline('C:\work\LeConte\Data\LeConte_2023\raw\terminusPosition\leconteterm_20230923.kml',tdata.Y,tdata.X)

plot(tdataNew.lon,tdataNew.lat,'r-')
plot(tdataOld.X,tdataOld.Y,'b-')
% ;
% pcolor(lon3,lat3,z3);
%pcolor(lon2,lat2,z2);
read_shapes_LeConte
hold off
shading flat
set(gca,'xlim',[-132.7 -132.3],'ylim',[56.7 56.9]);
set(gca,'dataaspectratio',[1 cos(2*pi*56.8/360) 1])

legend('new terminus','old terminus');