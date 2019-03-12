% Calibration of the optical tweezers setup 
% via the Velocity-Autocorrelation.
function calculateCalibration(a,T,rho,msd,vaf,psd)

%Time values where to do the fittings are tfit1 and tfit2. 
%The first is defined by default, the second is calculated along 
%the plateau of the MSD 
tfit1=5e-6;

%%%%%%%%%%%%%%%%%%%%%%%%
%READ AND PREPARE DATA
%%%%%%%%%%%%%%%%%%%%%%%%

%Densities
%Particle
rhop = rho(1);
%fluid
rhof = rho(2);

%MSD
MSD2=[msd(:,1) msd(:,2)];
% Get Value of the plateau of the MSD
% That value changes the results considerably, 
% but it is calculated automatically
[MSDplateau, tfit2] = getMSDPlateau(MSD2, false);
%We define a MSD between tfit1 and tfit2 
pmsd0 = min(find(MSD2(:,1)>tfit1));
pmsd1 = min(find(MSD2(:,1)>tfit2));
MSD1=[msd(pmsd0:pmsd1,1) msd(pmsd0:pmsd1,2)];

%VAF
VACF2=[vaf(:,1) vaf(:,2)];
%We define a VAF between tfit1 and tfit2
pvaf0 = min(find(VACF2(:,1)>tfit1));
pvaf1 = min(find(VACF2(:,1)>tfit2));
VACF1=[vaf(pvaf0:pvaf1,1) vaf(pvaf0:pvaf1,2)];

%PSD
PSD2=[psd(:,1) psd(:,2)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Body of the Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Reading out of the zero crossing
Zero=findZero(VACF1); 
%When the MSD reaches half of its plateau-value
Half=findMSDHalf(MSD1,MSDplateau);
%The minimum of the experimental VACF
VACFmin=-min(VACF1(:,2));
%The fixed timescale tps in units of tf.
tps=(2/9)*(rhop/rhof)+1/9;      
%Calculate tkttf
tktf=get_tktf(Half,Zero,tps,10);

disp('Conversion to physical parameters');
% Calculates the timescale tf in s 
tf=Zero/getZeroCrossingVAF(tps,tktf);  
% Calculates tk in s
tk=tktf*tf;                 
%Calculate viscosity instead of a
eta = (rhof/tf)*(a)^2;
fprintf('eta [mPa.s]: %5.3f\n',eta/1e-3);
%Calculates the trap stiffness
k=6*pi*eta*sqrt(eta/rhof)/tktf/sqrt(tf);    
fprintf('k [muN/m]: %5.3f\n',k/1e-6);
% Thermal Energy
kT=1.38e-23*(273.15+T); 
% Effective Mass
mef=4/3*pi*a^3*(rhof/2+rhop);
m = rhop*(4/3)*pi*a^3;
%Other characteristic times:
tmk = sqrt(m/k);
tmeffk = sqrt(mef/k);
tpeff = mef/(6*pi*a*eta);
tp = m/(6*pi*a*eta);

%Calibration through MSD 
bM=sqrt(2*kT/(k*MSDplateau)); 
fprintf('Calibration factor for MSD [mum/V]: %5.3f\n',bM/1e-9);
%Calculate theoretical MSD and VAF
[MSDth,VAFth] = getTheoMSDandVAF(tps,tktf,tf,kT,k,mef);
%Find minimum of the theoretical VAF
VACFmintheo = findMinVAF(VAFth);

%Calibration by means of VAF
bV=sqrt(VACFmintheo/VACFmin);
fprintf('Calibration factor for VAF [mum/V]: %5.3f\n',bV/1e-9);

%Calibration by means of PSD (classic method)
[bP,fc,psdreg] = getCalPSD(PSD2,tfit1,tk,kT,eta,a);
fprintf('Calibration factor for PSD [mum/V]: %5.3f\n',bP/1e-9);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PLOT FIGURE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%disp('plot and save')
fig2 = figure;
set(fig2, 'Position', [500, 500, 500, 900]);
%Plotting MSD subfigure
subplot(3,1,1);
hold on;
plot(log10(MSD2(:,1)),log10(MSD2(:,2)*bM*bM),'bo','markersize',3)
plot(log10(MSDth(:,1)),log10(abs(MSDth(:,2))),'g-')
minmsd = min(MSDth(:,2));
maxmsd = max(MSDth(:,2));
plotLinesTimes(minmsd,maxmsd,tmk,'tmk',tk,'tk',tpeff,'tpeff',tf,'tf',tfit1,'tfit1',tfit2,'tfit2');
xlabel('log Time (s)')
ylabel('log MSD (m^2)')
title(sprintf('a %5.3f eta %5.3f k %5.3f beta %5.3f', a*1e6, eta*1e3, k*1e6, bM*1e9)); 
hold off;

%Plotting VAF subfigure
subplot(3,1,2);
hold on;
plot(log10(VACF2(:,1)),log10(abs(VACF2(:,2)*bV*bV)),'o','markersize',3)
plot(log10(VAFth(:,1)),log10(abs(VAFth(:,2))),'g-')
minvaf = min(abs(VAFth(:,2)));
maxvaf = max(abs(VAFth(:,2)));
plotLinesTimes(minvaf,maxvaf,tmk,'tmk',tk,'tk',tpeff,'tpeff',tf,'tf',tfit1,'tfit1',tfit2,'tfit2');
xlabel('log time (s)')
ylabel('log VAF (m^2/s^2)')
title(sprintf('a %5.3f eta %5.3f k %5.3f beta %5.3f', a*1e6, eta*1e3, k*1e6, bV*1e9)); 
hold off;

%Plotting PSD subfigure with linear regression
subplot(3,1,3);
hold on;
plot( log10(PSD2(:,1)),log10(PSD2(:,2)*bP*bP),'o','markersize',2)
plot(log10(psdreg(:,1)), log10(psdreg(:,2)*bP*bP),'r','LineWidth',2)
minpsd = PSD2(length(PSD2(:,1)),2)*bP*bP;
maxpsd = PSD2(10,2)*bP*bP;
plotLinesTimes(minpsd,maxpsd, 1/(2*pi*tmk),'1/tm',1/(2*pi*tk),'fc',1/(2*pi*tpeff),'fpeff',1/(2*pi*tf),'1/tf',1/(2*pi*tfit1),'ffit1',1/(2*pi*tfit2),'ffit2');
xlabel('log f (Hz)')
ylabel('log PSD (m^2)')
title(sprintf('a %5.3f eta %5.3f k %5.3f beta %5.3f', a*1e6, eta*1e3, k*1e6, bP*1e9)); 
hold off;

%%%%%%%%%%%%%%%%%%%
% SAVE DATA
%%%%%%%%%%%%%%%%%%%

%For saving in eps it is need to install epstool and xfig (in Linux)
sep = filesep();
patheps = strcat('.',sep,'output',sep,'calibration.eps');  
pathpdf = strcat('.',sep,'output',sep,'calibration.pdf');  

%Octave and Matlab save figures in different ways
if (isOctave)
    print('-S500,900', '-depsc2',patheps);
    print('-S500,900','-dpdf',pathpdf);
else
    print('-depsc2',patheps);
    print('-dpdf',pathpdf);
end;
    
%save data to txt file
%Input
%a T rhop rhof
%Times
%tmk tk tm tpeff tf fc
%Results
% eta k bM bV bP
sLabel1 = sprintf('a[mum]\tT[C]\trhop[gr/cm3]\trhof[gr/cm3]\t');
sLabel2 = sprintf('tmk[mus]\ttk[mus]\ttmeffk[mus]\ttpeff[mus]\ttf[mus]\tfc[MHz]\t');
sLabel3 = sprintf('eta[mPa.s]\tk[muN/m]\tbM[mum/V]\tbV[mum/V]\tbP[mum/V]');
sLabel = strcat(sLabel1, sLabel2, sLabel3,'\n');

%Data
sData1 = sprintf('%5.2f\t%3.2f\t%5.2f\t%5.2f\t',a/1e-6,T,rhop,rhof); 
sData2 = sprintf('%5.3f\t%5.3f\t%5.3f\t%5.3f\t%5.3f\t%5.3f\t',tmk/1e-6,tk/1e-6,tmeffk/1e-6,tpeff/1e-6,tf/1e-6,fc); 
sData3 = sprintf('%5.3f\t%5.3f\t%5.3f\t%5.3f\t%5.3f',eta*1e3,k/1e-6,bM/1e-9,bV/1e-9,bP/1e-9);
sData = strcat(sData1, sData2, sData3);
sOutput = [sLabel,sData];

pathdata = strcat('.',sep,'output',sep,'output_data.txt'); 
fid = fopen(pathdata,'wt+'); 
fprintf(fid, sOutput);
fclose(fid);

end


