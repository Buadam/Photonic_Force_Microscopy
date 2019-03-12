%changing value of the Radius
function as_Callback(hObject, eventdata, handles)
global rapid
rapid=1;
set(handles.aslider,'Value',str2double(get(handles.as,'String')));
Calculate_Callback(hObject, eventdata, handles)
Plot_Callback(hObject, eventdata, handles)