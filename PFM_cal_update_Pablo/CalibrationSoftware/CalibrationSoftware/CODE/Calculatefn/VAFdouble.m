function VAF = VAFdouble(tvaf,T,ms,mf,Drot,Taurot,s,b)
kb=1.38e-23;
VAFtr =  1e18/b*real((kb*T/(ms+0.5*mf))*(((s(1))^3*W(1i*s(1)*sqrt(tvaf))/((s(1)-s(2))*(s(1)-s(3))*(s(1)-s(4))) + ...
            (s(2))^3*W(1i*s(2)*sqrt(tvaf))/((s(2)-s(1))*(s(2)-s(3))*(s(2)-s(4))) + ...
            (s(3))^3*W(1i*s(3)*sqrt(tvaf))/((s(3)-s(1))*(s(3)-s(2))*(s(3)-s(4))) + ...
            (s(4))^3*W(1i*s(4)*sqrt(tvaf))/((s(4)-s(1))*(s(4)-s(2))*(s(4)-s(3))))));
VAFr= -2*Drot/Taurot*exp(-tvaf/Taurot);

VAF=VAFtr+VAFr;

%{
figure(102)
        loglog(tvaf,abs(VAFtr),'b') %plot translational contribution
        hold on
        loglog(tvaf,abs(VAFr),'r') %plot rotational contribution
        loglog(tvaf,abs(VAF),'k')  %plot whole VAF
        legend('VAF_{trans}','VAF_{rot}','VAF_{sum}')
        hold off
figure(103)      
        semilogx(tvaf,VAFtr,'b')
        hold on
        semilogx(tvaf,VAFr,'r')
        semilogx(tvaf,VAF,'k')
        legend('VAF_{trans}','VAF_{rot}','VAF_{sum}')
        hold off
%}