% --- Calculate Functions
function Calculate_Callback(hObject, eventdata, handles)

global rapid
global f
global t 

%x axis coordinates

if rapid==1 %Lower resolution for rapid plotting (upon real-time setting of parameters)
    f=logspace(-1,7,100);
    t=logspace(-6,0,100);
    
else %Higher resolution for accurate plotting ('Plot with actual parameters' button)
    f=logspace(-1,7,1000);
    t=logspace(-6,0,1000);
end

%general parameters
global kb; kb=1.38e-23;
global T; T=get(handles.T,'string'); T=273.15+str2double(T);
global etaf; etaf=get(handles.etaf,'string'); etaf=1e-3*str2double(etaf);
global rhos; rhos=get(handles.rhos,'string'); rhos=1e3*str2double(rhos);
global rhof; rhof=get(handles.rhof,'string'); rhof=1e3*str2double(rhof);
%variable parameters
global as; as=str2double(get(handles.as,'String'))*1e-6;
global k; k=str2double(get(handles.k,'String'))*1e-6;
global b; b=str2double(get(handles.b,'String'));
global MSDmax; 
global PSDmax; 
global PSDrot MSDrot
global Phis Phif Phik Phirot taus tauf tauk taurot D Drot
global PSD MSD VAF 

%calculating the mass of the particle and the fluid of equivalent volume
    ms=as^3*4/3*pi*rhos;
    mf=as^3*4/3*pi*rhof;

if get(handles.double,'value')==1 %If 'Non-spherical' model is selected
    MSDrot=str2double(get(handles.MSDmax,'String')); %second plateau value for the MSD
    PSDrot=str2double(get(handles.PSDmax,'String')); %second plateau value for the PSD
    MSDmax=MSDrot+2*kb*T/k/b*1e18; %sum of the plateau values for translation and rotation for the MSD
    PSDmax=PSDrot+24*kb*T*as*etaf/k^2/b*1e18*pi; %sum of the plateau values for translation and rotation for the PSD
    taurot=PSDrot/MSDrot/2; %Time scale of the rotational relaxation
    Drot=MSDrot/taurot/2; %Rotational diffusion constant
    if MSDrot<0 %negative plateau value is not a physical solution
        set(handles.statusbar,'string','Warning: negative MSDrot')
        drawnow;
    end
    if PSDrot<0 %negative plateau value is not a physical solution
        set(handles.statusbar,'string','Warning: negative PSDrot')
    end
else %'Spherical' model
    %setting rotational parameters to yield zero rotational PSD, MSD and
    %VAF
    taurot=0.001; 
    MSDrot=0; 
    PSDrot=0.001;
    Drot=0;
end
    
%Calculated time and frequency scales    
    taus=(2*as^2*rhos)/(9*etaf);
    tauf=as^2*rhof/etaf;             
    tauk=6*pi*etaf*as/k;            
    Phik=1/(2*pi*tauk);
    Phis=1/(2*pi*taus);
    Phif=1/(2*pi*tauf);
    Phirot=1/2/pi/taurot;
      
    D=kb*T/(6*pi*etaf*as);
    
    set(handles.taurot,'String',num2str(taurot));
    
    
%Calculating PSD
PSD=PSDdouble(f,D,Drot,Phis,Phif,Phik,Phirot,b)*b; %calibrated to distance units (nm^2/Hz)
%Calculating MSD
eq = [taus+(tauf/9) -sqrt(tauf) 1 0 1/tauk];
s = roots(eq);
MSD =MSDdouble(t,D,taus,tauf,tauk,taurot,MSDrot,s,b)*b; %calibrated to distance units (nm^2)
%Calculating VAF
VAF =  VAFdouble(t,T,ms,mf,Drot,taurot,s,b)*b; %calibrated to distance units (nm^2/s^2)


 