%%%%%%%%%%%%%%%%%%%
% This function calculates half of the MSD plateau value for given paramters
% tps/tf and tk/tf. Time is given out in units of tf.
%%%%%%%%%%%%%%%%%%%%
function [HAL] = getHalfMSD(tps,tk)

  % Precision of the Value
  eps=1e-7;
  % Value for the estimation of the starting interval   
  dd=0.25; 
	
  tf=1;
  polynomial=[tps/tf 1 1 0 tf/tk]; 
  ROOT=roots(polynomial);             
  RAT=zeros(4,1);
  RAT(1)=1/(ROOT(1)-ROOT(2))/(ROOT(1)-ROOT(3))/(ROOT(1)-ROOT(4));
  RAT(2)=1/(ROOT(2)-ROOT(1))/(ROOT(2)-ROOT(3))/(ROOT(2)-ROOT(4));
  RAT(3)=1/(ROOT(3)-ROOT(1))/(ROOT(3)-ROOT(2))/(ROOT(3)-ROOT(4));
  RAT(4)=1/(ROOT(4)-ROOT(1))/(ROOT(4)-ROOT(2))/(ROOT(4)-ROOT(3));

  %Find a good starting interval
  I=[1 0];
  MSD1=getHalfMSDbyt(ROOT,RAT,tps,tk,10^(-1));
  for i=1:10000
     MSD2=getHalfMSDbyt(ROOT,RAT,tps,tk,10^(-1+i*dd));
     q=MSD2/MSD1;
      if q<0
          I=[10^(-1+(i-1)*dd),10^(-1+i*dd)];
          break
      else
          MSD1=MSD2;
      end
  end

  %We search for the value via the method of nested intervals
  n=0;
  while abs(getHalfMSDbyt(ROOT,RAT,tps,tk,I(1)))>eps || abs(getHalfMSDbyt(ROOT,RAT,tps,tk,I(2)))>eps
     n=n+1;
     I1=I(1);I2=I(2);
     In=mean(I);
     q=getHalfMSDbyt(ROOT,RAT,tps,tk,I(1))/getHalfMSDbyt(ROOT,RAT,tps,tk,In);
     if q>0
         I=[In I2];
     else
         I=[I1 In];
     end
     if n==50
         % errordlg('Problem');
         break
     end
  end

  % the value is the mean of the interval
  HAL=mean(I);

end

