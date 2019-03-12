function calculateCalibrationHisto(T,ksti,histo)

  kT=1.38e-23*(273.15+T); 

  %%%%%%%%%%%%%%%%%%%%%%
  %USING QUADRATIC POLINOMIAL
  %%%%%%%%%%%%%%%%%%%%%%%%
  n = find(histo(:,2)>0);
  xdata = histo(n,1);
  y = histo(n,2);

  %Fit to quadratic polinomial
  [r,S] = polyfit(xdata, log(y), 2);
  %Errors: http://stackoverflow.com/questions/13290508/how-to-fit-a-gaussian-to-data-in-matlab-octave
  R = S.R;                % The 'R' from A = QR
  d = (R'*R)\eye(1+1+1);    % The covariance matrix (n=1)
  d = diag(d)';           % ROW vector of the diagonal elements
  MSE = (S.normr^2)/S.df; % variance of the residuals
  se = sqrt(MSE*d);       % the standard errors
  t = r./se;           % observed T-values 
  %First coeffcient is r(1) and error se(1)

  %Constants
  sigmaE = sqrt(-1/(r(1)*2));
  deltasigmaE = se(1)/(sigmaE*r(1)^2);

  %Calibration with energy
  beta_E = sqrt(kT/(ksti*sigmaE^2))/1e-9;
  beta_E_error = deltasigmaE*beta_E/sigmaE;
  fprintf('Calibration factor for energy [mum/V]: %2.2f ± %1.2f\n',beta_E, beta_E_error);

  %Polynomial fit (energy)
  yp = -polyval(r,xdata);

  %%%%%%%%%%%%%%%%%%%%%%
  %%USING NOT-LINEAR SQUARES FITTING
  %%%%%%%%%%%%%%%%%%%%%%%%

  %Load Forge package for lsqcurvefit
  if (isOctave)
    pkg load optim;
  end;
  
  %Gaussian function
  %gausFun = @(hms,x) (hms(1)/(hms(3)*sqrt(2*pi))) .* exp (-0.5*((x-hms(2))/hms(3)).^2); 
  gausFun = @(hms,x) hms(1) .* exp (-0.5*((x-hms(2))/hms(3)).^2); 
  % Provide estimates for initial conditions (for lsqcurvefit)
  height_est = max(histo(:,2)); 
  mean_est = mean(histo(:,1)); 
  std_est=std(histo(:,1));
  % parameters need to be in a single variable
  x0 = [height_est;mean_est; std_est]; 

  
  optionset = optimset('Display','off','Jacobian', 'off'); % avoid pesky messages from lsqcurvefit
  [params, ~, residual, ~,~,~,jac]=lsqcurvefit(gausFun,x0,histo(:,1),histo(:,2),[], [], optionset); 
  %https://www.gnu.org/software/gsl/manual/html_node/Computing-the-covariance-matrix-of-best-fit-parameters.html
  %Converting the results from ilsqcurvefit into real matrixes with full
  xCovariance = inv(full(jac).'*full(jac))*full(var(residual));
  paramerrors = sqrt(diag(xCovariance))';
  %The regression is made including zeros,the plotting without the zeros
  ypgauss = gausFun(params,xdata);

  %Constants
  sigmaG = params(3);
  deltasigmaG = paramerrors(3);
  muG = params(2);
  deltamuG = params(2);

  %Calibration with Gaussian
  beta_G = sqrt(kT/(ksti*sigmaG^2))/1e-9;
  beta_G_error = deltasigmaG*beta_G/sigmaG;
 
  fprintf('Calibration factor for Gaussiaf fit [mum/V]: %2.2f ± %1.2f\n',beta_G, beta_G_error);
    
  %%%%%%%%%%%%%%%%%%%%%%
  %Figure
  %%%%%%%%%%%%%%%%%%%%%%%%

  fig = figure;
  set(fig, 'Position', [500, 500, 500, 500])
  axis square
  subplot(2,1,1)
  hold on
  %Gaussfit. All normalized.
  plot(xdata,y./sum(y),'b-')
  plot(xdata,ypgauss./sum(ypgauss),'r-','linewidth',1)
  axis ('on')
  title(sprintf('Histogram and Gaussian fitting (beta: %2.2f +- %1.2f)', beta_G, beta_G_error))
  xlabel('Position (mV)');ylabel('Probability');legend('Data','Fit')
  hold off
  %Quadratic polinomy
  subplot(2,1,2)
  hold on
  plot(xdata,-log(y),'bo','markersize',4)
  plot (xdata,yp,'r','linewidth',2)
  title(sprintf('Boltzmann statistics (beta: %2.2f +- %1.2f)', beta_E, beta_E_error))
  xlabel('Position (mV)');ylabel('E (k_BT)');legend('Data','Fit')
  hold off
  
  
  %%%%%%%%%%%%%%%%%%%
  % SAVE DATA
  %%%%%%%%%%%%%%%%%%%
  %For saving in eps it is need to install epstool and xfig (in Linux)
  sep = filesep();
  patheps = strcat('.',sep,'output',sep,'histo.eps');  
  pathpdf = strcat('.',sep,'output',sep,'histo.pdf');  

  %Octave and Matlab save figures in different ways  
  if (isOctave)
    print('-S500,500','-depsc2', patheps);
    print('-S500,500','-dpdf',pathpdf);
  else
    print('-depsc2',patheps);
    print('-dpdf',pathpdf);
  end;
  
  %save data to txt file
  %Input
  %T ksti 
  %Results
  %bE bEerror bG bGerror 
  sLabel1 = sprintf('T[C]\tk_estimated[muN/m]\t');
  sLabel2 = sprintf('bE[mum/V]\tbE_error[mum/V]\tbG[mum/V]\tbG_error[mum/V]');
  sLabel = [sLabel1, sLabel2, '\n'];

  %Data
  sData1 = sprintf('%3.1f\t%5.3f\t',T,ksti/1e-6); 
  sData2 = sprintf('%5.3f\t%5.3f\t%5.3f\t%5.3f',beta_G,beta_G_error,beta_E,beta_E_error);
  sData = [sData1, sData2];
  sOutput = [sLabel,sData];

  %Not needed ASCII argument
  pathdata = strcat('.',sep,'output',sep,'output_data_histo.txt');  
  fid = fopen(pathdata,'wt+'); 
  fprintf(fid, sOutput);
  fclose(fid);

end
