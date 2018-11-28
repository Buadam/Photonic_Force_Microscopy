function [sigma2fix] = Findplateau(block,sigma2,t)
%Findplateau function finds the plateau value of the standard deviation.
%This is the fixpoint of the blocking transformation, which will give an
%unbiased estimation on the error of the MSD or VAF datapoint

diffs=diff(sigma2);

ind=find(diffs<0,1,'first');
if isempty(ind)
    disp('Standard variation has no plateau')
    mindiff=min(diffs(find(diffs>0)));
    ind=find(diffs==mindiff);
    x=ind;
    %[sigma2fix ind]=max(sigma2);
else
   disp('Standard variation plateau has found')
   x=ind-1+diffs(ind-1)/(diffs(ind-1)-diffs(ind));
   

end
sigma2fix=interp1(block,sigma2,x);

figure(5)
subplot(2,1,1)
plot(block,sigma2,'kx')
hold on 
line([0 block(end)],[sigma2fix sigma2fix],'Color','green')
hold off

subplot(2,1,2)
plot(1:1:block(end-1),diffs,'kx')
hold on
if ind>1
plot(ind,diffs(ind-1),'ro')
end
line([0 block(end)],[0 0],'Color','green')
hold off

saveas(gcf,['sigma2_VAF_t' num2str(t) '_us.png'])

end

