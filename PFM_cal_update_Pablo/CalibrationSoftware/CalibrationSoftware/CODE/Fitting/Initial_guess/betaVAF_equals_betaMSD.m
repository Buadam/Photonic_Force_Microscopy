%Exit condition for the iteration to find the radius 
function [asmin,asmax,as,b,ready] = betaVAF_equals_betaMSD(asmin,asmax,as,bVAF,bMSD,eps,iter,maxiter)
if  2*abs(bVAF-bMSD)/(bVAF+bMSD)<eps   %exit condition on the relative difference between the two beta parameters
    ready=1;
    disp('beta fitting converged')
    b=(bVAF+bMSD)/2;   
elseif (iter>maxiter) %exit condition on the number of iterations
    ready=1;
    disp('iteration not converged')
    b=(bVAF+bMSD)/2;
%If the two beta parameters don't agree within tolerance, Newton interval 
% section is performed on initial radius 
else
    ready=0;
    if (bMSD>bVAF)
        asmin=as;
        as=(as+asmax)/2;
        b=bMSD;
    else
        asmax=as;
        as=(as+asmin)/2;
        b=bMSD;
    end
end