%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function calculates the zero-crossing of a VAF with given parameters
% tps/tf and tk/tf. The value is calculated in units of tf. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Zero = getZeroCrossingVAF(tps,tk)
  eps=1e-7;   % Precision of the Value
  dd=0.25; % Value for the estimation of the starting interval

  tf=1;
  polynomial=[tps/tf 1 1 0 tf/tk]; 
  ROOT=roots(polynomial);             
  RAT=zeros(4,1);
  RAT(1)=1/(ROOT(1)-ROOT(2))/(ROOT(1)-ROOT(3))/(ROOT(1)-ROOT(4));
  RAT(2)=1/(ROOT(2)-ROOT(1))/(ROOT(2)-ROOT(3))/(ROOT(2)-ROOT(4));
  RAT(3)=1/(ROOT(3)-ROOT(1))/(ROOT(3)-ROOT(2))/(ROOT(3)-ROOT(4));
  RAT(4)=1/(ROOT(4)-ROOT(1))/(ROOT(4)-ROOT(2))/(ROOT(4)-ROOT(3));

  I=[1 0];
  VAF1=getVAFvalue(ROOT,RAT,10^(-1));
  for i=1:10000
     VAF2=getVAFvalue(ROOT,RAT,10^(-1+i*dd));
     q=VAF2/VAF1;
      if q<0
          I=[10^(-1+(i-1)*dd),10^(-1+i*dd)];
          break
      else
          VAF1=VAF2;
      end
  end

  n=0;
  while abs(getVAFvalue(ROOT,RAT,I(1)))>eps || abs(getVAFvalue(ROOT,RAT,I(2)))>eps
     n=n+1;
     I1=I(1);I2=I(2);
     In=mean(I);
     q=getVAFvalue(ROOT,RAT,I(1))/getVAFvalue(ROOT,RAT,In);
     if q>0
         I=[In I2];
     else
         I=[I1 In];
     end
     if n==50
         break
     end
  end

  Zero=mean(I);

end

