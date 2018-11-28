

% Export parameters and plots of current fitting
function Export_current_Callback(hObject, eventdata, handles)
global f t 
global PSD MSD VAF  
global psdx msdx vafx 
global b 
global Phis Phif Phik Phirot taus tauf tauk taurot 

%Create export file with header
    [FileName, PathName]=uiputfile('*.txt','Please create an output file for the fitting parameters');
    parameterfile=fullfile(PathName,FileName);
    set(handles.exportfolder,'string',PathName)
    set(handles.exportfile,'string',FileName)
    set(handles.statusbar,'string','New measurement file created')
    drawnow;
    parameters=fopen(parameterfile,'a+');
    fprintf(parameters,'a0(um) \t amin(um) \t amax(um) \t afit(um) \t k0(uN/m) \t kmin(uN/m) \t kmax(uN/m) \t kfit(uN/m) \t b0(uN/m) \t bmin(V^2/nm^2) \t bmax(V^2/nm^2) \t bfit(V^2/nm^2) \t psd0(V^2/Hz) \t  psdmin(V^2/Hz) \t  psdmax(V^2/Hz) \t  psdfit(V^2/Hz) \t msd0(V^2) \t  msdmin(V^2) \t  msdmax(V^2) \t  msdfit(V^2)\n ');

%%
%WRITING FITTED PARAMETERS TO FILE

%Reading Initial parameters
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
plot_hold(t,psdx,msdx,vafx,taus,tauf,tauk,taurot,f,PSD,MSD,VAF,Phis,Phif,Phik,Phirot,b,double,[1 0 0],0,FileName,PathName)     


%%
%SAVING FITTED FUNCTIONS   
%Create file for fitting data
data = fopen(fullfile(PathName, [strrep(FileName,'.txt','') '_FittedFunctions'  '.txt']), 'w');
fprintf(data,'f(Hz) \t psddata \t psderror \t f(Hz) \t psdfit \t t(s) \t msddata \t msderror \t t(s) \t msdfit \t t(s) \t vafdata \t vaferror \t t(s) \t vaffit \n');
   
SAVE=zeros(max(size(msdx),size(psdx)),15); 
SAVE(1:size(psdx),1:3)=[psdx(:,1) b*psdx(:,2:3)];
SAVE(1:size(f,2),4:5)=[f' PSD']; 
SAVE(1:size(msdx),6:8)=[msdx(:,1) b*msdx(:,2:3)]; 
SAVE(1:size(t,2),9:10)=[t' MSD'];
SAVE(1:size(vafx),11:13)=abs([vafx(:,1) b*vafx(:,2:3)]);
SAVE(1:size(t,2),14:15)=[t' abs(VAF')];
dlmwrite(fullfile(PathName, [strrep(FileName,'.txt','') '_FittedFunctions'  '.txt']),SAVE,'delimiter', '\t', '-append')
fclose(data);
%%

set(handles.statusbar,'string','Fitting saved successfully')
