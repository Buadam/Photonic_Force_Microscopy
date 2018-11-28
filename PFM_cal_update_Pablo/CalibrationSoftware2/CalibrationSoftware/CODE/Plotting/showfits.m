%If 'Show fits' option is checked, functions are plotted in separate
%windows
function []=showfits(psdx,msdx,vafx,logp,yFit,delta,plotselect,weighting,method,i,handles)


warning off
%get actual sensitivity parameter
b=exp(logp(3))*1e3;
%get experimental data
[xdata,ydata,errdata,sizePSD,sizeMSD,sizeVAF]=preprocess(plotselect,psdx,msdx,vafx,weighting,method);
    if weighting==1
        %variable for sorting PSD, MSD and VAF, only elements with non-zero
        %errors are included
        sel=[ones(size(psdx(find(psdx(:,3))),1)*get(handles.fitpsd,'value'),1);2*ones(size(msdx(find(msdx(:,3))),1)*get(handles.fitmsd,'value'),1);3*ones(size(vafx(find(vafx(:,3))),1)*get(handles.fitvaf,'value'),1)];
    else
        %variable for sorting PSD, MSD and VAF
        sel=[ones(size(psdx,1)*get(handles.fitpsd,'value'),1);2*ones(size(msdx,1)*get(handles.fitmsd,'value'),1);3*ones(size(vafx,1)*get(handles.fitvaf,'value'),1)];
    end
   
    %select PSD, MSD or VAF (plotselect = 1,2 or 3)
        yFit=yFit(find(sel==find(plotselect)));
        delta=delta(find(sel==find(plotselect)));

       %additional weighting
        if weighting==1
            yFit=yFit.*errdata;
            delta=delta.*errdata;
        end

figure(i) %1=PSD, 2=MSD, 3=VAF
if method==1 %Transforming fitted functions back to original
    if i==1 %PSD
        A=max(psdx(:,2));
        B=min(log(psdx(:,2)/A));
        yFit=A*exp(yFit*B);
        delta=B*delta.*yFit;
        ydata=psdx(:,2);
        errdata=psdx(:,3);
        
        if weighting==1
        ydata=ydata(find(psdx(:,3)));
        errdata=errdata(find(psdx(:,3)));
        end
        
    elseif i==2 %MSD
        A=max(msdx(:,2));
        B=min(log(msdx(:,2)/A));
        yFit=A*exp(yFit*B);
        delta=B*delta.*yFit;
        ydata=msdx(:,2);
        errdata=msdx(:,3);
        
        if weighting==1
        ydata=ydata(find(msdx(:,3)));
        errdata=errdata(find(msdx(:,3)));
        end
        
    elseif i==3 %VAF
        A=max(vafx(:,2));
        B=min(log(abs(vafx(:,2)/A)));
        yFit=A*exp(yFit*B);
        delta=B*delta.*yFit;
        ydata=vafx(:,2);
        errdata=vafx(:,3);
        
        if weighting==1
        ydata=ydata(find(vafx(:,3)));
        errdata=errdata(find(vafx(:,3)));
        end
        
    end
end



%Plotting data



box on
set(gca,'FontSize',12);
set(gcf, 'Color', 'w');
set(gcf,'Units','centimeters')

h1=errorbar(downsample(xdata,2),abs(downsample(ydata*b,2)),abs(downsample(errdata*b,2)),'ko','Markersize',12,'LineWidth',0.5); %experimental data (downsampled for better visibility)
hold on
h2=loglog(xdata,abs(yFit)*b,'b-','LineWidth',3); %Fitted curve
h3=loglog(xdata,(abs(yFit)+delta)*b,'r:','LineWidth',3); %Positive confidence interval
h4=loglog(xdata,(abs(yFit)-delta)*b,'r:','LineWidth',3); %Negative confidence interval
set(gca,'Xscale','log','Yscale','log')


%Plot labels
if i==1 %PSD
   
   set(gca,'FontSize',16);
   
   xlabel('Frequency, \itf \rm(Hz)')
   ylabel('PSD(nm^2/Hz)')
   legend([h1 h2 h3],{'Measurement data','Fitted curve','Confidence interval'})
   
elseif i==2 %MSD
   set(gca,'FontSize',16);
   xlabel('Time, \itt \rm(s)')
   ylabel('MSD(nm^2)')
   legend([h1 h2 h3],{'Measurement data','Fitted curve','Confidence interval'},'Location','SouthEast')
   
  
elseif i==3 %VAF
   set(gca,'FontSize',16);
   xlabel('Time, \itt \rm(s)')
   ylabel('VAF(nm^2/s^2)')
   legend([h1 h2 h3],{'Measurement data','Fitted curve','Confidence interval'},'Location','SouthWest')
   
end

hold off
