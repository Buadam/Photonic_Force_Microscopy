%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function calculates the VAF and MSD for a given set of parameters
% tf,tps and tk for a time t by Clercx and Schram's formula.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [VAF,MSD] = theoreticalMSDandVAF(tf,tps,tk,t)
  
  format long e
  %Fourth grade polinomy
  polynomial=[tps/tf 1 1 0 tf/tk]; 
  ROOT=roots(polynomial);           

  help=zeros(1,4);
  help(1)=faddeeva(-1i*ROOT(1)*sqrt(t));
  help(2)=faddeeva(-1i*ROOT(2)*sqrt(t));
  help(3)=faddeeva(-1i*ROOT(3)*sqrt(t));
  help(4)=faddeeva(-1i*ROOT(4)*sqrt(t));
  RAT=zeros(4,1);
  RAT(1)=1/(ROOT(1)-ROOT(2))/(ROOT(1)-ROOT(3))/(ROOT(1)-ROOT(4));
  RAT(2)=1/(ROOT(2)-ROOT(1))/(ROOT(2)-ROOT(3))/(ROOT(2)-ROOT(4));
  RAT(3)=1/(ROOT(3)-ROOT(1))/(ROOT(3)-ROOT(2))/(ROOT(3)-ROOT(4));
  RAT(4)=1/(ROOT(4)-ROOT(1))/(ROOT(4)-ROOT(2))/(ROOT(4)-ROOT(3));

  MSD=1+(help*diag(1./ROOT)*RAT)/tps/tk; 
  VAF=help*diag(ROOT.^3)*RAT; 

  VAF=real(VAF);  
  MSD=real(MSD);

end

