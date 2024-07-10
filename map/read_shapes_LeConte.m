    
%direc='C:\work\GEODATA\gshhg-shp-2.3.7\GSHHS_shp\'

direc = '/Users/dwheel03/Desktop/GitHub/Tufts_Code/RIFFRAFT_ADCP/map/Alaska_Coast_63360_ln/';
%direc='C:\work\LeConte\map\Alaska_Coast_63360_ln\';

bbox=[  [-132.7 -132.3];[56.7 56.9]];
% [lat,lon] = projinv(proj,x,y)
% bbox=[  [31 47];[-82 -60]]
% sinfo=shapeinfo([direc 'Alaska_Coast_63360_ln.shp']);
% pcrs=sinfo.CoordinateReferenceSystem;
%  
% [x,y] = projfwd(pcrs,[56.7 56.9],[-132.7 -132.3]);
% bbox=[  [x];[y]];

s1=shaperead([direc 'Alaska_Coast.shp'],'BoundingBox',bbox');
%s2=shaperead([direc 'f/GSHHS_f_L5.shp'],'BoundingBox',bbox');

s=[s1];
col=[0.7 0.7 0.7];



%     patchm(ty,tx,col)
%     

for i=1:length(s)
    X=s(i).X;
    
    Y=s(i).Y;
    Y(isnan(X))=[];
    X(isnan(X))=[];
    if i>1
        hold on
    else
        
        %        Y=[-90 Y -90];
        %        X=[-180 X 180];
    end
    plot(X,Y,'k')
    
end

hold off

% 
% 
% bbox=[  [150 220];[-90 -40]]
% s1=shaperead([direc 'l/GSHHS_l_L1.shp'],'BoundingBox',bbox');
% s3=shaperead([direc 'l/GSHHS_l_L6.shp'],'BoundingBox',bbox');
% 
% 
% bbox=[  [-180 -150];[-90 -40]]
% s4=shaperead([direc 'l/GSHHS_l_L1.shp'],'BoundingBox',bbox');
% s6=shaperead([direc 'l/GSHHS_l_L6.shp'],'BoundingBox',bbox');
% 
% 
% s=[s1; s3;s4; s6];
% col=[0.4 0.4 0.4];
% 
% for i=1:length(s)
%     X=s(i).X;
%     
%     Y=s(i).Y;
%     Y(isnan(X))=[];
%     X(isnan(X))=[];
%     if i>1
%         hold on
%     else
%         
%         %        Y=[-90 Y -90];
%         %        X=[-180 X 180];
%     end
%     patchm(Y,X,col)
% end
% 
% 
% 
% 
% 
% 
% 
% hold off