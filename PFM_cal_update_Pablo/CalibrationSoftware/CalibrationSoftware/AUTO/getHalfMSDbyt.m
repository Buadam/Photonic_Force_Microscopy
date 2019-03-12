%%%%%%%%%%%%%%%%%%%%%%%%%
% calculates half of the MSD for a given time t 
% via the formula of Clercx and Schram
%%%%%%%%%%%%%%%%%%%%%%%%%%
function [HAL] = getHalfMSDbyt(ROOT,RAT,tps,tk,t)

  help=zeros(1,4);

  help(1)=faddeeva(-1i*ROOT(1)*sqrt(t));
  help(2)=faddeeva(-1i*ROOT(2)*sqrt(t));
  help(3)=faddeeva(-1i*ROOT(3)*sqrt(t));
  help(4)=faddeeva(-1i*ROOT(4)*sqrt(t));

  MSD=1+(help*diag(ROOT.^(-1))*RAT)/tps/tk; 

  MSD=real(MSD);
  HAL=0.5-MSD;

  end
