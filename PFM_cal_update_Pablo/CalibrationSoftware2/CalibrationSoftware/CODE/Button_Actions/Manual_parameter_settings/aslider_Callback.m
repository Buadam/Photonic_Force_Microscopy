
%moving slider of Radius
function aslider_Callback(hObject, eventdata, handles)
global rapid
rapid=1;
set(handles.as,'string',num2str(get(handles.aslider,'value')));
Calculate_Callback(hObject, eventdata, handles)
Plot_Callback(hObject, eventdata, handles)