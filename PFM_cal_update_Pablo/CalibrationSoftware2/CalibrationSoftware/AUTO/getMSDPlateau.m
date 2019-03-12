%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculates the MSD Plateau before noise begins
%% This point is calculated automatically
%% bSaveGraph: true -> show and save graph which calculates
%% the noise point.
%%%%%%%%%%%%%%%%%%%%%%%%
function [MSDplat, t2]=getMSDPlateau(MSD,bSaveGraph)

  msdlogx = log10(MSD(2:length(MSD),1));
  msdlogy = log10(MSD(2:length(MSD),2));

  %splines
  pp = spline (msdlogx,msdlogy);
  %second derivative, calculated differently in Octave of Matlab
  if (isOctave) 
    pp2 = ppder (ppder (pp));
  else 
    pp2 = fnder(pp,2);
  end
  
  %vector for second derivative
  d2y_by_dx2 = ppval (pp2, msdlogx);

  %We obtain the modulation function of the second
  %derivate of the MSD. 
  [a b] = calcV(d2y_by_dx2);
  
  %Commands commented. Uncomment if needed
  %The second derivative of the MSD shows noise from a point
  %fig0 = figure;
  %plot (msdlogx,d2y_by_dx2,'o')
  
  %Value where noise begins
  modulationThreshold = 10;
  n = int16(min(find(abs(a)>modulationThreshold)))-1;
  
  
  if (bSaveGraph)
    fig1 = figure;
    plot (b,abs(a),'-')
    axis square
    xlabel('Point')
    ylabel('Modulation of the second derivate of log MSD')
    title('Modulation  before noise begins')
    set(fig1, 'Position', [400, 400, 500, 500]);
  end 
  
  MSDplat = 10^msdlogy(n);
  t2 = 10^msdlogx(n);
  results = sprintf('MSD Plateau %f, and POINT OBTAINED: %i',MSDplat, n);
  
  if (bSaveGraph) 
    title(results);
    %Save figure
    %For saving in eps it is need to install epstool and xfig (in Linux)
    sep = filesep();
    patheps = strcat('.',sep,'output',sep,'msd_noise.eps');  
    pathpdf = strcat('.',sep,'output',sep,'msd_noise.pdf');  
  
    %Octave and Matlab save figures in different ways  
    if (isOctave)
      print('-S500,500','-depsc2', patheps);
      print('-S500,500','-dpdf',pathpdf);
    else
      print('-depsc2',patheps);
      print('-dpdf',pathpdf);
    end;
  
    hold off;
    input('Press RETURN to close figure and continue calibration.');
    close;
  end

end
