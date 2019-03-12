function [bVAF]=betaVAF(vafx,t,t0,VAF)

%Finding scaling factor between theoretical VAF function and data points at
%the long time tail (until zero-crossing)


ind3=find(vafx(:,1)>3e-6,1); %first accurate data point 
ind4=find(vafx(:,1)>t0/3,1); % LTT until t=zero crossing/3 
help=ones(length(vafx(ind3:ind4,1)),1);
if help>0 %There are enough data points in LTT
    help=log(interp1(t,VAF,vafx(ind3:ind4,1)))-log(vafx(ind3:ind4,2));
    bVAF=exp(mean(help));   %bVAF found
else %not enough data in LTT, using the minimum of the VAF to align to the theoretical function
    disp('Not enough datapoints in LTT')
    disp('Calculating beta according to VAF minimum')
    %read out the minimum of the theoretical VAF
    help2=zeros(length(VAF),1);
    nn=0;
    help2(1)=VAF(1);
    for l=2:length(help2)
        help2(l)=VAF(l);
        if help2(l-1)/help2(l)<0
            nn=nn+1;
        end
        if nn>1 % minimum searched until second zero crossing
            break
        end    
    end
    VAFmintheo=abs(min(help2));
    VAFmin=-min(vafx(:,2));     
    bVAF=VAFmintheo/VAFmin; %bVAF found by alingning minima of the theoretical and experimental VAF
end