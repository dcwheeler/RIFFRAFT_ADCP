function indata=correct_boatspeed(indata,speedflag,magdec)

degrad=pi/180;


for i=1:length(indata.data.heading)
    
    if speedflag
     indata.data.u1(:,i)=indata.data.u1(:,i)-indata.btdata.v1(i); % calculate the flow velocity compoent toward magnetic east
     indata.data.u2(:,i)=indata.data.u2(:,i)-indata.btdata.v2(i); % calculate the flow velocity compoent toward magnetic north
    else
     indata.data.u1(:,i)=indata.data.u1(:,i)+indata.navdata.utrue(i); % calculate the flow velocity compoent toward magnetic east
     indata.data.u2(:,i)=indata.data.u2(:,i)+indata.navdata.vtrue(i); % calculate the flow velocity compoent toward magnetic north
    end
     btship=[indata.btdata.v1(i) indata.btdata.v2(i)];

    % correction for magnetic declination angle
    % sh=sin(((data.heading(i)+magdec))*degrad);
    % ch=cos(((data.heading(i)+magdec))*degrad);
    sh=sin(((magdec))*degrad);
    ch=cos(((magdec))*degrad);
    xform=[ch sh;...
        -sh ch];

    btenu(:,i)=btship(1:2)*xform'; % compensate for the magnetic declination angle in ship velocity.
    for j=1:length(indata.bins)
        uvship=[indata.data.u1(j,i) indata.data.u2(j,i)];
        uvenu=uvship(1:2)*xform'; % compensate for the magnetic declination angle in flow velocity.
        indata.data.VE(j,i)=uvenu(1)/1000; % Eastward flow velocity component
        indata.data.VN(j,i)=uvenu(2)/1000; % Northward flow velocity component
    end


end