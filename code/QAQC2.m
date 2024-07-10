function indata=QAQC2(indata,cut)


indata.data.VE(abs(indata.data.VE)>cut)=nan;
indata.data.VE(abs(indata.data.VN)>cut)=nan;
indata.data.VN(abs(indata.data.VE)>cut)=nan;
indata.data.VN(abs(indata.data.VN)>cut)=nan;

end