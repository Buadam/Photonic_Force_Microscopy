
%moving slider of b
function bslider_Callback(hObject, eventdata, handles)
global rapid
rapid=1;
set(handles.b,'string',num2str(get(handles.bslider,'value')));
Calculate_Callback(hObject, eventdata, handles)
Plot_Callback(hObject, eventdata, handles)