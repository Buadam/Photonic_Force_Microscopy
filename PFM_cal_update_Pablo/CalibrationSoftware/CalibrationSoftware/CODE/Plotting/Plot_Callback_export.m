% Plotting results
function Plot_Callback_export(hObject, eventdata, handles)

global f t 
global PSD MSD VAF 
global psdx msdx vafx 
global b 
global Phis Phif Phik Phirot taus tauf tauk taurot 
global fix weighting method double

nfree=size(find(1-fix),1); %Number of free parameters for reduced chi^2
PSDres=0;
MSDres=0;
VAFres=0;

%plot PSD
if ~isempty(psdx)                                                                                                                                                                               
double=get(handles.double,'value'); %Non-speherical model?

errorbar(handles.psdplot,psdx(:,1),abs(psdx(:,2)*b),abs(psdx(:,3)*b),'kx')
set(handles.psdplot,'nextplot','add')

loglog(handles.psdplot,f,PSD,'red','LineWidth',1.5)
if double==1 %Non-spherical model
    loglog(handles.psdplot,[Phis,Phif,Phik,Phirot]',interp1(f,PSD,[Phis,Phif,Phik,Phirot])','o', 'MarkerEdgeColor','red','MarkerSize',10,'LineWidth',2)
else %Spherical model
    loglog(handles.psdplot,[Phis,Phif,Phik]',interp1(f,PSD,[Phis,Phif,Phik])','o', 'MarkerEdgeColor','red','MarkerSize',10,'LineWidth',2)
end
set(handles.psdplot,'Xscale','log','Yscale','log')

PSDres=psdx(:,2)*b./interp1(f,PSD,psdx(:,1));  %Relative residuals
PSD95=1.95*psdx(:,3)*b./interp1(f,PSD,psdx(:,1)); % 95% confidence estimated from the standard errors of the data
PSDerr=sum(PSDres.^2)/(size(psdx,1)-nfree-1); % Chi^2 value for PSD
text(0.75,0.9,['\chi^2_{red}= ' num2str(PSDerr)],'Units','Normalized','Parent', handles.psdplot)

set(handles.psdplot,'nextplot','replace')
end

%plot MSD
if ~isempty(msdx)
  errorbar(handles.msdaxes,msdx(:,1),msdx(:,2)*b,msdx(:,3)*b,'kx') %Plot experimental data
  set(handles.msdaxes,'nextplot','add')
  set(handles.msdaxes,'xlim',[min(msdx(:,1)) 1.5*max(msdx(:,1))])
  set(handles.msdaxes,'ylim',[min(msdx(:,2)*b) 1.2*max(msdx(:,2))*b])
  plot(handles.msdaxes,t,MSD,'red','LineWidth',1.5)
  if double==1 %Non-spherical model, plot theoretical data and turning points
    plot(handles.msdaxes,[taus,tauf,tauk,taurot]',interp1(t,MSD,[taus,tauf,tauk,taurot])','o','MarkerEdgeColor','red','MarkerSize',10,'LineWidth',2)  
  else %Spherical model, plot theoretical data and turning points
    plot(handles.msdaxes,[taus,tauf,tauk]',interp1(t,MSD,[taus,tauf,tauk])','o','MarkerEdgeColor','red','MarkerSize',10,'LineWidth',2)    
  end
  set(handles.msdaxes,'nextplot','replace')

 %Scaling 
    if get(handles.linlog,'Value')==1
      set(handles.msdaxes,'Xscale','log','Yscale','linear')
    elseif get(handles.loglog,'Value')==1
      set(handles.msdaxes,'Xscale','log','Yscale','log')
    else
      set(handles.msdaxes,'Xscale','linear','Yscale','linear')
    end


MSDres=msdx(:,2)*b./interp1(t,MSD,msdx(:,1)); %Relative residuals
MSD95=1.95*msdx(:,3)*b./interp1(t,MSD,msdx(:,1)); % 95% confidence estimated from the standard errors of the data
MSDerr=sum(MSDres.^2)/(size(msdx,1)-nfree-1); % Chi^2 value for MSD
text(0.1,0.9,['\chi^2_{red}= ' num2str(MSDerr)],'Units','Normalized','Parent', handles.msdaxes)
end
    


%plot VAF
if ~isempty(vafx)

errorbar(handles.vafplot,vafx(:,1),abs(vafx(:,2)*b),abs(vafx(:,3)*b),'kx')  %Plot experimental data
set(handles.vafplot,'nextplot','add')
loglog(handles.vafplot,t,abs(VAF),'red','LineWidth',1.5)
if double==1 %Non-spherical model, plot theoretical data and turning points
loglog(handles.vafplot,[taus,tauf,tauk,taurot]',abs(interp1(t,VAF,[taus,tauf,tauk,taurot])),'o','MarkerEdgeColor','red','MarkerSize',10,'LineWidth',2)
else %Spherical model, plot theoretical data and turning points
loglog(handles.vafplot,[taus,tauf,tauk]',abs(interp1(t,VAF,[taus,tauf,tauk])),'o','MarkerEdgeColor','red','MarkerSize',10,'LineWidth',2)
end
set(handles.vafplot,'xlim',[min(vafx(:,1)) max(vafx(:,1))])
set(handles.vafplot,'ylim',[min(abs(vafx(:,2))*b) 1.2*max(vafx(:,2))*b])
set(handles.vafplot,'Xscale','log','Yscale','log')

VAFres=vafx(:,2)*b./interp1(t,VAF,vafx(:,1)); %Relative residuals
VAF95=1.95*vafx(:,3)*b./interp1(t,VAF,vafx(:,1)); % 95% confidence estimated from the standard errors of the data
VAFerr=sum(VAFres.^2)/(size(vafx,1)-nfree-1); % Chi^2 value for MSD
text(0.75,0.9,['\chi^2_{red}= ' num2str(VAFerr)],'Units','Normalized','Parent', handles.vafplot)

set(handles.vafplot,'nextplot','replace')
end

if get(handles.residual,'Value')==1 %calculate residuals
  
%Plotting residuals      

nfree=size(find(1-fix),1); %Number of free parameters for reduced chi^2

figure(4)

%PSD residuals
if ~isempty(psdx)
    
  subplot(2,3,1)
  set(gca,'FontSize',7);
  semilogx(psdx(:,1),PSDres,'k.') %Plot relative residuals
  hold on
  semilogx(psdx(:,1),1+PSD95,'g--','Marker','none','LineWidth',2) %plot upper 95% confidence limit
  semilogx(psdx(:,1),1-PSD95,'g--','Marker','none','LineWidth',2) %plot lower 95% confidence limit
  line([psdx(1,1) psdx(end,1)],[1 1]) %Plot 1 as a guide to the eye
  title('PSDdata/PSDfit','FontSize',7,'fontWeight','bold')
  xlabel('f(Hz)')
  ylabel('Residual')
  hold off
  
  %plot residual histogram
  subplot(2,3,4)
  set(gca,'FontSize',7);
  hist(PSDres,100)
  title('PSD Residual Histogram','FontSize',7,'fontWeight','bold')   
  xlabel('PSDdata/PSDfit')
  ylabel('Count')
  
end
%MSD residuals
if ~isempty(msdx)
    
  subplot(2,3,2)
  set(gca,'FontSize',7);
  semilogx(msdx(:,1),MSDres,'k.')  %Plot relative residuals
  hold on
  semilogx(msdx(:,1),1+MSD95,'g--','Marker','none','LineWidth',2) %plot upper 95% confidence limit
  semilogx(msdx(:,1),1-MSD95,'g--','Marker','none','LineWidth',2) %plot lower 95% confidence limit
  line([msdx(1,1) msdx(end,1)],[1 1]) %Plot 1 as a guide to the eye
  title('MSDdata/MSDfit','FontSize',7,'fontWeight','bold')
  xlabel('t(s)')
  hold off
  
  %plot residual histogram
  subplot(2,3,5)
  set(gca,'FontSize',7);
  hist(MSDres,100)
  title('MSD Residual Histogram','FontSize',7,'fontWeight','bold')
  xlabel('MSDdata/MSDfit')
  ylabel('Count')
  
end
%VAF residuals
if ~isempty(vafx)  
    
  subplot(2,3,3)
  set(gca,'FontSize',7);
  semilogx(vafx(:,1),VAFres,'k.') %Plot relative residuals
  hold on
  semilogx(vafx(:,1),1+VAF95,'g--','Marker','none','LineWidth',2) %plot upper 95% confidence limit
  semilogx(vafx(:,1),1-VAF95,'g--','Marker','none','LineWidth',2) %plot lower 95% confidence limit
  line([vafx(1,1) vafx(end,1)],[1 1]) %Plot 1 as a guide to the eye
  hold off
  title('VAFdata/VAFfit','FontSize',7,'fontWeight','bold')
  xlabel('t(s)')
  
  %plot residual histogram
  subplot(2,3,6)
  set(gca,'FontSize',7);
  hist(VAFres,100)
  title('VAF Residual Histogram','FontSize',7,'fontWeight','bold')   
  xlabel('VAFdata/VAFfit')
  ylabel('Count')
end

end    

%Calculating reduced chi-square for all selected graphs
chi2red=sqrt((sum(PSDres.^2)+sum(MSDres.^2)+sum(VAFres.^2))/(size(msdx,1)+size(vafx,1)+size(psdx,1)-nfree-1));
set(handles.Chi2,'string',num2str(chi2red))


%Export residuals
figure(5)

set(gca,'Units','Centimeters','Position',[1.5 1 3.5 3])

  semilogx(psdx(:,1),PSDres,'k.','MarkerSize',5) %Plot relative residuals
  hold on
  semilogx(psdx(:,1),1+PSD95,'g--','Marker','none','LineWidth',1) %plot upper 95% confidence limit
  semilogx(psdx(:,1),1-PSD95,'g--','Marker','none','LineWidth',1) %plot lower 95% confidence limit
  line([psdx(1,1) psdx(end,1)],[1 1],'LineWidth',0.5) %Plot 1 as a guide to the eye
%  title('PSD')
  xlabel('Frequency, \itf \rm(Hz)')
  ylabel('Experimental / Fitted')
  xlim([10 1e5])
  set(gca,'XTick',[1e1 1e3 1e5])
  hold off
printeps(5,'psdres')  
  %plot residual histogram
figure(6)
set(gca,'Units','Centimeters','Position',[1.5 1 3.5 3])
  hist(PSDres,100)
%  title('Residual Histogram')   
  xlabel('PSD_{exp}/PSD_{fit}')
  ylabel('Count')
  xlim([0.5 1.5])
printeps(6,'psdhist')    
figure(7)
set(gca,'Units','Centimeters','Position',[1.5 1 3.5 3])
  semilogx(msdx(:,1),MSDres,'k.','MarkerSize',5)  %Plot relative residuals
  hold on
  semilogx(msdx(:,1),1+MSD95,'g--','Marker','none','LineWidth',1) %plot upper 95% confidence limit
  semilogx(msdx(:,1),1-MSD95,'g--','Marker','none','LineWidth',1) %plot lower 95% confidence limit
  line([msdx(1,1) msdx(end,1)],[1 1],'LineWidth',0.5) %Plot 1 as a guide to the eye
%  title('MSDdata/MSDfit','fontWeight','bold')
  xlabel('Time, \itt \rm(s)')
  ylabel('Experimental / Fitted')
  hold off
printeps(7,'msdres')    
figure(8)  
set(gca,'Units','Centimeters','Position',[1.5 1 3.5 3])
  %plot residual histogram
  hist(MSDres,100)
%  title('MSD Residual','fontWeight','bold')
  xlabel('MSD_{exp}/MSD_{fit}')
  ylabel('Count')
  xlim([0.5 1.5])
printeps(8,'msdhist')    
figure(9) 
set(gca,'Units','Centimeters','Position',[1.5 1 3.5 3])
  semilogx(vafx(:,1),VAFres,'k.') %Plot relative residuals
  hold on
  semilogx(vafx(:,1),1+VAF95,'g--','Marker','none','LineWidth',1) %plot upper 95% confidence limit
  semilogx(vafx(:,1),1-VAF95,'g--','Marker','none','LineWidth',1) %plot lower 95% confidence limit
  line([vafx(1,1) vafx(end,1)],[1 1],'LineWidth',1) %Plot 1 as a guide to the eye
  hold off
%  title('VAFdata/VAFfit','fontWeight','bold')
  xlabel('Time, \itt \rm(s)')
  ylabel('Experimental / Fitted')
printeps(9,'vafres')    
figure(10)
set(gca,'Units','Centimeters','Position',[1.5 1 3.5 3])
  %plot residual histogram
  hist(VAFres,100)
%  title('VAF Residual','fontWeight','bold')   
  xlabel('VAF_{exp}/VAF_{fit}')
  ylabel('Count')
  xlim([0.5 1.5])
printeps(10,'vafhist')  