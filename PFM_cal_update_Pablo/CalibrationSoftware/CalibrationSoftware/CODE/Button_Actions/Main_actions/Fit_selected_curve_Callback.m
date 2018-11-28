
% ---Fitting data with the previously selected options. 
function [as,k,b,PSDrot,MSDrot,Confidence_lin,R,logp,CovB]=Fit_selected_curve_Callback(hObject, eventdata, handles)

%Experimental parameters
global kb; kb=1.38e-23;
global T; T=get(handles.T,'string'); T=273.15+str2double(T);
global etaf; etaf=get(handles.etaf,'string'); etaf=1e-3*str2double(etaf);
global rhos; rhos=get(handles.rhos,'string'); rhos=1e3*str2double(rhos);
global rhof; rhof=get(handles.rhof,'string'); rhof=1e3*str2double(rhof);
%Experimental data
global psdx msdx vafx
%Settings
global weighting select fix double
%Error flag
global fiterr

fiterr=0;
%%
%OPTIONS
weighting=get(handles.weighting,'value'); %Weighting by the error of datapoints
select=[get(handles.fitpsd,'value') get(handles.fitmsd,'value') get(handles.fitvaf,'value')]; %Select functions to fit by Maximum Likelihood
fix=[get(handles.fixa,'value') %Fixed variables
    get(handles.fixk,'value') 
    get(handles.fixbeta,'value') 
    get(handles.fixP,'value') 
    get(handles.fixM,'value')];
double=get(handles.double,'Value'); %Non-spherical model: double plateau fitting
origdouble=double;

%%Checking if functions are loaded
if select(1)==1 %PSD fit is selected
    if isempty(psdx)
        msgbox('PSD file not loaded. Performing fitting without PSD', 'Warning!','Warn');
        select(1)=0;
        set(handles.fitpsd,'value',0)
    end
end
if select(2)==1 %MSD fit is selected
    if isempty(msdx)
        msgbox('MSD file not loaded. Performing fitting without MSD', 'Warning!','Warn');
        select(2)=0;
        set(handles.fitmsd,'value',0)
    end
end
if select(3)==1 %PSD fit is selected
    if isempty(vafx)
        msgbox('VAF file not loaded. Performing fitting without VAF', 'Warning!','Warn');
        select(3)=0;
        set(handles.fitvaf,'value',0)
    end
end

%%Deleting previous results
set(handles.as0,'string',''); set(handles.asfit,'string',''); set(handles.amin,'string',''); set(handles.amax,'string',''); 
set(handles.k0,'string',''); set(handles.kfit,'string',''); set(handles.kmin,'string',''); set(handles.kmax,'string',''); 
set(handles.b0,'string',''); set(handles.bfit,'string',''); set(handles.bmin,'string',''); set(handles.bmax,'string',''); 
set(handles.PSDmax0,'string',''); set(handles.PSDmaxfit,'string',''); set(handles.PSDmaxmin,'string',''); set(handles.PSDmaxmax,'string',''); 
set(handles.MSDmax0,'string',''); set(handles.MSDmaxfit,'string',''); set(handles.MSDmaxmin,'string',''); set(handles.MSDmaxmax,'string',''); 

%%
%Start Fitting
%Initial Guess

if double==0 %Single plateau fitting
   if get(handles.automatic_initguess,'value')==1 %Automatic initial guess
     %Obtain initial guess for radius, spring constant and sensitivity
     [as0,k0,b0]=Initialguess_Callback(hObject, eventdata, handles);
   else %Manual initial guess
     as0=1e-6*str2double(get(handles.as,'string'));
     k0=1e-6*str2double(get(handles.k,'string'));
     b0=str2double(get(handles.b,'string'));
     set(handles.as0,'String',num2str(as0*1e6,'%6.2f'))
    set(handles.k0,'String',num2str(k0*1e6),'%6.2f')
    set(handles.b0,'String',num2str(b0),'%6.2f')
   set(handles.PSDmax0,'String','0')
   set(handles.MSDmax0,'String','0') 
   end    
     PSDrot0=0; %Spherical model: no double plateau
     MSDrot0=0;
else %Non-spherical model: double plateau fitting
   if get(handles.automatic_initguess,'value')==1 %Automatic initial guess
     [as0,k0,b0,PSDrot0,MSDrot0]=Initialguess_Callback(hObject, eventdata, handles);
   else %Manual initial guess
     as0=1e-6*str2double(get(handles.as,'string'));
     k0=1e-6*str2double(get(handles.k,'string'));
     b0=str2double(get(handles.b,'string'));  
     PSDrot0=str2double(get(handles.PSDmax,'string'));  
     MSDrot0=str2double(get(handles.MSDmax,'string'));  
     set(handles.as0,'String',num2str(as0*1e6,'%6.2f'))
    set(handles.k0,'String',num2str(k0*1e6,'%6.2f'))
    set(handles.b0,'String',num2str(b0,'%6.2f'))
    set(handles.PSDmax0,'String',num2str(PSDrot0,'%6.5f'))
    set(handles.MSDmax0,'String',num2str(MSDrot0,'%6.2f'))
   end
end
%End 
    

%Maximum Likelihood Fitting 
[as,k,b,PSDrot,MSDrot,Confidence_lin,R,logp,CovB]=MaxLikelihood_Callback(hObject, eventdata, handles,as0,k0,b0,PSDrot0,MSDrot0);

if (double==1) && ((PSDrot<1e-6) || (MSDrot<1e-4))  %No double plateau found, trying to fit single plateau
    set(handles.statusbar,'String','No apparent double plateau found by algorithm. Fitting spherical model:')
    disp('No apparent double plateau found by algorithm. Fitting spherical model:')
    double=0;
    %setting spherical model
    set(handles.double,'value',0)
    set(handles.single,'value',1)
    drawnow
    [as0,k0,b0]=Initialguess_Callback(hObject, eventdata, handles);
    [as,k,b,PSDrot,MSDrot,Confidence_lin,R,logp,CovB]=MaxLikelihood_Callback(hObject, eventdata, handles,as0,k0,b0,0,0);
    fiterr=1; %Error flag set in exported txt file
    
end

%Plotting in GUI
Calculate_Callback(hObject, eventdata, handles)
Plot_Callback(hObject, eventdata, handles)

if get(handles.Global,'value')==1 %Global minimalization selected
    %finding global minimum by starting algorithm from multiple initial
    %points
    Find_global_min_Callback(hObject, eventdata, handles)
    %Plotting result with the lowest residual
    Calculate_Callback(hObject, eventdata, handles)
    Plot_Callback(hObject, eventdata, handles)  
end
