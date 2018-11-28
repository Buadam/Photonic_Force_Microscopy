

%changing value of MSDmax
function MSDmax_Callback(hObject, eventdata, handles)
global rapid
rapid=1;
set(handles.MSDslider,'Value',str2double(get(handles.MSDmax,'String')));
Calculate_Callback(hObject, eventdata, handles)
Plot_Callback(hObject, eventdata, handles)