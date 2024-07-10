function indata=QAQC(indata)
indata.btdata.v1(indata.btdata.r1==0)=nan;
indata.btdata.v2(indata.btdata.r2==0)=nan;
indata.btdata.v3(indata.btdata.r3==0)=nan;
indata.btdata.v4(indata.btdata.r4==0)=nan;
indata.btdata.r1(indata.btdata.r1==0)=nan;
indata.btdata.r2(indata.btdata.r2==0)=nan;
indata.btdata.r3(indata.btdata.r3==0)=nan;
indata.btdata.r4(indata.btdata.r4==0)=nan;
indata.btdata.v1(indata.btdata.v1<-10000)=nan;
indata.btdata.v2(indata.btdata.v2<-10000)=nan;
indata.btdata.v3(indata.btdata.v3<-10000)=nan;
indata.btdata.v4(indata.btdata.v4<-10000)=nan;
indata.data.u1(indata.data.u1<-10000)=nan;
indata.data.u2(indata.data.u2<-10000)=nan;
indata.data.u3(indata.data.u3<-10000)=nan;
indata.data.u4(indata.data.u4<-10000)=nan;
indata.data.u1(indata.data.c1<100)=nan;
indata.data.u2(indata.data.c1<100)=nan;
indata.data.u1(indata.data.c2<100)=nan;
indata.data.u2(indata.data.c2<100)=nan;
indata.data.u1(indata.data.c3<100)=nan;
indata.data.u2(indata.data.c3<100)=nan;
indata.data.u1(indata.data.c4<100)=nan;
indata.data.u2(indata.data.c4<100)=nan;

Ibad=find(indata.navdata.spd>1500)
indata.data.u1(:,Ibad)=nan;
indata.data.u2(:,Ibad)=nan

end