%%%%%%%%%%%%%%%%%%%%%%%%
% Calculates the value of the VAF at a given Time t via the formula of
% Clercx and Schram
%%%%%%%%%%%%%%%%%%%%%%%%%
function [VAF] = getVAFvalue(ROOT,RAT,t)
  
  help=zeros(1,4);
  help(1)=faddeeva(-1i*ROOT(1)*sqrt(t));
  help(2)=faddeeva(-1i*ROOT(2)*sqrt(t));
  help(3)=faddeeva(-1i*ROOT(3)*sqrt(t));
  help(4)=faddeeva(-1i*ROOT(4)*sqrt(t));
  VAF=help*diag(ROOT.^3)*RAT; 
  VAF=real(VAF);

end

