function [t0 taus tauf tauk kVAF]=t0VAF(vafx,as,k,rhos,rhof,etaf)

%VAF fitting
%Find t0 in VAF
ind=find(vafx(:,2)<0,1);
if ind<3 
    ind=find(vafx(:,2)<0,2); ind=ind(2);
end 
t0=vafx(ind-1,1)+(vafx(ind,1)-vafx(ind-1,1))*(vafx(ind-1,2)/(vafx(ind-1,2)-vafx(ind,2)));

%Calculating time scales depending on the radius 
taus=(2*as^2*rhos)/(9*etaf);
tauf=as^2*rhof/etaf;              %time scale associated to the hydrodinamic memory
%Searching t0/tauf => tauk
load('T0Tauf'); %tabulated values for t0/tauf in function of tauk (see M.Grimm, T. Franosch, S. Jeney, Phys. Rev. E, 86, (2012))

ind = find(T0Tauf1>t0/tauf,1);

if size(ind)==1
    tauk = tk(ind)*tauf;
    kVAF=(6*pi*etaf*as)/tauk;    %kVAF found
else
    kVAF=k; %kVAF not found, initial value returned
    tauk=6*pi*etaf*as/k;
end


