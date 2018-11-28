function PSD= PSDdouble(f,D,Drot,Phis,Phif,Phik,Phirot,b)

PSDtr = 1e18/b*(D./(pi^2*f.^2)).*(1+sqrt(f./(2*Phif)))./((Phik./f-f./Phis-sqrt(f./(2*Phif))).^2+(1+sqrt(f./(2*Phif))).^2);
PSDrot= Drot./(pi^2*f.^2.*(1+(Phirot./f).^2));
PSD=PSDtr+PSDrot;

%{   
    figure(100)
        loglog(f,PSDtr,'b') %plot translational contribution
        hold on
        loglog(f,PSDrot,'r') %plot rotational contribution
        loglog(f,PSD,'k') %plot whole PSD
        legend('PSD_{trans}','PSD_{rot}','PSD_{sum}')
        hold off

%}    
    