%Plotting and saving graphs for exporting
function []=plot_hold(t,psdx,msdx,vafx,taus,tauf,tauk,taurot,f,PSD,MSD,VAF,Phis,Phif,Phik,Phirot,b,double,color,holdon,FileName,PathName)


%PLOTTING
%PSD
if ~isempty(psdx)
h1 = figure(1);
set(h1, 'Visible', 'off');
grid off
%plotting theoretical function
loglog(f,PSD,'color',color)
hold on
if double==0 %Spherical model, plotting cutoff frequencies
loglog([Phis,Phif,Phik]',interp1(f,PSD,[Phis,Phif,Phik])','o', 'MarkerEdgeColor',color)
else %Non-spherical model, plotting cutoff frequencies
loglog([Phis,Phif,Phik,Phirot]',interp1(f,PSD,[Phis,Phif,Phik,Phirot])','o', 'MarkerEdgeColor',color)
end

%plot experimental PSD
errorbar(psdx(:,1),psdx(:,2)*b,psdx(:,3)*b,'kx') 
xlim([0.8*min(psdx(:,1)) 1.2*max(psdx(:,1))]);
ylim([0.8*min(b*psdx(:,2)) 1.2*max(b*psdx(:,2))]);
xlabel('f(Hz)')
ylabel('PSD(nm^2/Hz)')

if holdon==0
    hold off
    saveas(gcf,fullfile(PathName, [strrep(FileName,'.txt','') '_PSD_plot.png'])) %Save image 
end
end

%MSD 
if ~isempty(msdx)
h2 = figure(2);
set(h2, 'Visible', 'off');
%plotting theoretical function
loglog(t,MSD,'color',color)

hold on 
if double==0  %Spherical model, plotting characteristic times
loglog([taus,tauf,tauk]',interp1(t,MSD,[taus,tauf,tauk])','o','MarkerEdgeColor',color)
else  %Non-spherical model, plotting characteristic times
loglog([taus,tauf,tauk,taurot]',interp1(t,MSD,[taus,tauf,tauk,taurot])','o','MarkerEdgeColor',color)
end
%plot experimental MSD
errorbar(msdx(:,1),msdx(:,2)*b,msdx(:,3)*b,'kx')
xlim([0.8*min(msdx(:,1)) 1.2*max(msdx(:,1))]);
ylim([0.8*min(b*msdx(:,2)) 1.2*max(b*msdx(:,2))]);
xlabel('t(s)')
ylabel('MSD(nm^2)')

if holdon==0
    hold off
    saveas(gcf,fullfile(PathName, [strrep(FileName,'.txt','') '_MSD_plot.png'])) %Save image
end
end


%VAF
if ~isempty(vafx)
h3 = figure(3);
set(h3, 'Visible', 'off');
%plotting theoretical function
loglog(t,abs(VAF),'color',color)
hold on
if double==0 %Spherical model, plotting characteristic times
loglog([taus,tauf,tauk]',abs(interp1(t,VAF,[taus,tauf,tauk])),'o','MarkerEdgeColor',color)
else %Non-spherical model, plotting characteristic times
loglog([taus,tauf,tauk,taurot]',abs(interp1(t,VAF,[taus,tauf,tauk,taurot])),'o','MarkerEdgeColor',color)
end
%plot experimental MSD
errorbar(vafx(:,1),abs(vafx(:,2))*b,abs(vafx(:,3))*b,'kx')
xlim([0.8*min(abs(vafx(:,1))) 1.2*max(abs(vafx(:,1)))]);
ylim([0.1*min(b*abs(vafx(:,2))) 1.2*max(b*vafx(:,2))]);
xlabel('t(s)')
ylabel('VAF(nm^2/s^2)')

if holdon==0
    hold off 
    saveas(gcf,fullfile(PathName, [strrep(FileName,'.txt','') '_VAF_plot.png'])) %Save image
end
end

 
