

% Export parameters and plots of current fitting
function Export_all_Callback(hObject, eventdata, handles,str,actual,parameterfile)
global f t 
global PSD MSD VAF  
global psdx msdx vafx 
global b 
global Phis Phif Phik Phirot taus tauf tauk taurot 
    [PathName,FileName ext] = fileparts(parameterfile);
    set(handles.exportfolder,'string',PathName)
    set(handles.exportfile,'string',[FileName ext])
    set(handles.statusbar,'string','New measurement file created')
    drawnow;
    parameters=fopen(parameterfile,'a+');
   

%%
%WRITING FITTED PARAMETERS TO FILE

%Reading initial guesses
a0=str2double(get(handles.as0,'String')); 
k0=str2double(get(handles.k0,'String'));
b0=str2double(get(handles.b0,'String'));
psd0=str2double(get(handles.PSDmax0,'String'));
msd0=str2double(get(handles.MSDmax0,'String'));

%Reading Fitted parameters
asfit=str2double(get(handles.asfit,'String'));
kfit=str2double(get(handles.kfit,'String'));
bfit=str2double(get(handles.bfit,'String'));
psdfit=str2double(get(handles.PSDmaxfit,'String'));
msdfit=str2double(get(handles.MSDmaxfit,'String'));
%Reading Confidence intervals            
amin=str2double(get(handles.amin,'String'));
amax=str2double(get(handles.amax,'String'));
kmin=str2double(get(handles.kmin,'String'));
kmax=str2double(get(handles.kmax,'String'));
bmin=str2double(get(handles.bmin,'String'));
bmax=str2double(get(handles.bmax,'String'));
psdmaxmin=str2double(get(handles.PSDmaxmin,'String'));
psdmaxmax=str2double(get(handles.PSDmaxmax,'String'));
msdmaxmin=str2double(get(handles.MSDmaxmin,'String'));
msdmaxmax=str2double(get(handles.MSDmaxmax,'String'));

%Writing parameters to parameterfie
fprintf(parameters,'%f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \n',a0,amin,amax,asfit,k0,kmin,kmax,kfit,b0,bmin,bmax,bfit,psd0,psdmaxmin,psdmaxmax,psdfit,msd0,msdmaxmin,msdmaxmax,msdfit);
fclose(parameters);
%%

%Saving graphs
double=get(handles.double,'value');

plot_hold(t,psdx,msdx,vafx,taus,tauf,tauk,taurot,f,PSD,MSD,VAF,Phis,Phif,Phik,Phirot,b,double,[1 0 0],0,[num2str(actual) FileName ext],PathName)     


%%
%SAVING FITTED FUNCTIONS   
%Create file for fitting data
data = fopen(fullfile(PathName, [strrep(FileName,'.txt','') '_FittedFunctions' num2str(actual) '.txt']), 'w');
fprintf(data,'f(Hz) \t psddata \t psderror \t f(Hz) \t psdfit \t t(s) \t msddata \t msderror \t t(s) \t msdfit \t t(s) \t vafdata \t vaferror \t t(s) \t vaffit \n');
   
SAVE=zeros(max(size(msdx),size(psdx)),15); 
SAVE(1:size(psdx),1:3)=psdx; 
SAVE(1:size(f,2),4:5)=[f' PSD'/b]; 
SAVE(1:size(msdx),6:8)=msdx; 
SAVE(1:size(t,2),9:10)=[t' MSD'/b];
SAVE(1:size(vafx),11:13)=abs(vafx);
SAVE(1:size(t,2),14:15)=[t' abs(VAF')/b];
dlmwrite(fullfile(PathName, [strrep(FileName,'.txt','') '_FittedFunctions' num2str(actual) '.txt']),SAVE,'delimiter', '\t', '-append')
fclose(data);
%%

set(handles.statusbar,'string','Fitting saved successfully')
