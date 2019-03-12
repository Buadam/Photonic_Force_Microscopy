%This function contains the model function of the fitting. The function
%returns one concatenated array with the PSD, MSD and VAF values. sizePSD, sizeMSD and sizeVAF mark the length of each function.
%If weighting is selected, the model function is multiplied by the weights
%at the call of this function. 
%Only the free variables are varied during the fitting algorithm, which is
%specified by the call of this function

function [OUTPUT] = modelfunction(free,fixed,fix,T,etaf,rhos,rhof,psdx,msdx,vafx,select,xdata,sizePSD,sizeMSD,sizeVAF,double,method)

%calculation of relevant parameters for PSD,MSD,VAF
%%
kb=1.38e-23;

%Arranging free and fixed variables back in order (as,k,beta,PSDrot,MSDrot)
i=1;
j=1;
for l=1:5
if fix(l)==1 %is the l-th parameter fixed?
    logp(l)=fixed(i); 
    i=i+1;
else
    logp(l)=free(j);
    j=j+1;
end
end

%transform the parameter values back to linear (ensuring positive values)
as=exp(logp(1))*1e-7; 
k=exp(logp(2))*1e-5;
b=exp(logp(3))*1e3;
PSDrot=exp(logp(4))*1e-3;
MSDrot=exp(logp(5))*0.1;

%check if there is a double plateau in the PSD and MSD
if double==1 %Non-spherical model selected
    if PSDrot<1e-6 || MSDrot<1e-4; %The function can be fitted by a single relaxation, second plateau values are too small
        Taurot=0.001;
        Drot=0;
        disp('Double plateau insignificant')
    else % There is a significant second plateau
        Taurot=PSDrot/2/MSDrot;
        Drot=MSDrot/Taurot/2;
    end
else %Spherical model, no second relaxation
        Taurot=0.001;
        Drot=0;
end

%Calculating time and frequency scales, and other properties
taus=(2*as^2*rhos)/(9*etaf);
tauf=as^2*rhof/etaf;        
tauk=6*pi*etaf*as/k;
D=kb*T/(6*pi*etaf*as);

Phis=1/(2*pi*taus);
Phif=1/(2*pi*tauf);
Phik=1/(2*pi*tauk);
Phirot=1/(2*pi*Taurot);

ms=as^3*4/3*pi*rhos;
mf=as^3*4/3*pi*rhof;

%Solving polinomial for the MSD and the VAF
eq = [taus+(tauf/9) -sqrt(tauf) 1 0 1/tauk];

if  all(1-isnan(eq))==0 
    disp('INF')
elseif  all(1-isnan(eq))==0
    disp('NaN')
else  %IF the above equation is not singular
s = roots(eq);
%%

sel=[ones(sizePSD*select(1),1);2*ones(sizeMSD*select(2),1);3*ones(sizeVAF*select(3),1)]; %variable for extracting PSD,MSD and VAF from xdata,ydata,errdata
%initializing variables
logPSD=[];
PSD=[]; MSD=[]; VAF=[];
logMSD=[];
logVAF=[];

if select(1)==1 %PSD fitting selected
    f=xdata(find(sel==1));
    %Not transformed PSD (linear mode)
    PSD=PSDdouble(f,D,Drot,Phis,Phif,Phik,Phirot,b);
    %Logarithmic transformation of the PSD (logarithmic mode)
    A=max(psdx(:,2));
    logPSD= log(PSD/A)/min(log(abs(psdx(:,2))/A));
    
    
end
if select(2)==1 %MSD fitting selected
        tmsd=xdata(find(sel==2));
        %Not transformed MSD (linear mode)
        MSD=MSDdouble(tmsd,D,taus,tauf,tauk,Taurot,MSDrot,s,b);
        %Logarithmic transformation of the MSD (logarithmic mode)
        A=max(msdx(:,2));
        logMSD=log(MSD/A)/min(log(abs(msdx(:,2))/A));
        
end        
if select(3)==1 %VAF fitting selected
       tvaf=xdata(find(sel==3));
       %Not transformed VAF (linear mode)
       VAF=VAFdouble(tvaf,T,ms,mf,Drot,Taurot,s,b);
       %Logarithmic transformation of the VAF (logarithmic mode)
       A=max(vafx(:,2));
       logVAF= log(abs(VAF/A))/min(log(abs(vafx(:,2)/A)));
            
end            

if method==0 %Linear mode
OUTPUT=[PSD;MSD;VAF];
elseif method==1 %Logarithmic mode
OUTPUT=[logPSD;logMSD;logVAF];   
end

end

%%plot actual fit during MLH fitting to see convergence (slow)
%{
figure(1)
loglog(f,PSD,'r-')
hold on
errorbar(psdx(:,1),psdx(:,2),psdx(:,3),'kx')
hold off
           
figure(2)
loglog(tmsd,MSD,'r-')
hold on
errorbar(msdx(:,1),msdx(:,2),msdx(:,3),'kx')
hold off
            
figure(3)
loglog(tvaf,abs(VAF),'r-')
hold on
errorbar(vafx(:,1),abs(vafx(:,2)),vafx(:,3),'kx')
hold off
%}




