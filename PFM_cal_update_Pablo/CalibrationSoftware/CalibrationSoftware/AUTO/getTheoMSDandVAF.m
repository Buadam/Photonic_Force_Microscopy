%%%%%%%%%%%%%%%%%%%
%% Theoretical curves for MSD and VAF
%%%%%%%%%%%%%%%%%%%
function [MSDth,VAFth] = getTheoMSDandVAF(tps,tktf,tf,kT,k,mef)

  %log scales 10^fit 
  ifit = -2;
  ffit = 5;
  x=(ifit:0.02:ffit)';
  %Init theoretical MSD and VAF
  MSDth=[10.^x x];
  VAFth=MSDth;
  %Calculate the theoretical curves
  for i=1:length(x)
   [VAFth(i,2),MSDth(i,2)]=theoreticalMSDandVAF(1,tps,tktf,10^x(i)); 
  end;clear i;clear x;
  %In physical units
  MSDth(:,1)=MSDth(:,1)*tf;
  MSDth(:,2)=MSDth(:,2)*2*kT/k;
  VAFth(:,1)=VAFth(:,1)*tf;
  VAFth(:,2)=VAFth(:,2)*(kT/mef);

end
