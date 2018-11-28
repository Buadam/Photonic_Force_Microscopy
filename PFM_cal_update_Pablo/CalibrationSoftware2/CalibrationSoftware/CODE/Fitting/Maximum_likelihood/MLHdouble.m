%Fitting algorithm
function [as,k,b,PSDrot,MSDrot,Confidence_lin,R,logpall,CovB,yFit,delta]=MLHdouble(pfree,pfix,T,etaf,rhos,rhof,psdx,msdx,vafx,select,weighting,fix,double,method)

%Selecting data to fit, recover data and their respective sizes
[xdata,ydata,errdata,sizePSD,sizeMSD,sizeVAF]=preprocess(select,psdx,msdx,vafx,weighting,method);

%taking the logarithm of the fitting parameters to avoid convergence to negative results
disp(['Initial Guess: ' num2str(pfree)])
logp0=log(pfree); 
logpfix=log(pfix); 
disp(['Log parameters: ' num2str(logp0)])

if weighting==1
    %Weighting by the inverse of the squares of the stdev (=errdata)
    w=1./errdata;
    ydata=w.*ydata; %weighted data
    modelfun=@(logpfree,xdata)w.*modelfunction(logpfree,logpfix,fix,T,etaf,rhos,rhof,psdx,msdx,vafx,select,xdata,sizePSD,sizeMSD,sizeVAF,double,method); %model function is weighted likewise
else
    modelfun=@(logpfree,xdata)modelfunction(logpfree,logpfix,fix,T,etaf,rhos,rhof,psdx,msdx,vafx,select,xdata,sizePSD,sizeMSD,sizeVAF,double,method); %unweighted model function
end
            
%Fitting
[logpfree,R,J,CovB] = nlinfit(xdata,ydata,modelfun,logp0); %non-linear fitting yields the fitted parameters, the residuals, and the covariance matrix 
[yFit, delta] = nlpredci(modelfun,xdata,logpfree,R,'cov',CovB); %predicting confidence intervals


disp(['Fitted Log parameters: ' num2str(logpfree)])
p=exp(logpfree); %calculating the fitted parameters from the transformed ones (ensures that they are positive)
disp(['Fitted parameters: ' num2str(p)]) 


Confidence_var = nlparci(logpfree,R,'cov',CovB); %confidence intervals for the fitted parameters 
Perror_var= sqrt(diag(CovB)); %error values estimated for the fitted parameters

%Transforming fitted logarithmic parameters and CI-s back to linear
i=1;
j=1;
%Sorting fixed and free parameters back into one array
for l=1:5
if fix(l)==1
    logpall(l)=logpfix(i);
    Confidence(l,:)=[logpfix(i) logpfix(i)];
    Perror(l)=0;
    i=i+1;
else
    logpall(l)=logpfree(j);
    Confidence(l,:)=Confidence_var(j,:);
    Perror(l)=Perror_var(j);
    j=j+1;
end
end
%Recovering all parameters and confidence intervals (fixed and free)
Confidence_lin=(exp(Confidence).*[0.1 0.1;10 10;1e3 1e3;1e-3 1e-3; 0.1 0.1]);
Perror_lin=(exp(Perror').*[0.1 ; 10; 1e3;1e-3;0.1]);

%Return values for the function
p=exp(logpall);
as=1e-7*p(1);
k=1e-5*p(2);
b=1e3*p(3);
PSDrot=p(4);
MSDrot=p(5);

sprintf('Confidence Intervals: \n %f \t %f \n %f \t %f \n %f \t %f \n %f \t %f \n %f \t %f \n %f \t %f \n %f \t %f \n',Confidence_lin')
sprintf('Parameter Errors: \n %f \n %f \n %f \n %f \n %f \n %f \n %f \n  ',Perror_lin')
            