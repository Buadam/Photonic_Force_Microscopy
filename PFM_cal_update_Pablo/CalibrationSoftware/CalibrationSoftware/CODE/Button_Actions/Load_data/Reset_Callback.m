
% Resetting original PSD, MSD, VAF functions
function Reset_Callback(hObject, eventdata, handles)
global psdx msdx vafx

%default limits
set(handles.lowfreq,'string','0')
set(handles.highfreq,'string','1e6')
set(handles.shorttime,'string','1e-6')
set(handles.longtime,'string','1')

%Reading files again from the txt files specified in the textboxes
PSDName=get(handles.psdpath,'String');
MSDName=get(handles.msdpath,'String');
VAFName=get(handles.vafpath,'String');

    psdx=dlmread(PSDName,'\t',1,0);
    if size(psdx,2)==2
        psdx=[psdx zeros(size(psdx,1),1)];
    end
    msdx=dlmread(MSDName,'\t',1,0);
    if size(msdx,2)==2
        msdx=[msdx zeros(size(msdx,1),1)];
    end
    vafx=dlmread(VAFName,'\t',1,0);
    if size(vafx,2)==2
        msdx=[msdx zeros(size(msdx,1),1)];
    end
Plot_with_actual_parameters_Callback(hObject, eventdata, handles)
