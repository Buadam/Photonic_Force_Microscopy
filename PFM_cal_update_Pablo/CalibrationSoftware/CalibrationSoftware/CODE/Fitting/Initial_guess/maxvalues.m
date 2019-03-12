%Finds the maximum values of the PSD and MSD data, and obtains the rotational contributions (second plateau values) 
function [PSDrot MSDrot neg]=maxvalues(psdx,msdx,as,b,k,etaf,T)
kb=1.38e-23;

neg=0;
if ~isempty(psdx)
    PSDmax=psdx(1,2);  
    PSDrot=PSDmax-24*kb*T*as*etaf/k^2/b*pi*1e18; %rotational plateau= maximum-first plateaau (translational BM)
    if PSDrot<0
        disp('PSDrot negative, Single fitting')
        PSDrot=1e-4;
        neg=1;
    end
else
    PSDrot=0;
end
if ~isempty(msdx)
    MSDmax=msdx(end,2);
    MSDrot=MSDmax-2*kb*T/k/b*1e18; %rotational plateau= maximum-first plateaau (translational BM)
    if MSDrot<0
        disp('MSDrot negative')
        MSDrot=1e-2;
        neg=1;
    end
else
    MSDrot=0;
end