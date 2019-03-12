%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function finds the time, where the MSD reaches half of its plateau via linear
% interpolation between the last point, which is below and the first one, which is above.
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Half = findMSDHalf(MSD,MSDplateau)
  f1=MSD(1,2);
  for i=1:length(MSD-1)
      f2=MSD(i+1,2);
      if f1<(MSDplateau/2) && f2>(MSDplateau/2)
          Half=MSD(i,1)+(0.5*MSDplateau-f1)/(f2-f1)*(MSD(i+1,1)-MSD(i,1));
          break
      end
      f1=f2;
  end

end

