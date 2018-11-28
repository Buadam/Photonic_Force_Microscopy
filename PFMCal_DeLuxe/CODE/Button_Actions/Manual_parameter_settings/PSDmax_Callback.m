

%changing value of PSDmax
function PSDmax_Callback(hObject, eventdata, handles)
global rapid
rapid=1;
set(handles.PSDslider,'Value',str2double(get(handles.PSDmax,'String')));
Calculate_Callback(hObject, eventdata, handles)
Plot_Callback(hObject, eventdata, handles)