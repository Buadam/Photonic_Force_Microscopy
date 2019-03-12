%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Calculates the ratio tk/tf 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [tktf]=get_tktf(Half,Zero,tps,factor)

  Q=Half/Zero;
  n=1;
  q=getHalfMSD(tps,n)/getZeroCrossingVAF(tps,n);
  %disp(Q)
  %zehner
  while q<Q
     %n=n+10;
     n=n+10*factor;
     q=getHalfMSD(tps,n)/getZeroCrossingVAF(tps,n);
     %disp(q)
  end
  %n=n-10;
  n = n-10*factor;
  q=getHalfMSD(tps,n)/getZeroCrossingVAF(tps,n);

  % einer
  while q<Q
     %n=n+1;
     n=n+1*factor;
     q=getHalfMSD(tps,n)/getZeroCrossingVAF(tps,n);
  end
  %n=n-1;
  n=n-1*factor;
  q=getHalfMSD(tps,n)/getZeroCrossingVAF(tps,n);
  % Zehntel
  while q<Q
     %n=n+0.1;
     n=n+0.1*factor;
     q=getHalfMSD(tps,n)/getZeroCrossingVAF(tps,n);
  end
  %tktf=n-0.1;
  tktf=n-0.1*factor;

end

