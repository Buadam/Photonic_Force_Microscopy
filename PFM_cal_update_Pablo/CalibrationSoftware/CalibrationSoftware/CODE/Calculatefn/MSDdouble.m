function MSD=MSDdouble(tmsd,D,taus,tauf,tauk,Taurot,MSDrot,s,b)

MSDtr =  1e18/b*real((2*D*tauk + ((2*D)/(taus+tauf/9))*(W(1i*s(1)*sqrt(tmsd))/(s(1)*(s(1)-s(2))*(s(1)-s(3))*(s(1)-s(4))) + ...
        W(1i*s(2)*sqrt(tmsd))/(s(2)*(s(2)-s(1))*(s(2)-s(3))*(s(2)-s(4))) + ... 
        W(1i*s(3)*sqrt(tmsd))/(s(3)*(s(3)-s(1))*(s(3)-s(2))*(s(3)-s(4))) + ...
        W(1i*s(4)*sqrt(tmsd))/(s(4)*(s(4)-s(1))*(s(4)-s(2))*(s(4)-s(3))))));
MSDr=MSDrot*(1-exp(-tmsd/Taurot));
MSD=MSDtr+MSDr;

%{
figure(101)
        loglog(tmsd,MSDtr,'b') %plot translational contribution
        hold on
        loglog(tmsd,MSDr,'r') %plot rotational contribution
        loglog(tmsd,MSD,'k') %plot whole function
        legend('MSD_{trans}','MSD_{rot}','MSD_{sum}')
        hold off
%}