
% --- Performing maximum likelihood fitting.
function [as,k,b,PSDrot,MSDrot,Confidence_lin,R,logp,CovB]=MaxLikelihood_Callback(hObject, eventdata, handles,as0,k0,b0,PSDrot0,MSDrot0)

%Reading Constant parameters
global T etaf rhos rhof 
global psdx msdx vafx
global weighting select fix double method


%%
%Performing Maximum Likelihood Fitting
if select==[0 0 0] %If no functions are selected to fit
    disp('Spherical model Fitted without Maximum Likelihood algorithm')
    set(handles.statusbar,'String','Spherical model Fitted without Maximum Likelihood algorithm')
    %initial guess values returned
    as=as0;
    k=k0;
    b=b0;
    PSDrot=PSDrot0;
    MSDrot=MSDrot0;
    %no confidence intervals estimated
    Confidence_lin=zeros(5,2); 
    R=[];
    logp=zeros(1,5);
    CovB=zeros(5,5);
 try 
    set(handles.as,'String',num2str(as0*1e6,'%6.2f'))
    set(handles.aslider,'Value',as0*1e6)
    set(handles.k,'String',num2str(k0*1e6),'%6.2f')
    set(handles.kslider,'Value',k0*1e6)
    set(handles.b,'String',num2str(b0),'%6.2f')
    set(handles.bslider,'Value',b0)
 catch %so that type mismatch does not stop program run
    set(handles.as,'String',num2str(as0*1e6))
    set(handles.k,'String',num2str(k0*1e6))
    set(handles.b,'String',num2str(b0))
 end  
    drawnow;
    
else %if at least one function is checked under 'Functions to fit' menu
    disp('Performing Maximum Likelihood algorithm')
    set(handles.statusbar,'String','Performing Maximum Likelihood Fitting')
    drawnow;
    disp('Performing Maximum Likelihood Fitting')
    %Maximum Likelihood Fitting
    
    %Preprocessing
    neg=0; 
    if double==1 %If 'Non-spherical' model is selected
            set(handles.statusbar,'String','Non-spherical fitting')
            PSDrot=PSDrot0;
            MSDrot=MSDrot0;
            set(handles.PSDmax0,'String',num2str(PSDrot,'%6.2f'))
            set(handles.MSDmax0,'String',num2str(MSDrot,'%6.2f'))
    end
   
    if (double==0)
            set(handles.statusbar,'String','Spherical fitting')
            double=0;
            set(handles.PSDmax,'string','0')
            set(handles.MSDmax,'string','0')
            PSDrot=0; MSDrot=0;
            fix(4:5)=1;
    end
    %Sorting fixed and free variables
            asset=str2double(get(handles.as,'string'));
            kset=str2double(get(handles.k,'string'));
            bset=str2double(get(handles.b,'string'));
            PSDset=str2double(get(handles.PSDmax,'string'));
            MSDset=str2double(get(handles.MSDmax,'string'));
                        
            p0=[as0*1e7 k0*1e5 b0*1e-3 1e3*PSDrot 10*MSDrot]; %converting parameters to the order of magnitude of 1
            pset=[asset*10 kset*0.1 bset*1e-3 1e3*PSDset 10*MSDset];  %converting parameters to the order of magnitude of 1
            
            pfree=p0(find(fix==0)); %Free parameters
            pfix=pset(find(fix)); %Fixed parameters
            
    %Performing Maximum Likelihood Fitting        
try
           
            method=get(handles.logarithmic,'value'); %linear or logarithmic transformation
            [as,k,b,PSDrot,MSDrot,Confidence_lin,R,logp,CovB,yFit,delta]=MLHdouble(pfree,pfix,T,etaf,rhos,rhof,psdx,msdx,vafx,select,weighting,fix,double,method); %start fitting
            set(handles.statusbar,'string','Fitting successful')
    
    if (double==1) && ((PSDrot<1e-6) || (MSDrot<1e-4)) %no double plateau found
             error=1;
    else
             error=0;
    end
  
catch err % MLH Fitting not successful
     
        disp(err) %error log displayed
            error=1;
            set(handles.statusbar,'string','An error occured')
            as=str2double(get(handles.as,'string'))*1e-6;
            k=str2double(get(handles.k,'string'))*1e-6;
            b=str2double(get(handles.b,'string'));
            PSDrot=0;
            MSDrot=0;
            p=[as k b PSDrot MSDrot];
            logp=[log(as) log(k) log(b) 0 0];
            Confidence_lin(4:5,:)=[0 0; 0 0];
            R=0;
            CovB=0;
    end
  
    if (error ==0) %if there were no errors
            %Displaying results
            set(handles.asfit,'String',num2str(as*1e6,'%6.2f'))
            set(handles.kfit,'String',num2str(k*1e6,'%6.2f'))
            set(handles.bfit,'String',num2str(b,'%6.2f'))
            set(handles.PSDmaxfit,'String',num2str(1e-3*PSDrot,'%6.5f'))
            set(handles.MSDmaxfit,'String',num2str(0.1*MSDrot,'%6.2f'))
            set(handles.amin,'String',num2str(Confidence_lin(1,1),'%6.2f'))
            set(handles.amax,'String',num2str(Confidence_lin(1,2),'%6.2f'))
            set(handles.kmin,'String',num2str(Confidence_lin(2,1),'%6.2f'))
            set(handles.kmax,'String',num2str(Confidence_lin(2,2),'%6.2f'))
            set(handles.bmin,'String',num2str(Confidence_lin(3,1),'%6.2f'))
            set(handles.bmax,'String',num2str(Confidence_lin(3,2),'%6.2f'))
            set(handles.PSDmaxmin,'String',num2str(Confidence_lin(4,1),'%6.5f'))
            set(handles.PSDmaxmax,'String',num2str(Confidence_lin(4,2),'%6.5f'))
            set(handles.MSDmaxmin,'String',num2str(Confidence_lin(5,1),'%6.2f'))
            set(handles.MSDmaxmax,'String',num2str(Confidence_lin(5,2),'%6.2f'))
            set(handles.as,'String',num2str(as*1e6,'%6.2f'))
            set(handles.aslider,'Value',as*1e6)
            set(handles.k,'String',num2str(k*1e6,'%6.2f'))
            set(handles.kslider,'Value',k*1e6)
            set(handles.b,'String',num2str(b,'%6.2f'))
            set(handles.bslider,'Value',b)
            set(handles.PSDmax,'String',num2str(1e-3*PSDrot,'%6.5f'))
            set(handles.PSDslider,'Value',1e-3*PSDrot)
            set(handles.MSDmax,'String',num2str(0.1*MSDrot,'%6.2f'))
            set(handles.MSDslider,'Value',0.1*MSDrot)  
    end
          
%%
end %if MLH fitting  


if get(handles.showfit,'value')==1    %Show actual fit in separate windows 
    if (~isempty(psdx) && get(handles.fitpsd,'value'))
        plotselect=[1 0 0]; %plot PSD
        showfits(psdx,msdx,vafx,logp,yFit,delta,plotselect,weighting,method,1,handles)
    end
    if (~isempty(msdx) && get(handles.fitmsd,'value'))
        plotselect=[0 1 0]; %plot MSD
        showfits(psdx,msdx,vafx,logp,yFit,delta,plotselect,weighting,method,2,handles)
    end
    if (~isempty(vafx) && get(handles.fitvaf,'value'))
        plotselect=[0 0 1]; %plot VAF
        showfits(psdx,msdx,vafx,logp,yFit,delta,plotselect,weighting,method,3,handles)
    end
end



