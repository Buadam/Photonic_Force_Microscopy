%Initial guess for the radius, spring constant and sensitivity
function [as,k,b] = fit_singleplateau(f,t,psdx,msdx,vafx,rhos,rhof,etaf,T,as,k,asmin,asmax,maxiter,eps)
kb=1.38e-23;

%Start semi-automatic fitting (INPUT: as,rhos,rhof,etas,T;    VARIED: as)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Fitting single plateau')
ready=0;
iter=0;
while ready==0 
    
%Initial guess for k according to VAF zero crossing
[t0,taus,tauf,tauk,kVAF]=t0VAF(vafx,as,k,rhos,rhof,etaf);
%Calculating BM parameters
Phis=1/(2*pi*taus);
Phif=1/(2*pi*tauf);
Phik=1/(2*pi*tauk);
D=kb*T/(6*pi*etaf*as);
ms=as^3*4/3*pi*rhos;
mf=as^3*4/3*pi*rhof;

%Calculating theoretical curves
[PSD,MSD,VAF]=psdmsdvaf_single(D,f,t,Phis,Phif,Phik,taus,tauf,tauk,ms,mf,T);

%FITTING TO VAF to find betaVAF
%Calculating beta according to VAF LTT
bVAF=betaVAF(vafx,t,t0,VAF);

%END OF FITTING TO VAF

%FITTING TO MSD to find betaMSD
%Finding end of diffusion regime
    if ~isempty(msdx)
        ind2=find(msdx(:,1)>0.1*tauk,1);
        %Dividing theoretical with experimental: bMSD
        bMSD=mean(interp1(t,MSD,msdx(1:ind2,1))./msdx(1:ind2,2));  %!!!!!bMSD found
        %finding kMSD according to the plateau value

        %TEST EXIT CONDITION (bVAF=bMSD)
        [asmin,asmax,as,b,ready] = betaVAF_equals_betaMSD(asmin,asmax,as,bVAF,bMSD,eps,iter,maxiter);
        iter=iter+1;
    else
        ready=1; %If there is no MSD data to fit
        b=bVAF;
    end
    
end  %END OF ITERATION
disp(['Single-plateau parameters converged in: ' num2str(iter) ' steps'])

k=kVAF;
if ~isempty(msdx)
    %REFINING k value, by fitting theoretical corner frequency on the
    %experimental data
    disp('Refining k value')
    [k,iter]=refine_kMSD(t,MSD,msdx,as,kVAF,b,taus,tauf,tauk,etaf,D,eps);
    disp(['Refining k converged in: ' num2str(iter) ' steps'])
end   
    
