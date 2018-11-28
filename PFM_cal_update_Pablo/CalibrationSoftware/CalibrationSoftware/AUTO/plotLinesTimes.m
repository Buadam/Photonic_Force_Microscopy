%%%%%%%%%%%%%%%%%%%%
% Lines with temporal scales for plots
%%%%%%%%%%%%%%%%%%%%
function plotLinesTimes(  mindata,maxdata,tmk, labeltmk,tk, labeltk,tpeff,labeltpeff,tf,labeltf,tfit1,labeltfit1,tfit2,labeltfit2)
  line([log10(tmk) log10(tmk)], [log10(mindata) log10(maxdata)],'color','red')
  text(log10(tmk),log10(maxdata), labeltmk,'color','red')
  line([log10(tk) log10(tk)], [log10(mindata) log10(maxdata)],'color','black')
  text(log10(tk),log10(mindata), labeltk,'color','black')
  line([log10(tpeff) log10(tpeff)], [log10(mindata) log10(maxdata)],'color','cyan')
  text(log10(tpeff),log10(mindata), labeltpeff,'color','cyan')
  line([log10(tf) log10(tf)], [log10(mindata) log10(maxdata)],'color','blue')
  text(log10(tf),log10(maxdata), labeltf,'color','blue')
  line([log10(tfit1) log10(tfit1)], [log10(mindata) log10(maxdata)],'color','green')
  text(log10(tfit1),log10(mindata), labeltfit1,'color','green')
  line([log10(tfit2) log10(tfit2)], [log10(mindata) log10(maxdata)],'color','green')
  text(log10(tfit2),log10(mindata), labeltfit2,'color','green')

end
