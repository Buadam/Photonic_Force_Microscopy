   
%changing value of the sensitivity
function b_Callback(hObject, eventdata, handles)
global rapid
rapid=1;
set(handles.bslider,'Value',str2double(get(handles.b,'String')));
Calculate_Callback(hObject, eventdata, handles)
Plot_Callback(hObject, eventdata, handles)
