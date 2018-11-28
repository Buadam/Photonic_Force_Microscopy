% --- Provides initial guess for the fitting
function [as,k,b,PSDrot,MSDrot]=Initialguess_Callback(hObject, eventdata, handles)

global psdx msdx vafx
global T etaf rhos rhof 

set(handles.statusbar,'String','Calculating Initial Guess')
drawnow;
%initial parameters
as0=0.5*1e-6;  %um
asmin=0.3*1e-6;
asmax=2*1e-6;
k0=10*1e-6;

%exit condition
eps=0.001; %0.1% difference in betaVAF and betaMSD
maxiter=30; %maximum number of iterations

%Creating time array for theoretical MSD and VAF amd frequency array for
%PSD
if ~isempty(msdx)
    mint=floor(log10(msdx(1,1)));
    maxt=ceil(log10(msdx(end,1)));
    t=logspace(mint,maxt,1000);
elseif ~isempty(vafx)
    mint=floor(log10(vafx(1,1)));
    maxt=ceil(log10(vafx(end,1)));
    t=logspace(mint,maxt,1000);
else
    t=logspace(-6,-2,1000);
end
if ~isempty(psdx)
    minf=floor(log10(psdx(1,1)));
    maxf=ceil(log10(psdx(end,1)));
    f=logspace(minf,maxf,1000);
else
    f=logspace(0,6,1000);
end
%Start Initial guess
if ~isempty(vafx)
    %Perform single plateau fitting using zero-crossing of VAF (M.Grimm et al.)
    [as,k,b] = fit_singleplateau(f,t,psdx,msdx,vafx,rhos,rhof,etaf,T,as0,k0,asmin,asmax,maxiter,eps);
    %displaying initial guesses in 'Fitting report' menu
    set(handles.as0,'String',num2str(as*1e6,'%6.2f'))
    set(handles.k0,'String',num2str(k*1e6,'%6.2f'))
    set(handles.b0,'String',num2str(b,'%6.2f'))
else
    %Obtain initial values from manual setting
    as=1e-6*str2double(get(handles.as,'string'));
    k=1e-6*str2double(get(handles.k,'string'));
    b=str2double(get(handles.b,'string'));
end
if (~isempty(psdx))
    %calculating second PSD plateau value from the initial guesses and the
    %experimental data
    [PSDrot,~,neg]=maxvalues(psdx,msdx,as,b,k,etaf,T);
else
    PSDrot=str2double(get(handles.PSDmax,'string'));
end
if (~isempty(msdx))
    %calculating second MSD plateau value from the initial guesses and the
    %experimental data
    [~,MSDrot,neg]=maxvalues(psdx,msdx,as,b,k,etaf,T);
else
    MSDrot=str2double(get(handles.MSDmax,'string'));
end