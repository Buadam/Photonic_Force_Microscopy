%%%%%%%%%%%%%%%%%%%%%
%  read out the minimum of the theoretical VAF
%%%%%%%%%%%%%%%%%%%%%%
function [retval] = findMinVAF (VAFth)

  %read out the minimum of the theoretical VAF
  help=zeros(length(VAFth),1);
  nn=0;
  help(1)=VAFth(1,2);
  for i=2:length(help)
      help(i)=VAFth(i,2);
      if help(i-1)/help(i)<0
          nn=nn+1;
      end
      if nn>1
        break
      end    
  end
  
  retval=abs(min(help));
  
end
