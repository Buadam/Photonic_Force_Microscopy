%%%%%%%%%%%%%%%%%%%%%%%%
% This function finds the zero-crossing of the VACF via linear
% interpolation between the last point, which is positive and the first
% negative one.
%%%%%%%%%%%%%%%%%%%%%%%%%
function Zero = findZero(VACF)
  f1=VACF(1,2);
  for i=1:length(VACF-1)
      f2=VACF(i+1,2);
      if f2/f1<0
          Zero=VACF(i,1)+f1*(VACF(i+1,1)-VACF(i,1))/(f1-f2);
          break
      end
      f1=f2;
  end

end

