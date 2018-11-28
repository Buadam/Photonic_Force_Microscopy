%Binning tool
clear all;

n=30; %bin/dec

PathName='J:\suli\bme\PhD\Lausanne_2014jan_feb\Hydrodynamic_Calibration_Software\Hydrodyn_Calib_Notebook\Testdata\Spheroid\Spheroid';
FileName='03_H2O_Poly_0.505um_ND3_1.00MHz_PSD_X.txt';
data=dlmread(fullfile(PathName, FileName),'\t',2,0);

xmin=log10(min(data(:,1)));
xmax=log10(max(data(:,1)));
delta=(xmax-xmin);

x=logspace(xmin,xmax,round(n*delta));
y=zeros(size(x));
dy=zeros(size(x));

for i=1:size(x,2)-1
    bin=data(find(data(:,1)>x(i) & data(:,1)<x(i+1)),2);
    y(i+1)=mean(bin);
    dy(i+1)=std(bin);
end

figure(1)
errorbar(x,abs(y),abs(dy))
set(gca,'XScale','log','YScale','log')

FileName='03_H2O_Poly_0.505um_ND3_1.00MHz_BIN_PSD_X.txt';
dlmwrite(fullfile(PathName,FileName),[x(find(isfinite(y)))' y(find(isfinite(y)))' dy(find(isfinite(y)))'],'delimiter', '\t');
