%%%%%%%%%%%%%%%%%%%%
%Calculation of the calibration by the classic method
%of the corner frequency on the PSD.
%S0 = PSD Plateau. PSD units are [m V^2])
%%%%%%%%%%%%%%%%%%%%
function [bP,fc,psdreg] = getCalPSD (PSD2,tfit1,tk,kT,eta,a)

  limitPlateauPSD = 20;
  S0 = mean(PSD2(1:limitPlateauPSD,2));
  %Corner frequency
  fc = 1/(2*pi*tk);
  %Region of the PSD to fit
  ppsd1 = min(find(PSD2(:,1)>fc));
  ppsd2 = min(find(PSD2(:,1)>1/(2*pi*tfit1)));
  psdx = PSD2(ppsd1:ppsd2,1);
  psdy = PSD2(ppsd1:ppsd2,2);
  %Linear regression in the central region of the PSD
  r=polyfit(log10(psdx),log10(psdy),1);
  S0f02 = 10^r(2); 
  f0 = sqrt(S0f02/S0);
  %Calibration factor
  bP = sqrt(kT/(6*3.141592^3*eta*a*S0f02));
  %Creates an array to plot the regression data
  for i=1:length(psdx)
	  psdregy(i)=(10^(r(2)))*(psdx(i))^r(1);	
  end;clear i;
  psdreg = [psdx(:) psdregy(:)];


end
