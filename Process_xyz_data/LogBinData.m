PathName='J:\suli\bme\PhD\Lausanne_2014jan_feb\Hydrodynamic_Calibration_Software\Spheroid\Spheroid';
FileName='01_H2O_Poly_0.505um_ND1_1.00MHz_PSD_X.txt';
a=dlmread(fullfile(PathName, FileName),'\t',2,0);
time=a(:,1);
data=a(:,2);
bins=210;

spacing=logspace(log10(1),log10(length(time)+1),bins);
[~, binidx] = histc(1:length(time),spacing);
timemeans = accumarray(binidx.', time', [], @mean);

if time(1)==0
    logtime=[0;timemeans(timemeans~=0)];
else
    logtime=timemeans(timemeans~=0);
end

datameans = accumarray(binidx.',data',[],@mean);
logdata = datameans(datameans~=0);
dataerr = accumarray(binidx.',data',[],@std);
logerr=dataerr(datameans~=0);

FileName='02_H2O_Poly_0.505um_ND2_1.00MHz_BIN_VAF_X.txt';
%dlmwrite(fullfile(PathName,FileName),[logtime logdata logerr],'delimiter', '\t');



n=30;
xmin=log10(min(time));
xmax=log10(max(time));
delta=(xmax-xmin);

x=logspace(xmin,xmax,round(n*delta));
y=zeros(size(x));
dy=zeros(size(x));

for i=1:size(x,2)-1
    bin=data(find(a(:,1)>x(i) & a(:,1)<x(i+1)));
    size(bin,1)
    y(i+1)=mean(bin);
    dy(i+1)=std(bin)/sqrt(size(bin,2));
end

figure(1)
errorbar(x,abs(y),abs(dy),'kx')
set(gca,'XScale','log','YScale','log')
hold on
errorbar(logtime,abs(logdata),abs(logerr),'ro')
set(gca,'XScale','log','YScale','log')
hold off

%figure(2)
%loglog(x,-y+(interp1(logtime,logdata,x)),'bx')


figure(2)
plot(log10(x),log10(dy),'ko')


figure(3)
plot(log10(x),log10((dy./y)),'ko')