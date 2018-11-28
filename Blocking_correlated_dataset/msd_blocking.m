

clear;
clc;
close all;

tic

fid = fopen('G:\Adam\Research\Optical_Tweezers\Lausanne_2014jan_feb\Adam\Measurements\xyz_data\01_H2O_Si_1.01um_ND1_1MHz.txt');
A=(fread(fid,[3,1e6],'bit16'))';
fclose(fid);
toc
%}

profile on
tic

x = A(:,1);
Ncalc =size(x,1);

Nb=15; % #of blocking transformations
sigma2MSD=zeros(1,Nb);
dsigma2MSD=zeros(1,Nb);
MSD=zeros(1,Nb);

n=10; %Points in MSD curve
dMSDt=zeros(1,n);
MSDt=zeros(1,n);
t=logspace(0,5,n); %logarithmic time scale for MSD(t)


for n=1:length(t) %stepping t for MSD(t)
    disp(['Calculating point ' num2str(n) ' out of ' num2str(length(t))])    
    Ncalc =size(x,1);
    y2 =(x(1:Ncalc-floor(t(n)))-x(floor(t(n))+1:end)).^2; %square of lagged difference for t(us)
    Ncalc =size(y2,1); %datapoints in lagged differencial timetrace (N-t)

    for i=1:15 %Blocking method
    
        MSD(i)=mean(y2);
        c0=1/Ncalc*sum((y2-MSD(i)).^2);
        sigma2MSD(i)=1/(Ncalc-1)*c0;
        dsigma2MSD(i)=(2/(Ncalc-1))*sigma2MSD(i);
    
        y2=(y2(2:2:size(y2,1))+y2(1:2:size(y2,1)-1))/2; %blocking iteration
        Ncalc =size(y2,1); %reduced size (n'=n/2)
    end

    figure(3)
    semilogy(MSD,'kx')
    hold on
    errorbar(1:1:Nb,MSD,sqrt(sigma2MSD),'kx')
    title(['t=' num2str(t(n)) ' us'])
    xlabel('# of transformation')
    ylabel('MSD')
    hold off
    

    figure(2)
    semilogy(sigma2MSD,'kx')
    hold on
    errorbar(1:1:Nb,sigma2MSD,dsigma2MSD,'kx')
    title(['t=' num2str(t(n)) ' us'])
    xlabel('# of transformation')
    ylabel('Sigma^2=c0/n(n-1)')
	hold off
    %saveas(gcf,['t' num2str(t(n)) 'Sigma2.png'])
    %saveas(gcf,['t' num2str(t(n)) 'Sigma2.fig'])

    %[dMSDt(n) ind]=max(sqrt(sigma2MSD));
    dMSDt(n)=sqrt(Findplateau(1:1:Nb,sigma2MSD,floor(t(n))));
    MSDt(n)=MSD(1);
end
toc

profile viewer


figure(1)
loglog(t,MSDt,'kx')
hold on
errorbar(t,MSDt,dMSDt,'kx')
title('Mean Squared Displacement')
xlabel('t(us)')
ylabel('MSD(mV^2)')
hold off




