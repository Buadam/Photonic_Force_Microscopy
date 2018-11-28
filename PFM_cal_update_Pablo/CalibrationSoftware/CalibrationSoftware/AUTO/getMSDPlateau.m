%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculates the MSD Plateau before noise begins
%% This point has to be calculated interactively
%%%%%%%%%%%%%%%%%%%%%%%%
function [MSDplat, t2]=getMSDPlateau(MSD)

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

  fig1 = figure;
  plot (msdlogx,d2y_by_dx2,'o')
  axis square
  xlabel('log time (s)')
  ylabel('Second derivate of log MSD')
  title('Select point before noise begins')
  set(fig1, 'Position', [400, 400, 500, 500]);
  
  %get point where the noise begins
  [msd_selected_x msd_selected_y gbutton] = ginput(1);
  n = int16(min(find(msdlogx > msd_selected_x)));
  hold on;
  plot (msdlogx(n),d2y_by_dx2(n),'ro','markersize',15)
  MSDplat = 10^msdlogy(n-1);
  t2 = 10^msdlogx(n-1);
  results = sprintf('Obtained values: MSD Plateau %f tfit2 %f',MSDplat, t2);
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
