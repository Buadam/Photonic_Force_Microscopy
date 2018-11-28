
%Iteration to refine the spring constant, aligning theoretical curve to the
%MSD data
function [k,iter]=refine_kMSD(t,MSD,msdx,as,kVAF,b,taus,tauf,tauk,etaf,D,eps)
%initial parameters for the iteration
iter=0;
ready=0;
kmin=0;
k=kVAF;
kmax=10*kVAF;

while ready==0
 MSD_tauk=interp1(t,MSD,tauk)/b; %Find the theoretical MSD value at tauk (relaxation time for the trapped bead)
 msdx_tauk=interp1(msdx(:,1),msdx(:,2),tauk);   %aligning curves at relaxation time (corner time)
 if (2*abs(MSD_tauk-msdx_tauk)/(MSD_tauk+msdx_tauk) < eps) %exit condition
     ready=1;
     disp('k konverged')
 elseif (iter>30) %maximal iteration number
     ready=1;
     disp('iteration not converged')
 else
       
     ready=0;
    %Newton iteration 
    if  MSD_tauk < msdx_tauk
        kmax=k;
        k=(kmin+k)/2;
    else
        kmin=k;
        k=(kmax+k)/2;
        
    end
    
    %Calculation of new MSD function
    tauk=6*pi*etaf*as/k;
    
    eq = [taus+(tauf/9) -sqrt(tauf) 1 0 1/tauk];
    s = roots(eq);

    MSD =  1e18*real((2*D*tauk + ((2*D)/(taus+tauf/9))*(W(1i*s(1)*sqrt(t))/(s(1)*(s(1)-s(2))*(s(1)-s(3))*(s(1)-s(4))) + ...
    W(1i*s(2)*sqrt(t))/(s(2)*(s(2)-s(1))*(s(2)-s(3))*(s(2)-s(4))) + ... 
    W(1i*s(3)*sqrt(t))/(s(3)*(s(3)-s(1))*(s(3)-s(2))*(s(3)-s(4))) + ...
    W(1i*s(4)*sqrt(t))/(s(4)*(s(4)-s(1))*(s(4)-s(2))*(s(4)-s(3))))));
    
 end
  iter=iter+1;
end