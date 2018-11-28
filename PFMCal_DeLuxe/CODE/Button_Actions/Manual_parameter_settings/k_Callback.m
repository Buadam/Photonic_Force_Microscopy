%changing value of k
function k_Callback(hObject, eventdata, handles)
global rapid
rapid=1;
set(handles.kslider,'Value',str2double(get(handles.k,'String')));
Calculate_Callback(hObject, eventdata, handles)
Plot_Callback(hObject, eventdata, handles)